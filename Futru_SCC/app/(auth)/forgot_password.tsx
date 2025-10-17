import { Text, View } from "react-native"
import SingleTextField from '@/components/Common/SingleTextField'
import CustomButton from '@/components/Common/CustomButton';
import { useState } from "react";

function ForgotPassword() {

  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);

  const handleVerify = () => {
    setLoading(true);

    setTimeout(() => {
      setLoading(false);
      
    }, 2000);
  }

  return (
    <View className='flex-1 justify-center items-center p-5'>
      <View>
        <Text className='font-[Roboto-Mono] text-xl font-bold mb-8' style={{ height: 40 }}>
          VERIFY EMAIL 🔑
        </Text>
      </View>
      <View className='w-full max-w-sm'>
        <SingleTextField
          placeholder='Enter your email'
          text={email}
          onChangeText={(text) => setEmail(text)}
          keyboardType='email-address'
          label='Email'
        />

        <CustomButton 
          title='Verify Email' 
          onPress={handleVerify} 
          isLoading={loading}
        />
        
      </View>

    </View>
  )
}

export default ForgotPassword
