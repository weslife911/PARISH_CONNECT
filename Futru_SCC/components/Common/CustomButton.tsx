import { Text, TouchableOpacity, View } from "react-native"
import { LoaderCircle } from 'lucide-react-native';

// Define the component's props
interface CustomButtonProps {
  title: string;
  onPress: () => void;
  isLoading?: boolean;
  className?: string;
}

function CustomButton({ title, onPress, isLoading = false, className = "" }: CustomButtonProps) {
  return (
    <TouchableOpacity
      onPress={onPress}
      className={`bg-[#6B46C1] mt-5 p-3 rounded-full flex-row items-center justify-center min-w-[150px] shadow-md ${className}`}
      activeOpacity={isLoading ? 1 : 0.8}
      disabled={isLoading}
    >
        {isLoading ? (
          <View className="flex-row items-center">
            <LoaderCircle size={24} color="white" className="animate-spin" />
            <Text className="text-white text-lg font-bold ml-2">{title}...</Text>
          </View>
        ) : (
          <>
            
            <Text className="text-white text-lg font-bold">
              {title}
            </Text>
          </>
        )}
    </TouchableOpacity>
  )
}

export default CustomButton