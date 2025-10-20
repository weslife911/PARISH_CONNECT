import { View } from "react-native"
import "./loader.css" 

function Loader() {
  return (
    <View className="flex-1 justify-center items-center bg-white">
      <View className="loader"></View>
    </View>
  )
}

export default Loader