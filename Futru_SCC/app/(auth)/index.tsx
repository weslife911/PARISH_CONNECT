import AuthAuthenticationSection from '@/components/Auth/AuthAuthenticationSection';
import CustomButton from '@/components/Common/CustomButton';
import SingleTextField from '@/components/Common/SingleTextField'
import React, { useState } from 'react'
import { Text, View } from 'react-native'
import { Link } from "expo-router"

function LoginPage() {

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = () => {
    setLoading(true);

    setTimeout(() => {
      setLoading(false);
      
    }, 2000);
  }

  return (
    <View className='flex-1 justify-center items-center p-5'>
      <View>
        <Text className='font-[Roboto-Mono] text-xl font-bold mb-8' style={{ height: 40 }}>
          USER LOGIN 🔑
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

        <SingleTextField
          placeholder='Enter your password'
          text={password}
          onChangeText={(text) => setPassword(text)}
          label='Password'
          secureTextEntry={true}
        />

        <View className='w-full flex-row justify-end items-right'>
          {/* <Link>
          </Link> */}
          <Link href="/(auth)/forgot_password">
            Forgot Pasword?
          </Link>
        </View>

        <CustomButton 
          title='Login' 
          onPress={handleLogin} 
          isLoading={loading}
        />
        
      </View>

      <AuthAuthenticationSection/>
    </View>
  )
}

export default LoginPage