import React from 'react';
import {
    Text, 
    View,
    TouchableOpacity,
    Image, 
    FlatList,
    StyleSheet // <--- NEW: Import StyleSheet for FAB styling
} from 'react-native';
import { useRouter } from "expo-router"
import NoRecords from '@/components/SCC/NoRecords';

// Centralized the static data definition
const RECORD_DATA = [
    // {
    //     id: "1",
    //     SCC: 'St. Thomas Aquinas',
    //     title: 'January',
    //     date: '01/01/2025'
    // },
    // {
    //     id: "2",
    //     SCC: 'St. Thomas Aquinas',
    //     title: 'February',
    //     date: '02/02/2025'
    // },
];

const TransactionItem = ({ SCC, date }: {
    SCC: string,
    date: string
}) => {
    const router = useRouter();
    return (
        <TouchableOpacity onPress={() => router.push("/(scc)/details")} className="bg-white p-4 flex-row justify-between items-center rounded-xl mb-7 ml-2 mr-2 border-grey">
        <View className="flex-1 mr-4">
            <Text className="text-base text-gray-800 font-medium">{SCC}</Text>
            <Text className="text-xs text-gray-500 mt-1">{date}</Text>
        </View>
        
        <Image
            source={require("@/assets/images/media.png")} 
            className="w-12 h-12 rounded-lg bg-gray-300" 
        />
    </TouchableOpacity>
    )
}

const SectionHeader = ({ title }: {
    title: string
}) => (
    <View className="bg-white py-2 border-gray-300 ml-2 mr-2 mb-3">
        <Text className="text-lg font-bold text-gray-800 ml-2">
            {title}
        </Text>
    </View>
);


export default function SCCRecordsPage() {
    const router = useRouter(); // Use useRouter if the FAB navigates
    
    // The main container View wraps all screen elements and uses flex: 1
    // to occupy the full screen space, which is necessary for absolute positioning.
    return (
        <View style={styles.container}>
            <FlatList
                data={RECORD_DATA}
                    renderItem={({ item }) => (
                        <>
                        <SectionHeader title={item.title}/>
                    <TransactionItem 
                        SCC={item.SCC} 
                        date={item.date}
                    /></>
                )}
                keyExtractor={(item, index) => item.id + index}
                ListEmptyComponent={<NoRecords/>}
            />
            
            {/* --- FLOATING ACTION BUTTON (FAB) --- */}
            <TouchableOpacity 
                style={styles.fab}
                // Add the action for the FAB here
                onPress={() => router.push('/(scc)/addRecord')} 
            >
                {/* Placeholder content for the FAB (e.g., a simple plus sign) */}
                <Text style={styles.fabText}>+</Text> 
            </TouchableOpacity>
            {/* ------------------------------------ */}
            
        </View>
    )
}

// --- NEW STYLESHEET FOR FAB ---
const styles = StyleSheet.create({
    container: {
        flex: 1, // Ensures the container takes up the full screen
        backgroundColor: 'white', // Set your desired background color
    },
    fab: {
        // Absolute positioning places the FAB relative to the main container
        position: 'absolute', 
        width: 60, 
        height: 60,
        alignItems: 'center',
        justifyContent: 'center',
        right: 20, // Distance from the right edge
        bottom: 20, // Distance from the bottom edge
        backgroundColor: '#007AFF', // Example background color
        borderRadius: 30, // Makes it a circle
        elevation: 6, // Android shadow
        shadowColor: '#000', // iOS shadow
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.3,
        shadowRadius: 4,
        zIndex: 10, // Ensures it's drawn on top of the FlatList
    },
    fabText: {
        fontSize: 30,
        color: 'white',
        lineHeight: 30, // Adjust line height to center the '+' symbol
    }
});
// ------------------------------