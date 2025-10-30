// [id].tsx
import React from 'react';
import {
    Text,
    View,
    ScrollView,
    StyleSheet,
    TouchableOpacity,
    // Image,
    // FlatList,
    ActivityIndicator, // For loading state
    Alert, // For showing alerts
} from 'react-native';
import { Stack, useLocalSearchParams } from "expo-router";
import { useGetSCCRecordQuery } from '@/services/SCC/queries';
import { SCCRecord } from '@/types/sccTypes';

import RNHTMLtoPDF from 'react-native-html-to-pdf'; 


// Helper function to format currency
const formatCurrency = (amount: number) => {
    return `XAF ${amount.toLocaleString()}`;
};

// --- HELPER COMPONENTS (No changes needed, they will be used to structure the HTML) ---
const DetailRow = ({ label, value }: { label: string, value: string | number }) => (
    <View className="flex-row justify-between p-4 border-b border-gray-200 bg-white">
        <Text className="text-base text-gray-500 font-medium">{label}</Text>
        <Text className="text-base text-gray-800 font-semibold">{value}</Text>
    </View>
);

const AttendanceBlock = ({ men, women, youth, catechumen, total }: { men: number, women: number, youth: number, catechumen: number, total: number }) => (
    <View className="mt-4 p-4 rounded-xl bg-indigo-50 border border-indigo-200 mx-4">
        <Text className="text-lg font-bold text-indigo-700 mb-2">Attendance Summary</Text>
        <View style={styles.attendanceRow}>
            <Text style={styles.attendanceLabel}>Men:</Text>
            <Text style={styles.attendanceValue}>{men}</Text>
        </View>
        <View style={styles.attendanceRow}>
            <Text style={styles.attendanceLabel}>Women:</Text>
            <Text style={styles.attendanceValue}>{women}</Text>
        </View>
        <View style={styles.attendanceRow}>
            <Text style={styles.attendanceLabel}>Youth:</Text>
            <Text style={styles.attendanceValue}>{youth}</Text>
        </View>
        <View style={styles.attendanceRow}>
            <Text style={styles.attendanceLabel}>Catechumen:</Text>
            <Text style={styles.attendanceValue}>{catechumen}</Text>
        </View>
        <View style={[styles.attendanceRow, styles.totalRow]}>
            <Text style={styles.totalLabel}>Total Attendance:</Text>
            <Text style={styles.totalValue}>{total}</Text>
        </View>
    </View>
);

// const EventImages = ({ images }: { images: (number | string)[] }) => {
//     if (!images || images.length === 0) {
//         return null;
//     }
//     const renderItem = ({ item }: { item: number | string }) => (
//         <TouchableOpacity className="mr-3 shadow-md rounded-lg overflow-hidden">
//             <Image
//                 source={typeof item === 'string' ? { uri: item } : item}
//                 style={styles.eventImage}
//                 resizeMode="cover"
//             />
//         </TouchableOpacity>
//     );

//     return (
//         <View className="mt-6">
//             <Text className="text-lg font-bold text-gray-800 mb-3 mx-4">Event Gallery</Text>
//             <FlatList
//                 horizontal
//                 data={images}
//                 renderItem={renderItem}
//                 keyExtractor={(_, index) => `image-${index}`}
//                 showsHorizontalScrollIndicator={false}
//                 contentContainerStyle={styles.imageGalleryContainer}
//             />
//         </View>
//     );
// };


