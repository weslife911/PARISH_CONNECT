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
    showFieldData?: boolean; 
    onToggleVisibility?: () => void; 
    // NEW PROPS for multiline input
    multiline?: boolean; 
    numberOfLines?: number; 
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
    showFieldData = false, 
    onToggleVisibility,
    // Destructure new props
    multiline = false,
    numberOfLines = 1,
}: SingleTextFieldProps) {
  
  // Disable the toggle icon for multiline inputs
  const shouldRenderToggle = showFieldData && onToggleVisibility && !multiline; 
  const inputPaddingRight = shouldRenderToggle ? 'pr-12' : 'pr-4';
  
  // Conditionally apply style for multiline to ensure vertical alignment and adequate height
  const multilineStyles = multiline 
    ? { minHeight: 120, textAlignVertical: 'top', paddingTop: 16 }
    : {};

  const inputBaseClasses = `
    // w-full 
    border border-gray-700 
    rounded-lg 
    py-4 // <-- ADDED HEIGHT VIA VERTICAL PADDING
    ${inputPaddingRight} // Dynamic padding
    pl-4 
    text-lg 
    text-black
    placeholder:text-gray-500
  `;

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
        multiline={multiline}
        numberOfLines={numberOfLines}
        style={multilineStyles} // Apply multiline specific styles
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