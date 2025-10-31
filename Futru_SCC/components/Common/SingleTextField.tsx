// fileName: SingleTextField.tsx

import { View, Text, TextInput, TextInputProps, TouchableOpacity } from "react-native"
import { Eye, EyeOff } from "lucide-react-native"

interface SingleTextFieldProps {
    label?: string;
    value?: string;
    text?: string; // Support legacy prop name
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
    error?: string | false | undefined | null; 
    returnKeyType?: TextInputProps['returnKeyType'];
}

function SingleTextField({ 
    label = '', 
    value, 
    text, // Legacy support
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
    error,
    returnKeyType = 'default',
}: SingleTextFieldProps) {
  
  // Support both 'value' and 'text' props for backward compatibility
  const textValue = value ?? text ?? '';
  
  const shouldRenderToggle = showFieldData && onToggleVisibility && !multiline; 
  const inputPaddingRight = shouldRenderToggle ? 'pr-12' : 'pr-4';
  
  const multilineStyles = multiline 
    ? { minHeight: 120, textAlignVertical: 'top' as const, paddingTop: 16 }
    : {};
  
  const errorBorderClass = error ? 'border-red-500' : 'border-gray-300';

  const inputBaseClasses = `
    w-full 
    border 
    ${errorBorderClass}
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
    <View className="relative w-full mb-4 mt-4"> 
        
      {/* Floating Label */}
      {label && (
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
      )}

      {/* TextInput */}
      <TextInput
        value={textValue}
        onChangeText={onChangeText}
        onBlur={onBlur}
        placeholder={placeholder}
        className={`${inputBaseClasses} ${className || ''}`}
        keyboardType={keyboardType} 
        placeholderTextColor="#6B7280"
        secureTextEntry={secureTextEntry}
        multiline={multiline}
        numberOfLines={numberOfLines}
        style={multilineStyles}
        returnKeyType={returnKeyType}
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
          style={{ height: '100%' }}
        >
          <IconComponent size={24} color="#6B7280" /> 
        </TouchableOpacity>
      )}

      {/* Error Text Display */}
      {error && typeof error === 'string' && (
        <Text className="text-red-500 text-xs mt-1 ml-1">
          {error}
        </Text>
      )}

    </View>
  )
}

export default SingleTextField