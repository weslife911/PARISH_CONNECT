import React from 'react';
import {
    Text, 
    View,
    TouchableOpacity,
    Image, 
    FlatList
} from 'react-native';
import { useRouter } from "expo-router"

// Centralized the static data definition
const RECORD_DATA = [
    {
        id: "1",
        SCC: 'St. Thomas Aquinas',
        title: 'January',
        date: '01/01/2025'
    },
    {
        id: "2",
        SCC: 'St. Thomas Aquinas',
        title: 'February',
        date: '02/02/2025'
    },
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

const ItemSeparator = () => (
    <View className="h-px bg-gray-200 ml-4" />
);


export default function RecordTab() {
    return (
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
        />
        // <SectionList
        //     className='flex-1 bg-white'
        //     sections={RECORD_DATA}
        //     keyExtractor={(item, index) => item.id + index}
        //     renderItem={({ item }) => (
        //         <TransactionItem 
        //             description={item.description} 
        //             date={item.date} 
        //         />
        //     )}
        //     renderSectionHeader={({ section: { title } }) => <SectionHeader title={title} />}
        //     stickySectionHeadersEnabled={true} 
        //     ItemSeparatorComponent={ItemSeparator}
        // />
    );
}