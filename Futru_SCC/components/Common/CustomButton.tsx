import { Text, TouchableOpacity, View } from "react-native"
import { LoaderCircle } from 'lucide-react-native';

// Define the component's props
interface CustomButtonProps {
  title: string;
  onPress: () => void;
  isLoading?: boolean; // Optional prop for loading state
}

function CustomButton({ title, onPress, isLoading = false }: CustomButtonProps) {
  return (
    // Use TouchableOpacity for a pressable, custom-styled component
    <TouchableOpacity
      onPress={onPress}
      // Apply styles: purple background, rounded corners, padding, margin top, flex row, shadow
      className="bg-[#6B46C1] mt-5 p-3 rounded-full flex-row items-center justify-center min-w-[150px] shadow-md"
      activeOpacity={isLoading ? 1 : 0.8} // Disable press effect when loading
      disabled={isLoading} // Disable pressing when loading
    >
        {isLoading ? (
          // Spinner/Loader State
          <View className="flex-row items-center">
             {/* This is the LoaderCircle, which is inherently a clean circular shape.
                 The 'animate-spin' class provides the desired rotation effect. 
                 It is white as requested. */}
            <LoaderCircle size={24} color="white" className="animate-spin" />
            <Text className="text-white text-lg font-bold ml-2">Loading...</Text>
          </View>
        ) : (
          // Default State (Icon and Text)
          <>
            
            {/* Button Text */}
            <Text className="text-white text-lg font-bold">
              {title}
            </Text>
          </>
        )}
    </TouchableOpacity>
  )
}

export default CustomButton