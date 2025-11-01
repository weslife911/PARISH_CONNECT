import React from 'react';
import {
    Text,
    View,
    ScrollView,
    StyleSheet,
    TouchableOpacity,
    Image,
    FlatList,
    ActivityIndicator,
    Alert,
} from 'react-native';
import { Stack, useLocalSearchParams } from "expo-router";
import { useGetSCCRecordQuery } from '@/services/SCC/queries';
import { SCCRecord } from '@/types/sccTypes';
import * as Print from 'expo-print';
import * as Sharing from 'expo-sharing';


// Helper function to format currency
const formatCurrency = (amount: number) => {
    return `XAF ${amount.toLocaleString()}`;
};

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

const EventImages = ({ images }: { images: (number | string)[] }) => {
    if (!images || images.length === 0) {
        return null;
    }
    const renderItem = ({ item }: { item: number | string }) => (
        <TouchableOpacity className="mr-3 mb-2 shadow-md rounded-lg overflow-hidden">
            <Image
                source={typeof item === 'string' ? { uri: item } : item}
                // @ts-ignore
                style={styles.eventImage}
                resizeMode="cover"
            />
        </TouchableOpacity>
    );

    return (
        <View className="mt-6">
            <Text className="text-lg font-bold text-gray-800 mb-3 mx-4">Event Gallery</Text>
            <FlatList
                horizontal
                data={images}
                renderItem={renderItem}
                keyExtractor={(_, index) => `image-${index}`}
                showsHorizontalScrollIndicator={false}
                // @ts-ignore
                contentContainerStyle={styles.imageGalleryContainer}
            />
        </View>
    );
};
// --- END HELPER COMPONENTS ---


