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
    <View className="bg-white py-2 border-gray-300 ml-2 mr-2 mb-3">
        <Text className="text-lg font-bold text-gray-800 ml-2">
            {title}
        </Text>
    </View>
);


export default function SCCRecordsPage() {
    const router = useRouter();
    const { data } = useGetSCCRecordsQuery();
    
    return (
        <View style={styles.container}>
            <FlatList
                // Add explicit type to the data for better inference
                data={data?.records as SCCRecord[] | undefined}
                // Use SCCRecord type for item
                renderItem={({ item }: { item: SCCRecord }) => ( 
                    <>
                        <SectionHeader title={item.sccName}/>
                        <SCCItem 
                            SCC={item.sccName} 
                            date={item.date}
                            // TypeScript now knows item._id is a REQUIRED string
                            id={item._id} 
                        />
                    </>
                )}
                // TypeScript now knows item._id is a REQUIRED string
                keyExtractor={(item: SCCRecord) => item._id} 
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