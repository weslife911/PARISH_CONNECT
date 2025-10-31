import React from 'react';
import {
    Text, 
    View,
    TouchableOpacity,
    Image, 
    FlatList,
    StyleSheet,
    ActivityIndicator
} from 'react-native';
import { useRouter } from "expo-router"
import NoRecords from '@/components/SCC/NoRecords';
import { Cross } from 'lucide-react-native';
import { useGetSCCRecordsQuery } from '@/services/SCC/queries';
import { SCCRecord } from '@/types/sccTypes'; 

interface GroupedSection {
    title: string;
    data: SCCRecord[];
}

const groupAndSortRecords = (records: SCCRecord[] | undefined): GroupedSection[] => {
    if (!records || records.length === 0) {
        return [];
    }
    
    const sortedRecords = [...records].sort((a, b) => {
        if (a.date < b.date) return 1;
        if (a.date > b.date) return -1;
        return 0;
    });

    const grouped: { [key: string]: SCCRecord[] } = {};

    sortedRecords.forEach(record => {
        const yearMonth = record.date.substring(0, 7); 
        const [year, month] = yearMonth.split('-');
        const dateObj = new Date(parseInt(year), parseInt(month) - 1, 1);
        const monthTitle = dateObj.toLocaleString('default', { month: 'long', year: 'numeric' });

        if (!grouped[monthTitle]) {
            grouped[monthTitle] = [];
        }
        grouped[monthTitle].push(record);
    });

    return Object.keys(grouped).sort((a, b) => {
        if (a < b) return 1;
        if (a > b) return -1;
        return 0;
    }).map(title => ({
        title,
        data: grouped[title],
    }));
};

const SCCItem = ({ SCC, date, id }: {
    SCC: string,
    date: string,
    id: string 
}) => {
    const router = useRouter();
    
    const handlePress = () => {
        try {
            router.push(`/(scc)/details/${id}`);
        } catch (error) {
            console.error("Navigation error:", error);
        }
    };
    
    return (
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

const SectionHeader = ({ title }: { title: string }) => (
    <View className="bg-gray-100 py-3 border-gray-300 ml-2 mr-2 mb-3 mt-4 rounded-lg">
        <Text className="text-lg font-bold text-gray-800 ml-4">
            {title}
        </Text>
    </View>
);

export default function SCCRecordsPage() {
    const router = useRouter();
    const { data, isLoading, isError, error } = useGetSCCRecordsQuery();

    // Handle loading state
    if (isLoading) {
        return (
            <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color="#007AFF" />
                <Text className="mt-4 text-gray-600">Loading records...</Text>
            </View>
        );
    }

    // Handle error state
    if (isError) {
        console.error("Error fetching records:", error);
        return (
            <View style={styles.loadingContainer}>
                <Text className="text-red-500 text-lg font-bold">Error Loading Records</Text>
                <Text className="text-gray-600 mt-2">Please check your connection and try again</Text>
            </View>
        );
    }

    const groupedRecords = groupAndSortRecords(data?.records as SCCRecord[] | undefined);
    
    return (
        <View style={styles.container}>
            <FlatList
                data={groupedRecords}
                keyExtractor={(item) => item.title} 
                renderItem={({ item: section }) => ( 
                    <View>
                        <SectionHeader title={section.title}/>
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
                ListEmptyComponent={<NoRecords/>}
            />
            
            <TouchableOpacity 
                style={styles.fab}
                className='w-14 h-14 rounded-full bg-blue-600 
                    flex justify-center items-center 
                    absolute bottom-6 right-6'
                onPress={() => {
                    try {
                        router.push('/(scc)/addRecord');
                    } catch (error) {
                        console.error("Navigation error:", error);
                    }
                }}
            >
                <Cross size={24} color="white" />
            </TouchableOpacity>
        </View>
    )
}

const styles = StyleSheet.create({
    container: {
        flex: 1, 
        backgroundColor: 'white', 
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
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
});