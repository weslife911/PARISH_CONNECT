import React from 'react';
import {
    Text,
    View,
    ScrollView,
    StyleSheet,
    TouchableOpacity,
    Image,
    FlatList,
} from 'react-native';
import { Stack } from "expo-router";

// STEP 1: Statically import the local assets here.
// NOTE: Assuming your dummy image is at this path.
const DUMMY_IMAGE = require('@/assets/images/dummy.png');

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
    totalOfferings: 57500.00,
    description: 'This record covers the first meeting of the year, focusing on planning annual activities and an opening prayer session. It was a well-attended event with enthusiastic participation from all members.',
    
    // STEP 2: Store the imported image MODULES (the results of require())
    // instead of the string paths.
    images: [
        DUMMY_IMAGE, // Use the static import
        DUMMY_IMAGE,
        DUMMY_IMAGE,
        DUMMY_IMAGE,
    ],
};

// Component to render a single detail row (omitted for brevity, no changes here)
const DetailRow = ({ label, value }: { label: string, value: string | number }) => (
    <View className="flex-row justify-between p-4 border-b border-gray-200 bg-white">
        <Text className="text-base text-gray-500 font-medium">{label}</Text>
        <Text className="text-base text-gray-800 font-semibold">{value}</Text>
    </View>
);

// Component for a styled block of attendance details (omitted for brevity, no changes here)
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
const EventImages = ({ images }: { images: number[] }) => {
    if (!images || images.length === 0) {
        return null;
    }

    // The 'item' here is now the required image module (a number/ID), not a string path.
    const renderItem = ({ item }: { item: number }) => (
        <TouchableOpacity className="mr-3 shadow-md rounded-lg overflow-hidden">
            <Image
                // STEP 3: Pass the imported module directly. No need for require()
                source={item}
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
                // Key extractor uses index since all images are the same dummy image
                keyExtractor={(_, index) => `image-${index}`}
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.imageGalleryContainer}
            />
        </View>
    );
};


export default function SCCDetailsPage() {
    // Helper function to format currency (omitted for brevity, no changes here)
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

                {/* Offerings Summary (Highlighted) */}
                <View className="p-4 bg-white border-b border-gray-200 mb-3">
                    <Text className="text-2xl font-bold text-gray-800">{DETAILS_DATA.SCC}</Text>
                    <Text className="text-lg text-gray-600 mt-1">{DETAILS_DATA.title}</Text>
                    <Text className="text-sm text-gray-400 mt-1">Date: {DETAILS_DATA.date}</Text>
                </View>
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
                <EventImages images={DETAILS_DATA.images as number[]} />

                {/* Description/Notes Section and Action Button (omitted for brevity, no changes here) */}
                <View className="mt-4 mb-8 mx-4 p-4 bg-white rounded-xl shadow-sm border border-gray-200">
                    <Text className="text-lg font-bold text-gray-800 mb-2">Description</Text>
                    <Text className="text-base text-gray-600 leading-relaxed">
                        {DETAILS_DATA.description}
                    </Text>
                </View>
                <TouchableOpacity className="bg-indigo-600 p-4 mx-4 rounded-xl mb-6">
                    <Text className="text-white text-center text-lg font-semibold">
                        Share Event Details
                    </Text>
                </TouchableOpacity>

            </ScrollView>
        </>
    );
}

// StyleSheet (omitted for brevity, no changes here)
const styles = StyleSheet.create({
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