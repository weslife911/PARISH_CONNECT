import { Image, Text, View } from "react-native"

function SCCRecordsPage() {

  return (
    <View className="flex-1 items-center justify-center bg-white">
      <Image
        source={require("@/assets/images/church.png")}
        style={{ width: 275, height: 275,  }}
        className="mb-16"
      />
      <Text className="font-[Roboto-Mono] text-center">
        No SCC Records Found. Please add SCC Records to view them here.
      </Text>
    </View>
  )
}

export default SCCRecordsPage