export default function SCCDetailsPage() {
    // State to manage loading during PDF generation
    const [isGeneratingPdf, setIsGeneratingPdf] = React.useState(false);
    
    // 1. GET ID FROM URL PARAMETERS
    const { id: recordId } = useLocalSearchParams<{ id: string }>();

    // 2. FETCH DATA using the ID
    const { data, isLoading, isError } = useGetSCCRecordQuery(recordId ?? '');
    
    // Extract the record and handle optional properties
    const record: SCCRecord | undefined = data?.record;

    // --- Loading and Error States ---
    if (isLoading) {
        return (
            <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color="#4f46e5" />
                <Text className="mt-4 text-gray-600">Loading record details...</Text>
            </View>
        );
    }

    if (isError || !record) {
        return (
            <View style={styles.loadingContainer}>
                <Text className="text-xl text-red-500 font-bold">Error or Record Not Found</Text>
                <Text className="mt-2 text-gray-600">Could not load record with ID: {recordId}</Text>
            </View>
        );
    }
    
    // --- Data is ready, use the 'record' object ---
    const men = record.menAttendance ?? 0;
    const women = record.womenAttendance ?? 0;
    const youth = record.youthAttendance?? 0;
    const catechumen = record.catechumenAttendance ?? 0;
    const totalAttendance = men + women + youth + catechumen;
    const totalOfferings = record.totalOfferings ?? 0;
    
    // Placeholder image array
    // const dummyImages = [DUMMY_IMAGE, DUMMY_IMAGE];

    // --- NEW: PDF GENERATION LOGIC ---
    const generatePdfHtml = (record: SCCRecord, totalAttendance: number, totalOfferings: number) => {
        const attendanceHtml = `
            <div style="margin-top: 20px; padding: 15px; border: 1px solid #e0e7ff; background-color: #f5f8ff; border-radius: 8px;">
                <h3 style="color: #4338ca; border-bottom: 2px solid #a5b4fc; padding-bottom: 5px; margin-bottom: 10px;">Attendance Summary</h3>
                <table style="width: 100%; border-collapse: collapse;">
                    <tr>
                        <td style="padding: 5px; color: #4338ca;">Men:</td>
                        <td style="padding: 5px; text-align: right; font-weight: bold;">${record.menAttendance ?? 0}</td>
                    </tr>
                    <tr>
                        <td style="padding: 5px; color: #4338ca;">Women:</td>
                        <td style="padding: 5px; text-align: right; font-weight: bold;">${record.womenAttendance ?? 0}</td>
                    </tr>
                    <tr>
                        <td style="padding: 5px; color: #4338ca;">Youth:</td>
                        <td style="padding: 5px; text-align: right; font-weight: bold;">${record.youthAttendance ?? 0}</td>
                    </tr>
                    <tr>
                        <td style="padding: 5px; color: #4338ca;">Catechumen:</td>
                        <td style="padding: 5px; text-align: right; font-weight: bold;">${record.catechumenAttendance ?? 0}</td>
                    </tr>
                    <tr style="border-top: 2px solid #a5b4fc;">
                        <td style="padding: 10px 5px; font-weight: bold; color: #1e3a8a;">TOTAL ATTENDANCE:</td>
                        <td style="padding: 10px 5px; text-align: right; font-weight: bold; color: #1e3a8a;">${totalAttendance}</td>
                    </tr>
                </table>
            </div>
        `;

        const detailsHtml = `
            <div style="margin-top: 20px; padding: 15px; border: 1px solid #e5e7eb; border-radius: 8px; background-color: #ffffff;">
                <h3 style="color: #1f2937; border-bottom: 1px solid #e5e7eb; padding-bottom: 5px; margin-bottom: 10px;">Event Details</h3>
                <div style="padding: 5px 0; border-bottom: 1px dotted #f3f4f6;">
                    <span style="font-weight: 500; color: #6b7280;">Officiating Priest:</span>
                    <span style="float: right; font-weight: 600; color: #1f2937;">${record.officiatingPriestName}</span>
                </div>
                <div style="padding: 5px 0; border-bottom: 1px dotted #f3f4f6;">
                    <span style="font-weight: 500; color: #6b7280;">Next Host:</span>
                    <span style="float: right; font-weight: 600; color: #1f2937;">${record.nextHost}</span>
                </div>
                <div style="padding: 5px 0;">
                    <span style="font-weight: 500; color: #6b7280;">Word of Life:</span>
                    <span style="float: right; font-weight: 600; color: #1f2937;">${record.wordOfLife}</span>
                </div>
            </div>
        `;

        const taskHtml = `
            <div style="margin-top: 20px; padding: 15px; border: 1px solid #e5e7eb; border-radius: 8px; background-color: #ffffff;">
                <h3 style="color: #1f2937; margin-bottom: 10px;">Task/Notes</h3>
                <p style="color: #4b5563; line-height: 1.6;">${record.task}</p>
            </div>
        `;

        return `
            <html>
            <head>
                <style>
                    body { font-family: sans-serif; padding: 20px; color: #1f2937; }
                    .header { background-color: #f9fafb; padding: 15px; border-bottom: 2px solid #e5e7eb; margin-bottom: 20px; }
                    .title { font-size: 24px; font-weight: bold; color: #1f2937; margin-bottom: 5px; }
                    .subtitle { font-size: 18px; color: #4b5563; }
                    .date { font-size: 14px; color: #9ca3af; margin-top: 5px; }
                    .offerings { background-color: #10b981; color: white; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 20px; }
                    .offerings-label { font-size: 14px; color: #a7f3d0; margin-bottom: 5px; }
                    .offerings-value { font-size: 36px; font-weight: bold; }
                </style>
            </head>
            <body>
                <div class="header">
                    <div class="title">${record.sccName}</div>
                    <div class="subtitle">${record.faithSharingName}</div>
                    <div class="date">Date: ${record.date}</div>
                </div>

                <div class="offerings">
                    <div class="offerings-label">Total Offerings</div>
                    <div class="offerings-value">${formatCurrency(totalOfferings)}</div>
                </div>

                ${attendanceHtml}
                ${detailsHtml}
                ${taskHtml}

                <div style="margin-top: 40px; text-align: center; color: #9ca3af; font-size: 12px;">
                    Generated by SCC Reporting App on ${new Date().toLocaleDateString()}
                </div>
            </body>
            </html>
        `;
    };

    // MODIFIED: Function now only generates the PDF and confirms save location
    const handleGenerateAndSharePdf = async () => {
    if (isGeneratingPdf || !record) return;

    setIsGeneratingPdf(true);

    // 1. Generate the HTML content
    const htmlContent = generatePdfHtml(record, totalAttendance, totalOfferings);

    // 2. Configure the PDF options
    const fileName = `${record.sccName.replace(/\s/g, '_')}_Report_${record.date}`;
    let options = {
        html: htmlContent,
        fileName: fileName,
        directory: 'Documents', // Use the Documents directory for temp storage
    };

    try {
        // 3. Generate the PDF file using the imported default export
        const file = await RNHTMLtoPDF.convert(options); 
        
        // 4. Show success message with the file path
        Alert.alert(
            'PDF Generated', 
            `The report PDF has been successfully saved to: ${file.filePath}`
        );
        
    } catch (error) {
        console.error('Error generating PDF:', error);
        Alert.alert('Error', 'Failed to generate the PDF file. Please check permissions or try again.');
    } finally {
        setIsGeneratingPdf(false);
    }
};


    return (
        <>
            <Stack.Screen
                options={{
                    // Use dynamic record data for the header title
                    title: record.sccName, 
                    headerShadowVisible: false,
                    headerStyle: { backgroundColor: '#f9fafb' }
                }}
            />
            <ScrollView className="flex-1 bg-gray-50">

                {/* Offerings Summary (Highlighted) */}
                <View className="p-4 bg-white border-b border-gray-200 mb-3">
                    <Text className="text-2xl font-bold text-gray-800">{record.sccName}</Text>
                    <Text className="text-lg text-gray-600 mt-1">{record.faithSharingName}</Text>
                    <Text className="text-sm text-gray-400 mt-1">Date: {record.date}</Text>
                </View>
                <View className="bg-green-600 p-5 mx-4 rounded-xl shadow-md mb-4">
                    <Text className="text-sm text-green-200 font-medium">Total Offerings</Text>
                    <Text className="text-4xl text-white font-extrabold mt-1">
                        {formatCurrency(totalOfferings)}
                    </Text>
                </View>

                {/* Attendance Details */}
                <AttendanceBlock 
                    men={men} 
                    women={women} 
                    total={totalAttendance}
                    youth={youth}
                    catechumen={catechumen}
                />

                {/* General Details Section */}
                <View className="mt-6 mx-4 rounded-xl overflow-hidden shadow-sm border border-gray-200">
                    <Text className="text-lg font-bold text-gray-800 p-4 bg-gray-100 border-b border-gray-200">Event Details</Text>
                    <DetailRow
                        label="Officiating Priest"
                        value={record.officiatingPriestName}
                    />
                    <DetailRow
                        label="Next Host"
                        value={record.nextHost}
                    />
                    <DetailRow
                        label="Word of Life"
                        value={record.wordOfLife}
                    />
                </View>

                {/* Event Images Section */}
                {/* <EventImages images={dummyImages} />  */}

                {/* Description/Notes Section and Action Button */}
                <View className="mt-4 mb-8 mx-4 p-4 bg-white rounded-xl shadow-sm border border-gray-200">
                    <Text className="text-lg font-bold text-gray-800 mb-2">Task</Text>
                    <Text className="text-base text-gray-600 leading-relaxed">
                        {record.task}
                    </Text>
                </View>
                {/* --- BUTTON TEXT MODIFIED AND CALLS THE DOWNLOAD-ONLY FUNCTION --- */}
                <TouchableOpacity 
                    className={`p-4 mx-4 rounded-xl mb-6 ${isGeneratingPdf ? 'bg-indigo-400' : 'bg-indigo-600'}`}
                    onPress={handleGenerateAndSharePdf}
                    disabled={isGeneratingPdf}
                >
                    <View className="flex-row justify-center items-center">
                        {isGeneratingPdf && <ActivityIndicator color="#fff" className="mr-2" />}
                        <Text className="text-white text-center text-lg font-semibold">
                            {isGeneratingPdf ? 'Generating PDF...' : 'Download Event Details (PDF)'}
                        </Text>
                    </View>
                </TouchableOpacity>

            </ScrollView>
        </>
    );
}

// StyleSheet (no changes to styles, but listed for completeness)
const styles = StyleSheet.create({
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f9fafb',
    },
    attendanceRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingVertical: 5,
    },
    attendanceLabel: {
        fontSize: 16,
        color: '#4338ca',
    },
    attendanceValue: {
        fontSize: 16,
        fontWeight: '600',
        color: '#1e293b',
    },
    totalRow: {
        borderTopWidth: 1,
        borderTopColor: '#a5b4fc',
        paddingTop: 10,
        marginTop: 5,
    },
    totalLabel: {
        fontSize: 18,
        fontWeight: 'bold',
        color: '#1e3a8a',
    },
    totalValue: {
        fontSize: 18,
        fontWeight: 'bold',
        color: '#1e3a8a',
    },
    imageGalleryContainer: {
        paddingHorizontal: 16,
    },
    eventImage: {
        width: 150,
        height: 100,
        borderRadius: 8,
    },
});