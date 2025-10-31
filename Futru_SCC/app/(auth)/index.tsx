import AuthAuthenticationSection from '@/components/Auth/AuthAuthenticationSection';
import CustomButton from '@/components/Common/CustomButton';
import SingleTextField from '@/components/Common/SingleTextField'
import { Text, View, Alert } from 'react-native'
import { Link, useRouter } from "expo-router"
import { useLoginUserMutation } from "@/services/Auth/mutations"
import { AuthReturnType, LoginUserType } from '@/types/authTypes';
import { Formik } from 'formik';
import * as Yup from 'yup';
import { useState } from 'react';

function LoginPage() {

  const router = useRouter();
  const loginUserMutation = useLoginUserMutation();
  const [showPassword, setShowPassword] = useState(false);

  const validationSchema = Yup.object({
    email: Yup.string()
      .email('Invalid email address')
      .required('Email is required'),
    password: Yup.string()
      .min(8, 'Password must be at least 8 characters')
      .required('Password is required'),
  });

  return (
    <View className='flex-1 justify-center items-center p-5 mt-20'>
      
      <Formik
        initialValues={{ email: '', password: "" }}
        validationSchema={validationSchema}
        onSubmit={(values) => {
          loginUserMutation.mutate({ 
            email: values.email,
            password: values.password
          } as LoginUserType, {
            onSuccess: (data: AuthReturnType) => {
              if(data.success) {
                router.replace("/(scc)");
              } else {
                Alert.alert("Login Failed", data.message || "Invalid credentials");
              }
            },
            onError: (error: any) => {
              console.error("Login error:", error);
              Alert.alert("Login Failed", error?.response?.data?.message || "An error occurred");
            }
          });
        }}
      >
        {({ handleChange, handleBlur, handleSubmit, values, errors, touched }) => (
          <>
            <View>
              <Text className='font-[Roboto-Mono] text-xl font-bold' style={{ height: 40 }}>
                USER LOGIN 🔐
              </Text>
            </View>
            <View className='w-full max-w-sm'>
              <SingleTextField
                placeholder='Enter your email'
                text={values.email}
                onChangeText={handleChange("email")}
                onBlur={handleBlur("email")} 
                keyboardType='email-address'
                label='Email'
              />
              {touched.email && errors.email && (
                <Text className='text-red-500 text-sm mt-1 mb-2 pl-1'>{errors.email}</Text>
              )}

              <SingleTextField
                placeholder='Enter your password'
                text={values.password}
                onChangeText={handleChange("password")}
                onBlur={handleBlur("password")}
                label='Password'
                secureTextEntry={!showPassword}
                showFieldData={true}
                onToggleVisibility={() => setShowPassword(prev => !prev)}
              />
              {touched.password && errors.password && (
                <Text className='text-red-500 text-sm mt-1 mb-2 pl-1'>{errors.password}</Text>
              )}

              <View className='w-full flex-row justify-between items-center mt-3 mb-5'>
                <Link href="/(auth)/signup" asChild>
                  <Text className='text-blue-600'>Sign Up</Text>
                </Link>
                <Link href="/(auth)/forgot_password" asChild>
                  <Text className='text-blue-600'>Forgot Password?</Text>
                </Link>
              </View>

              <CustomButton 
                title='Login'
                onPress={handleSubmit} 
                isLoading={loginUserMutation.isPending}
              />
            </View>
          </>
        )}
      </Formik>

      <AuthAuthenticationSection/>
    </View>
  )
}

export default LoginPage