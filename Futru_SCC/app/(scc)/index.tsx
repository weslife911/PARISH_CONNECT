// index.tsx

import React from 'react';
import {
    Text, 
    View,
    TouchableOpacity,
    Image, 
    FlatList,
    StyleSheet
} from 'react-native';
import { useRouter } from "expo-router"
import NoRecords from '@/components/SCC/NoRecords';
import { Cross } from 'lucide-react-native';
import { useGetSCCRecordsQuery } from '@/services/SCC/queries';
// IMPORT THE NEW SCCRecord TYPE
import { SCCRecord } from '@/types/sccTypes'; 

// --- UTILITY FUNCTION FOR GROUPING ---
/**
 * Groups SCC records by Month and Year (e.g., "January 2024") and sorts them descending by date.
 * @param records Array of SCCRecord objects.
 * @returns Array of grouped sections.
 */
interface GroupedSection {
    title: string; // e.g., "January 2024"
    data: SCCRecord[];
}

const groupAndSortRecords = (records: SCCRecord[] | undefined): GroupedSection[] => {
    if (!records || records.length === 0) {
        return [];
    }
    
    // 1. Sort records by date descending (most recent first)
    const sortedRecords = [...records].sort((a, b) => {
        // Assuming date is in 'YYYY-MM-DD' format
        if (a.date < b.date) return 1;
        if (a.date > b.date) return -1;
        return 0;
    });

    // 2. Group records by month/year
    const grouped: { [key: string]: SCCRecord[] } = {};

    sortedRecords.forEach(record => {
        // Extract YYYY-MM
        const yearMonth = record.date.substring(0, 7); 
        
        // Format the title (e.g., "2024-01" -> "January 2024")
        const [year, month] = yearMonth.split('-');
        const dateObj = new Date(parseInt(year), parseInt(month) - 1, 1);
        const monthTitle = dateObj.toLocaleString('default', { month: 'long', year: 'numeric' });

        if (!grouped[monthTitle]) {
            grouped[monthTitle] = [];
        }
        grouped[monthTitle].push(record);
    });

    // 3. Convert the grouped object into the final array structure
    // We sort the final groups by the key (Month Year) descending to ensure proper chronology
    return Object.keys(grouped).sort((a, b) => {
        // Simple string comparison for sorting the month/year title descending
        if (a < b) return 1;
        if (a > b) return -1;
        return 0;
    }).map(title => ({
        title,
        data: grouped[title],
    }));
};
// -------------------------------------


const SCCItem = ({ SCC, date, id }: {
    SCC: string,
    date: string,
    // The 'id' prop is explicitly defined as a string here, which is correct
    id: string 
}) => {
    const router = useRouter();
    
    // MODIFICATION HERE: Use the ID to construct the dynamic route path
    const handlePress = () => {
        router.push(`/(scc)/details/${id}`);
    };
    
    return (
        // Call the new handlePress function
        <TouchableOpacity onPress={handlePress} className="bg-white p-4 flex-row justify-between items-center rounded-xl mb-7 ml-2 mr-2 border-grey">
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
    <View className="bg-gray-100 py-3 border-gray-300 ml-2 mr-2 mb-3 mt-4 rounded-lg">
        <Text className="text-lg font-bold text-gray-800 ml-4">
            {title}
        </Text>
    </View>
);


export default function SCCRecordsPage() {
    const router = useRouter();
    const { data } = useGetSCCRecordsQuery();

    // --- MODIFIED: Group the data by month/year ---
    const groupedRecords = groupAndSortRecords(data?.records as SCCRecord[] | undefined);
    
    // The FlatList now iterates over the array of GroupedSection objects
    return (
        <View style={styles.container}>
            <FlatList
                // Data is now the grouped sections
                data={groupedRecords}
                // Key extractor uses the unique month/year title
                keyExtractor={(item) => item.title} 
                
                // Render a Section block (Header + its items)
                renderItem={({ item: section }) => ( 
                    <View>
                        {/* Section Header: e.g., "January 2024" */}
                        <SectionHeader title={section.title}/>
                        
                        {/* Render all items within this section */}
                        {section.data.map((item) => (
                            <SCCItem 
                                key={item._id}
                                SCC={item.sccName} 
                                date={item.date}
                                id={item._id} 
                            />
                        ))}
                    </View>
                )}
                
                // Show 'NoRecords' if the groupedRecords array is empty
                ListEmptyComponent={<NoRecords/>}
            />
            
            {/* --- FLOATING ACTION BUTTON (FAB) --- */}
            <TouchableOpacity 
                style={styles.fab}
                // Add the action for the FAB here
                className='w-14 h-14 rounded-full bg-blue-600 
             flex justify-center items-center 
             absolute bottom-6 right-6'
                onPress={() => router.push('/(scc)/addRecord')} 
            >
                <Cross size={24} color="white" />
            </TouchableOpacity>
            {/* ------------------------------------ */}
            
        </View>
    )
}

// ... (rest of the styles object)
const styles = StyleSheet.create({
    container: {
        flex: 1, 
        backgroundColor: 'white', 
    },
    fab: {
        position: 'absolute', 
        width: 60, 
        height: 60,
        alignItems: 'center',
        justifyContent: 'center',
        right: 20, 
        bottom: 20, 
        backgroundColor: '#007AFF', 
        borderRadius: 30, 
        elevation: 6, 
        shadowColor: '#000', 
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.3,
        shadowRadius: 4,
        zIndex: 10, 
    },
    fabText: {
        fontSize: 30,
        color: 'white',
        lineHeight: 30, 
    }
});
// ------------------------------