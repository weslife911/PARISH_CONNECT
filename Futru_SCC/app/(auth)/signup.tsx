import CustomButton from '@/components/Common/CustomButton';
import SingleTextField from '@/components/Common/SingleTextField'
import { Text, View } from 'react-native'
import { Link, useRouter } from "expo-router"
import { Formik } from 'formik';
import * as Yup from 'yup';
import { useState } from 'react';
import { useSignupUserMutation } from '@/services/Auth/mutations';

// Define the shape of all form values
interface RegistrationValues {
  fullName: string;
  username: string;
  scc: string;
  email: string;
  password: string;
  confirmPassword: string;
}

const validationSchema = Yup.object<RegistrationValues>().shape({

  fullName: Yup.string()
    .min(3, 'Full name must be at least 3 characters')
    .required('Full Name is required'),
  username: Yup.string()
    .min(3, 'Username must be at least 3 characters')
    .required('Username is required'),
  scc: Yup.string()
    .min(4, 'SCC must be at least 4 digits/characters')
    .required('SCC is required'),
  email: Yup.string()
    .email('Invalid email address')
    .required('Email is required'),
  password: Yup.string()
    .min(8, 'Password must be at least 8 characters')
    .required('Password is required'),
  confirmPassword: Yup.string()
    .oneOf([Yup.ref('password')], 'Passwords must match')
    .required('Confirm password is required'),
});

function RegistrationPage() {
  // ALL HOOKS MUST BE AT THE TOP - NEVER CONDITIONALLY
  const router = useRouter();
  const [step, setStep] = useState(1); 
  const [showPassword, setShowPassword] = useState(false);
  const signupUserMutation = useSignupUserMutation(); 

  const onSubmit = (values: RegistrationValues) => {
    
    signupUserMutation.mutate({
      full_name: values.fullName,
      username: values.username,
      SCC: values.scc,
      email: values.email,
      password: values.password
    }, { onSuccess: () => {
      router.push("/(scc)");
    } });
  };

  return (
    <View className='flex-1 justify-center items-center p-5 mt-20'>
      
      <Formik<RegistrationValues>
        initialValues={{ fullName: '', username: '', scc: '', email: '', password: "", confirmPassword: "" }}
        validationSchema={validationSchema}
        onSubmit={onSubmit}
      >

     {({ handleChange, handleBlur, handleSubmit, values, errors, touched, setFieldTouched, validateForm }) => {
        
        // Function to handle the transition from Step 1 to Step 2
        const handleNext = async () => {
            // Manually mark step 1 fields as touched to display errors immediately
            await setFieldTouched('fullName', true, true);
            await setFieldTouched('username', true, true);
            await setFieldTouched('scc', true, true);

            const currentErrors = await validateForm();

            // Check if step 1 fields have validation errors
            const stepOneErrors = currentErrors.fullName || currentErrors.username || currentErrors.scc;

            if (!stepOneErrors) {
                setStep(2);
            }
        };

        return (
          <>
            <View>
              <Text className='font-[Roboto-Mono] text-2xl font-bold' style={{ height: 40 }}>
                USER SIGN UP 📝
              </Text>
            </View>
            <View className='w-full max-w-sm'>
              
              {/* === STEP 1: Full Name, Username, SCC === */}
              <View style={{ display: step === 1 ? 'flex' : 'none' }}>
                <SingleTextField
                  placeholder='Enter your full name'
                  text={values.fullName}
                  onChangeText={handleChange("fullName")}
                  onBlur={handleBlur("fullName")} 
                  label='Full Name'
                />
                {touched.fullName && errors.fullName && (
                  <Text className='text-red-500 text-sm mt-1 mb-2 pl-1'>{errors.fullName}</Text>
                )}

                <SingleTextField
                  placeholder='Choose a username'
                  text={values.username}
                  onChangeText={handleChange("username")}
                  onBlur={handleBlur("username")}
                  label='Username'
                />
                {touched.username && errors.username && (
                  <Text className='text-red-500 text-sm mt-1 mb-2 pl-1'>{errors.username}</Text>
                )}

                <SingleTextField
                  placeholder='Enter your SCC'
                  text={values.scc}
                  onChangeText={handleChange("scc")}
                  onBlur={handleBlur("scc")} 
                  label='SCC Name'
                  keyboardType='numeric'
                />
                {touched.scc && errors.scc && (
                  <Text className='text-red-500 text-sm mt-1 mb-2 pl-1'>{errors.scc}</Text>
                )}
                
                {/* Next Button for Step 1 */}
                <CustomButton 
                  title='Next'
                  onPress={handleNext} 
                  isLoading={signupUserMutation.isPending}
                />

                {/* Link to Login */}
                <View className='w-full flex-row justify-center items-center mt-5'>
                  <Link href="/(auth)" asChild>
                    <Text className='text-blue-600'>Already have an account? Login</Text>
                  </Link>
                </View>
              </View>


              {/* === STEP 2: Email, Password, Confirm Password === */}
              <View style={{ display: step === 2 ? 'flex' : 'none' }}>
                <CustomButton 
                  title='Back'
                  onPress={() => setStep(1)} 
                  className='mt-0 mb-5 bg-gray-400'
                />

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

                <SingleTextField
                  placeholder='Confirm your password'
                  text={values.confirmPassword}
                  onChangeText={handleChange("confirmPassword")}
                  onBlur={handleBlur("confirmPassword")}
                  label='Confirm Password'
                  secureTextEntry={!showPassword}
                  showFieldData={false}
                />
                {touched.confirmPassword && errors.confirmPassword && (
                  <Text className='text-red-500 text-sm mt-1 mb-2 pl-1'>{errors.confirmPassword}</Text>
                )}
                
                {/* Final Sign Up Button */}
                <CustomButton 
                  title='Sign Up'
                  onPress={handleSubmit} 
                  isLoading={signupUserMutation.isPending}
                />
              </View>
            
            </View>
          </>
        )}}
      </Formik> 

    </View>
  )
}

export default RegistrationPage