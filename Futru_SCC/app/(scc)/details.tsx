import React from 'react';
import {
    Text,
    View,
    ScrollView,
    StyleSheet,
    TouchableOpacity,
    Image, // Import Image component
    FlatList, // Import FlatList for horizontal image scrolling
} from 'react-native';
import { Stack } from "expo-router";

// --- Dummy Data for the Details Page ---
const DETAILS_DATA = {
    SCC: 'St. Thomas Aquinas',
    title: 'January Record',
    date: '01/01/2025',
    attendance: {
        men: 15,
        women: 25,
        total: 40,
    },
    officiatingPriest: 'Fr. John Bosco',
    totalOfferings: 500, // Amount in currency, e.g., NGN or local currency
    description: 'This record covers the first meeting of the year, focusing on planning annual activities and an opening prayer session. It was a well-attended event with enthusiastic participation from all members.',
    // NEW: Array of image URLs for the event
    images: [
        'https://picsum.photos/id/1018/300/200', // Placeholder image 1
        'https://picsum.photos/id/1015/300/200', // Placeholder image 2
        'https://picsum.photos/id/1019/300/200', // Placeholder image 3
        'https://picsum.photos/id/1020/300/200', // Placeholder image 4
    ],
};

// Component to render a single detail row
const DetailRow = ({ label, value }: { label: string, value: string | number }) => (
    <View className="flex-row justify-between p-4 border-b border-gray-200 bg-white">
        <Text className="text-base text-gray-500 font-medium">{label}</Text>
        <Text className="text-base text-gray-800 font-semibold">{value}</Text>
    </View>
);

// Component for a styled block of attendance details
const AttendanceBlock = ({ men, women, total }: typeof DETAILS_DATA.attendance) => (
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
        <View style={[styles.attendanceRow, styles.totalRow]}>
            <Text style={styles.totalLabel}>Total Attendance:</Text>
            <Text style={styles.totalValue}>{total}</Text>
        </View>
    </View>
);

// Component to render event images horizontally
const EventImages = ({ images }: { images: string[] }) => {
    if (!images || images.length === 0) {
        return null; // Don't render if no images
    }

    const renderItem = ({ item }: { item: string }) => (
        <TouchableOpacity className="mr-3 shadow-md rounded-lg overflow-hidden">
            <Image
                source={{ uri: item }}
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
                keyExtractor={(item, index) => `image-${index}`}
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.imageGalleryContainer}
            />
        </View>
    );
};


export default function SCCDetailsPage() {
    // Helper function to format currency (example for NGN)
    const formatCurrency = (amount: number) => {
        return `XAF ${amount.toLocaleString()}`;
    };

    return (
        <>
            <Stack.Screen
                options={{
                    title: DETAILS_DATA.title,
                    headerShadowVisible: false,
                    headerStyle: { backgroundColor: '#f9fafb' }
                }}
            />
            <ScrollView className="flex-1 bg-gray-50">

                {/* Header Information Block */}
                <View className="p-4 bg-white border-b border-gray-200 mb-3">
                    <Text className="text-2xl font-bold text-gray-800">{DETAILS_DATA.SCC}</Text>
                    <Text className="text-lg text-gray-600 mt-1">{DETAILS_DATA.title}</Text>
                    <Text className="text-sm text-gray-400 mt-1">Date: {DETAILS_DATA.date}</Text>
                </View>

                {/* Offerings Summary (Highlighted) */}
                <View className="bg-green-600 p-5 mx-4 rounded-xl shadow-md mb-4">
                    <Text className="text-sm text-green-200 font-medium">Total Offerings</Text>
                    <Text className="text-4xl text-white font-extrabold mt-1">
                        {formatCurrency(DETAILS_DATA.totalOfferings)}
                    </Text>
                </View>

                {/* Attendance Details */}
                <AttendanceBlock {...DETAILS_DATA.attendance} />

                {/* General Details Section */}
                <View className="mt-6 mx-4 rounded-xl overflow-hidden shadow-sm border border-gray-200">
                    <Text className="text-lg font-bold text-gray-800 p-4 bg-gray-100 border-b border-gray-200">Event Details</Text>

                    <DetailRow
                        label="Officiating Priest"
                        value={DETAILS_DATA.officiatingPriest}
                    />
                    <DetailRow
                        label="Meeting Title"
                        value={DETAILS_DATA.title}
                    />
                    <DetailRow
                        label="SCC Name"
                        value={DETAILS_DATA.SCC}
                    />
                </View>

                {/* Event Images Section */}
                <EventImages images={DETAILS_DATA.images} />

                {/* Description/Notes Section */}
                <View className="mt-4 mb-8 mx-4 p-4 bg-white rounded-xl shadow-sm border border-gray-200">
                    <Text className="text-lg font-bold text-gray-800 mb-2">Description</Text>
                    <Text className="text-base text-gray-600 leading-relaxed">
                        {DETAILS_DATA.description}
                    </Text>
                </View>

                {/* Example of an Action Button */}
                <TouchableOpacity className="bg-indigo-600 p-4 mx-4 rounded-xl mb-6">
                    <Text className="text-white text-center text-lg font-semibold">
                        Share Event Details
                    </Text>
                </TouchableOpacity>

            </ScrollView>
        </>
    );
}

// Separate StyleSheet for pure React Native styles not supported by Tailwind (e.g., custom borders for subtotals)
const styles = StyleSheet.create({
    attendanceRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingVertical: 5,
    },
    attendanceLabel: {
        fontSize: 16,
        color: '#4338ca', // indigo-700
    },
    attendanceValue: {
        fontSize: 16,
        fontWeight: '600',
        color: '#1e293b', // gray-800
    },
    totalRow: {
        borderTopWidth: 1,
        borderTopColor: '#a5b4fc', // indigo-300
        paddingTop: 10,
        marginTop: 5,
    },
    totalLabel: {
        fontSize: 18,
        fontWeight: 'bold',
        color: '#1e3a8a', // indigo-900
    },
    totalValue: {
        fontSize: 18,
        fontWeight: 'bold',
        color: '#1e3a8a', // indigo-900
    },
    imageGalleryContainer: {
        paddingHorizontal: 16, // Add padding to the FlatList content
    },
    eventImage: {
        width: 150, // Fixed width for images
        height: 100, // Fixed height for images
        borderRadius: 8, // Rounded corners for images
    },
});