import { Text, View } from "react-native"
import SingleTextField from '@/components/Common/SingleTextField'
import CustomButton from '@/components/Common/CustomButton';
import { useState } from "react";

function ResetPassword() {

  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
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
          Change Password 🔑
        </Text>
      </View>
      <View className='w-full max-w-sm'>
        <SingleTextField
          placeholder='Current Password'
          text={password}
          onChangeText={(text) => setPassword(text)}
          label='Password'
          secureTextEntry={true}
        />

        <SingleTextField
          placeholder='New Password'
          text={confirmPassword}
          onChangeText={(text) => setConfirmPassword(text)}
          label='Confirm Password'
          secureTextEntry={true}
        />

        <CustomButton 
          title='Change Password' 
          onPress={handleVerify} 
          isLoading={loading}
        />
        
      </View>

    </View>
  )
}

export default ResetPassword
