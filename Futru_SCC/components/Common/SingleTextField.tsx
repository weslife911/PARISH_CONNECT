// fileName: SingleTextField.tsx

import { View, Text, TextInput, TextInputProps, TouchableOpacity } from "react-native"
import { Eye, EyeOff } from "lucide-react-native"

interface SingleTextFieldProps {
    label: string;
    value: string; // Changed to 'value' for consistency with Formik's values object
    onChangeText?: (text: string) => void;
    placeholder?: string;
    keyboardType?: TextInputProps['keyboardType'];
    className?: string;
    secureTextEntry?: boolean;
    onBlur?: (e: any) => void;
    showFieldData?: boolean; 
    onToggleVisibility?: () => void; 
    multiline?: boolean; 
    numberOfLines?: number; 
    // ADDED: Prop for error message
    error?: string | false | undefined | null; 
    returnKeyType?: TextInputProps['returnKeyType']; // Added missing returnKeyType
}

function SingleTextField({ 
    label, 
    value, // Changed from text to value
    onChangeText,
    placeholder, 
    keyboardType = 'default', 
    className,
    secureTextEntry = false,
    onBlur,
    showFieldData = false, 
    onToggleVisibility,
    multiline = false,
    numberOfLines = 1,
    error, // Destructure the new error prop
    returnKeyType = 'default', // Default for new prop
}: SingleTextFieldProps) {
  
  // Disable the toggle icon for multiline inputs
  const shouldRenderToggle = showFieldData && onToggleVisibility && !multiline; 
  const inputPaddingRight = shouldRenderToggle ? 'pr-12' : 'pr-4';
  
  // Conditionally apply style for multiline to ensure vertical alignment and adequate height
  const multilineStyles = multiline 
    ? { minHeight: 120, textAlignVertical: 'top', paddingTop: 16 }
    : {};
  
  // Apply error styling
  const errorBorderClass = error ? 'border-red-500' : 'border-gray-300'; // Changed from gray-700 to gray-300 for better contrast/modern look

  const inputBaseClasses = `
    w-full 
    border 
    ${errorBorderClass} // Dynamic error border
    rounded-lg 
    py-4 
    ${inputPaddingRight} 
    pl-4 
    text-lg 
    text-black
    placeholder:text-gray-500
  `;

  const IconComponent = secureTextEntry ? Eye : EyeOff;

  return (
    // Use marginBottom to account for error message space
    <View className="relative w-full mb-6 mt-4"> 
        
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
        value={value} // Use value
        onChangeText={onChangeText}
        onBlur={onBlur}
        placeholder={placeholder}
        className={`${inputBaseClasses} ${className || ''}`}
        keyboardType={keyboardType as TextInputProps['keyboardType']} 
        placeholderTextColor="#6B7280"
        secureTextEntry={secureTextEntry || false}
        multiline={multiline}
        numberOfLines={numberOfLines}
        style={multilineStyles} // Apply multiline specific styles
        returnKeyType={returnKeyType} // Use returnKeyType
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

      {/* ADDED: Error Text Display */}
      {error && (
        <Text className="text-red-500 text-xs mt-1 absolute bottom-[-16] left-4">
          {error}
        </Text>
      )}

    </View>
  )
}

export default SingleTextField