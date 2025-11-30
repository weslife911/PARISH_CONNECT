import { Image, Text, View } from "react-native"

export default function NoRecords() {
    return (
    <View className="flex-1 items-center justify-center bg-gray-50 p-6">
        {/* Placeholder image needs to be available in '@/assets/images/church.png' */}
        <Image
            source={require("@/assets/images/church.png")}
            style={{ width: 200, height: 200, resizeMode: 'contain' }}
            className="mb-8 opacity-70"
        />
        <Text className="text-2xl font-bold text-gray-700 mb-2 text-center">
            No Records Found!
        </Text>
        <Text className="text-base text-gray-500 text-center px-4">
            It looks like you {"haven't"} added any SCC records yet. Start by tapping the {"'+'"} button to record your first gathering.
        </Text>
    </View>
    );
}