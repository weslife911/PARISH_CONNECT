import { View, Text, TextInput, TextInputProps } from "react-native"

interface SingleTextFieldProps {
    label: string;
    text: string;
    onChangeText?: (text: string) => void;
    placeholder?: string;
    keyboardType?: TextInputProps['keyboardType'];
    className?: string;
    secureTextEntry?: boolean;
}

function FloatingLabelTextInput({ 
    label, 
    text, 
    onChangeText,
    placeholder, 
    keyboardType = 'default', 
    className,
    secureTextEntry = false,
}: SingleTextFieldProps) {
  
  const inputBaseClasses = `
    w-full 
    border border-gray-700 
    rounded-lg 
    py-4 
    px-4 
    text-lg 
    text-black
    placeholder:text-gray-500
  `;

  return (
    <View className="relative w-full my-4"> 
        
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

      <TextInput
        value={text}
        onChangeText={onChangeText} 
        placeholder={placeholder}
        className={`${inputBaseClasses} ${className || ''}`}
        keyboardType={keyboardType as TextInputProps['keyboardType']} 
        placeholderTextColor="#6B7280"
        secureTextEntry={secureTextEntry || false}
      />

    </View>
  )
}

export default FloatingLabelTextInput
