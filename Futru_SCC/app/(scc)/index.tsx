import React from 'react';
import {
    Text, 
    View,
    TouchableOpacity,
    FlatList,
    StyleSheet,
    ActivityIndicator,
    Dimensions
} from 'react-native';
import { useRouter } from "expo-router"
import NoRecords from '@/components/SCC/NoRecords';
import { Plus } from 'lucide-react-native';
import { useGetSCCRecordsQuery } from '@/services/SCC/queries';
import { SCCRecord } from '@/types/sccTypes'; 

interface GroupedSection {
    title: string;
    data: SCCRecord[];
}

// Helper to group and sort records (No change needed here)
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

// --- SCCItem Component (No change) ---
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
    
    // A more visually appealing card design with a shadow and a colored border
    return (
        <TouchableOpacity 
            onPress={handlePress} 
            style={styles.card}
            className="flex-row justify-between items-center bg-white"
        >
            <View className="flex-row items-center flex-1">
                {/* Placeholder Image/Icon area */}
                <View style={styles.iconContainer} className="bg-indigo-100 items-center justify-center">
                     {/* Replace with a dynamic icon based on SCC name or use a static one */}
                     <Text className="text-xl font-extrabold text-indigo-700">{SCC.charAt(0)}</Text>
                </View>

                <View className="flex-1 ml-4">
                    <Text className="text-base text-gray-900 font-bold" numberOfLines={1}>{SCC}</Text>
                    <Text className="text-sm text-gray-500 mt-0.5">Gathering Date: {date}</Text>
                </View>
            </View>
            
            {/* Simple Chevron or Arrow indicator */}
            <Text className="text-xl text-gray-400 ml-4">{'>'}</Text>

        </TouchableOpacity>
    )
}

// --- SectionHeader Component (No change) ---
const SectionHeader = ({ title }: { title: string }) => (
    <View className="py-2 ml-4 mr-4 mt-6 mb-2">
        <Text className="text-xl font-bold text-gray-700">
            {title}
        </Text>
    </View>
);

// --- NEW: Commissions Placeholder Component ---
const CommissionsScreen = () => {
    return (
        <View style={styles.placeholderContainer}>
            <Text className="text-xl text-center text-gray-500 px-8">
                Commission Records Coming Soon... 🛠️
            </Text>
        </View>
    );
};

// --- REFACTORED: Original SCC List Component ---
const SCCRecordsScreen = () => {
    const router = useRouter();
    const { data, isLoading, isError, error } = useGetSCCRecordsQuery();

    // Handle loading state
    if (isLoading) {
        return (
            <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color="#4f46e5" />
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
        <View style={styles.screenContainer}>
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
                contentContainerStyle={groupedRecords.length === 0 ? { flexGrow: 1 } : { paddingBottom: 100 }}
            />
            
            {/* Floating Action Button (FAB) using Plus icon */}
            <TouchableOpacity 
                style={styles.fab}
                className='w-14 h-14 rounded-full bg-indigo-600 
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
                <Plus size={24} color="white" />
            </TouchableOpacity>
        </View>
    )
}

// --- NEW: Tab Header Component ---
const TabHeader = ({ activeTab, setActiveTab }: { activeTab: 'scc' | 'commissions', setActiveTab: (tab: 'scc' | 'commissions') => void }) => (
    <View className="flex-row border-b border-gray-200 bg-white">
        <TouchableOpacity
            style={styles.tabButton}
            onPress={() => setActiveTab('scc')}
        >
            <Text style={[
                styles.tabText, 
                activeTab === 'scc' && styles.activeTabText
            ]}>
                SCC Records
            </Text>
            {activeTab === 'scc' && <View style={styles.activeTabIndicator} />}
        </TouchableOpacity>
        <TouchableOpacity
            style={styles.tabButton}
            onPress={() => setActiveTab('commissions')}
        >
            <Text style={[
                styles.tabText, 
                activeTab === 'commissions' && styles.activeTabText
            ]}>
                Commissions
            </Text>
            {activeTab === 'commissions' && <View style={styles.activeTabIndicator} />}
        </TouchableOpacity>
    </View>
);


// --- MODIFIED: Export Default Component (now the Tab Container) ---
export default function SCCRecordsPage() {
    const [activeTab, setActiveTab] = React.useState<'scc' | 'commissions'>('scc');
    
    return (
        <View style={styles.container}>
            <TabHeader activeTab={activeTab} setActiveTab={setActiveTab} />
            
            {activeTab === 'scc' ? (
                <SCCRecordsScreen />
            ) : (
                <CommissionsScreen />
            )}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1, 
        backgroundColor: '#f9fafb', // Light gray background for contrast
    },
    screenContainer: { // New container for screen content
        flex: 1,
    },
    loadingContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f9fafb',
    },
    placeholderContainer: { // New style for commissions placeholder
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: 20,
    },
    // New Tab Styles
    tabButton: {
        flex: 1,
        alignItems: 'center',
        paddingVertical: 12,
        position: 'relative',
    },
    tabText: {
        fontSize: 16,
        fontWeight: '500',
        color: '#6b7280', // Gray text
    },
    activeTabText: {
        color: '#4f46e5', // Indigo text
        fontWeight: '700',
    },
    activeTabIndicator: {
        position: 'absolute',
        bottom: 0,
        height: 3,
        width: '100%',
        backgroundColor: '#4f46e5', // Indigo bar
    },
    // Original Card Style for SCCItem
    card: {
        backgroundColor: 'white',
        borderRadius: 12,
        padding: 16,
        marginHorizontal: 16,
        marginBottom: 10,
        // Modern Shadow (iOS)
        shadowColor: "#000",
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.05,
        shadowRadius: 5,
        // Elevation (Android)
        elevation: 3,
        borderLeftWidth: 5,
        borderLeftColor: '#4f46e5', // Indigo accent color
    },
    iconContainer: {
        width: 48,
        height: 48,
        borderRadius: 24, // Circular icon
    },
    fab: {
        position: 'absolute', 
        width: 60, 
        height: 60,
        alignItems: 'center',
        justifyContent: 'center',
        right: 20, 
        bottom: 20, 
        backgroundColor: '#4f46e5', // Indigo color
        borderRadius: 30, 
        // Stronger FAB shadow
        elevation: 8, 
        shadowColor: '#4f46e5', 
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.4,
        shadowRadius: 6,
        zIndex: 10, 
    },
});