export default function SCCDetailsPage() {
    const [isGeneratingPdf, setIsGeneratingPdf] = React.useState(false);
    const { id: recordId } = useLocalSearchParams<{ id: string }>();
    const { data, isLoading, isError } = useGetSCCRecordQuery(recordId ?? '');
    const record: SCCRecord | undefined = data?.record;

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

    const men = record.menAttendance ?? 0;
    const women = record.womenAttendance ?? 0;
    const youth = record.youthAttendance?? 0;
    const catechumen = record.catechumenAttendance ?? 0;
    const totalAttendance = men + women + youth + catechumen;
    const totalOfferings = record.totalOfferings ?? 0;
    const images = record.images;

    // --- PDF HTML GENERATION LOGIC ---
    const generatePdfHtml = (record: SCCRecord, totalAttendance: number, totalOfferings: number) => {
        const attendanceHtml = `
            <h2 style="font-size: 20px; font-weight: bold; color: #1f2937; margin-top: 20px; margin-bottom: 10px;">Attendance Breakdown (${totalAttendance} Total)</h2>
            <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
                <tr style="background-color: #f3f4f6;">
                    <td style="padding: 10px; border: 1px solid #e5e7eb;">Men</td>
                    <td style="padding: 10px; border: 1px solid #e5e7eb; font-weight: bold; text-align: right;">${men}</td>
                </tr>
                <tr>
                    <td style="padding: 10px; border: 1px solid #e5e7eb;">Women</td>
                    <td style="padding: 10px; border: 1px solid #e5e7eb; font-weight: bold; text-align: right;">${women}</td>
                </tr>
                <tr style="background-color: #f3f4f6;">
                    <td style="padding: 10px; border: 1px solid #e5e7eb;">Youth</td>
                    <td style="padding: 10px; border: 1px solid #e5e7eb; font-weight: bold; text-align: right;">${youth}</td>
                </tr>
                <tr>
                    <td style="padding: 10px; border: 1px solid #e5e7eb;">Catechumen</td>
                    <td style="padding: 10px; border: 1px solid #e5e7eb; font-weight: bold; text-align: right;">${catechumen}</td>
                </tr>
            </table>
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
            <h3 style="font-size: 18px; font-weight: bold; color: #1f2937; margin-top: 20px;">Upcoming Tasks/Actions:</h3>
            <p style="padding: 10px 0; line-height: 1.6; background-color: #f9fafb; padding: 10px; border-radius: 4px;">${record.task}</p>
        `;

        let imagesHtml = ``;

        if (images && images.length > 0) {
            const imageElements = images
                .map((img) => {
                    const imageUrl = typeof img === 'string' ? img : '';
                    if (imageUrl) {
                        return `<img src="${imageUrl}" style="width: 200px; height: 200px; object-fit: cover; border-radius: 8px; margin: 10px;" />`;
                    }
                    return '';
                })
                .filter(Boolean)
                .join('');

            if (imageElements) {
                imagesHtml = `
                    <h3 style="font-size: 18px; font-weight: bold; color: #1f2937; margin-top: 20px; margin-bottom: 10px;">Event Gallery</h3>
                    <div style="display: flex; flex-wrap: wrap; gap: 10px;">
                        ${imageElements}
                    </div>
                `;
            }
        }

        return `
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
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
                ${imagesHtml} 
                <div style="margin-top: 40px; text-align: center; color: #9ca3af; font-size: 12px;">
                    Generated by SCC Reporting App on ${new Date().toLocaleDateString()}
                </div>
            </body>
            </html>
        `;
    };
    // --- END HTML GENERATION LOGIC ---

    // --- PDF GENERATION/DOWNLOAD FUNCTION ---
    const handleGenerateAndSharePdf = async () => {
        if (isGeneratingPdf || !record) return;

        setIsGeneratingPdf(true);

        try {
            // 1. Generate the HTML content
            const htmlContent = generatePdfHtml(record, totalAttendance, totalOfferings);

            // 2. Create PDF from HTML using expo-print
            const { uri } = await Print.printToFileAsync({
                html: htmlContent,
            });

            // 3. Check if sharing is available
            const isAvailable = await Sharing.isAvailableAsync();
            
            if (!isAvailable) {
                Alert.alert('Error', 'Sharing is not available on this device.');
                setIsGeneratingPdf(false);
                return;
            }

            // 4. Share the PDF (user can save to Files/Downloads)
            const fileName = `${record.sccName.replace(/\s/g, '_')}_Report_${record.date}.pdf`;
            
            await Sharing.shareAsync(uri, {
                mimeType: 'application/pdf',
                dialogTitle: 'Save your SCC Report',
                UTI: 'com.adobe.pdf'
            });
            
            Alert.alert(
                'PDF Generated',
                'The report has been generated successfully. You can now save it to your device.'
            );
            
        } catch (error) {
            console.error('Error generating PDF:', error);
            Alert.alert('Error', 'Failed to generate the PDF file. Please try again.');
        } finally {
            setIsGeneratingPdf(false);
        }
    };
    // --- END FUNCTION ---


    return (
        <>
            <Stack.Screen
                options={{
                    title: record.sccName,
                    headerShadowVisible: false,
                    headerStyle: { backgroundColor: '#f9fafb' }
                }}
            />
            <ScrollView className="flex-1 bg-gray-50">
                {/* Detail components */}
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

                <AttendanceBlock
                    men={men}
                    women={women}
                    youth={youth}
                    catechumen={catechumen}
                    total={totalAttendance}
                />

                <View className="p-4 bg-white mt-4 mx-4 rounded-xl shadow-sm border border-gray-200">
                    <Text className="text-lg font-bold text-gray-800 mb-2">Meeting Summary</Text>
                    <Text className="text-gray-600 leading-relaxed">{record.wordOfLife}</Text>
                </View>

                <View className="p-4 bg-white mt-4 mx-4 rounded-xl shadow-sm border border-gray-200">
                    <Text className="text-lg font-bold text-gray-800 mb-2">Task</Text>
                    <Text className="text-gray-600 leading-relaxed">{record.task}</Text>
                </View>

                <EventImages images={images} />
                
                {/* PDF BUTTON */}
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
    eventImage: {
        width: 150,
        height: 150,
        borderRadius: 8,
    },
    imageGalleryContainer: {
        paddingHorizontal: 16,
    }
});