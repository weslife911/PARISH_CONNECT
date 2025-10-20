// fileName: SingleTextField.tsx

import { View, Text, TextInput, TextInputProps, TouchableOpacity } from "react-native"
import { Eye, EyeOff } from "lucide-react-native"

interface SingleTextFieldProps {
    label: string;
    text: string;
    onChangeText?: (text: string) => void;
    placeholder?: string;
    keyboardType?: TextInputProps['keyboardType'];
    className?: string;
    secureTextEntry?: boolean;
    onBlur?: (e: any) => void;
    showFieldData?: boolean; // Controls whether the eye icon is rendered
    onToggleVisibility?: () => void; // Function to call when the eye icon is pressed
}

function SingleTextField({ 
    label, 
    text, 
    onChangeText,
    placeholder, 
    keyboardType = 'default', 
    className,
    secureTextEntry = false,
    onBlur,
    showFieldData = false, // Flag to render the icon
    onToggleVisibility // New prop for the toggle action
}: SingleTextFieldProps) {
  
  // 1. Determine if the icon should be rendered and made functional
  const shouldRenderToggle = showFieldData && onToggleVisibility;

  // 2. Adjust padding right if the icon is present (to prevent text overlap)
  const inputPaddingRight = shouldRenderToggle ? 'pr-12' : 'pr-4';

  const inputBaseClasses = `
    // w-full 
    border border-gray-700 
    rounded-lg 
    // py-4 
    ${inputPaddingRight} // Dynamic padding
    // pl-4 
    text-lg 
    text-black
    placeholder:text-gray-500
  `;

  // 3. Determine which icon to display based on the current secureTextEntry prop value
  // If secureTextEntry is TRUE (text is hidden), show Eye (to reveal).
  const IconComponent = secureTextEntry ? Eye : EyeOff;

  return (
    <View className="relative w-full my-4"> 
        
      {/* Floating Label */}
      <View 
        className="
          absolute 
          -top-3 
          left-3 
          bg-white 
          px-2 
          rounded 
          z-10
        "
      >
        <Text className="text-black text-xs font-bold">{label}</Text>
      </View>

      {/* TextInput */}
      <TextInput
        value={text}
        onChangeText={onChangeText}
        onBlur={onBlur}
        placeholder={placeholder}
        className={`${inputBaseClasses} ${className || ''}`}
        keyboardType={keyboardType as TextInputProps['keyboardType']} 
        placeholderTextColor="#6B7280"
        secureTextEntry={secureTextEntry || false}
      />
      
      {/* Visibility Toggle Icon */}
      {shouldRenderToggle && (
        <TouchableOpacity
          onPress={onToggleVisibility}
          className="
            absolute 
            right-4 
            top-0 
            bottom-0 
            justify-center 
            h-full
          "
        >
          {/* Render the appropriate Lucide icon component */}
          <IconComponent size={24} color="#6B7280" /> 
        </TouchableOpacity>
      )}

    </View>
  )
}

export default SingleTextField