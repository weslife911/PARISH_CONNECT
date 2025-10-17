import { View } from "react-native"
import "./loader.css" 

function Loader() {
  return (
    <View className="loader-container flex-1 justify-center items-center">
      <View className="loader"></View>
    </View>
  )
}

export default Loader