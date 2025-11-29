import { View, Text, ScrollView, Image, TouchableOpacity, Alert, Platform } from 'react-native'
import SingleTextField from '@/components/Common/SingleTextField'
import CustomButton from '@/components/Common/CustomButton'
import { User, Camera } from 'lucide-react-native';
import { useState, useEffect } from 'react';
import * as ImagePicker from 'expo-image-picker';
import { useRouter } from "expo-router"
import { useCheckAuthQuery } from '@/services/Auth/queries';
import { useFormik } from "formik"
import * as Yup from "yup"
import { useUpdateProfileMutation } from '@/services/Auth/mutations';

// Define the shape of the user data and form values
interface UserProfileFormValues {
  full_name: string;
  username: string;
  scc: string; // Changed from SCC to scc for consistency
  email: string;
  bio: string;
  profile_pic: string | null; 
}

function ProfilePage() {

  const { data: userData } = useCheckAuthQuery();
  const profileUpdateMutation = useUpdateProfileMutation(userData?._id);
  const router = useRouter();
  
  // State for toggling edit mode
  // State for image loading (to disable touch/show loading overlay)
  const [isImageLoading, setIsImageLoading] = useState(false); 
  
  // --- Formik Setup ---
  const formik = useFormik<UserProfileFormValues>({
    initialValues: {
      // Initialize with empty strings and let useEffect populate them
      full_name: "",
      username: "",
      scc: "",
      email: "",
      bio: "",
      profile_pic: "",
    },
    // Updated validation schema to match formik keys and server structure
    validationSchema: Yup.object<UserProfileFormValues>({
      full_name: Yup.string()
          .min(3, 'Full name must be at least 3 characters')
          .required('Full Name is required'),
      username: Yup.string()
          .min(3, 'Username must be at least 3 characters')
          .required('Username is required'),
      scc: Yup.string() // Key must match initialValues
          .min(4, 'SCC must be at least 4 characters')
          .required('SCC is required'),
      email: Yup.string()
          .email('Invalid email address')
          .required('Email is required'),
      bio: Yup.string().optional().max(200, 'Bio cannot exceed 200 characters'),
      profile_pic: Yup.string().optional()
    }),
    onSubmit: async(values) => {
      
      await profileUpdateMutation.mutateAsync({
        full_name: values.full_name,
        username: values.username,
        SCC: values.scc,
        email: values.email,
        bio: values.bio,
        profile_pic: values.profile_pic
      });
    }
  });  

  // Effect to populate Formik's initial values when user data is available
  useEffect(() => {
    formik.setValues({
        full_name: userData.full_name || "",
        username: userData.username || "",
        scc: userData.scc || "",
        email: userData.email || "",
        bio: userData.bio || "", // Assuming bio field is part of user data
        profile_pic: userData.profile_pic || "", // Assuming profile_pic field is part of user data
      }, false);
  }, []);


  // === UPDATED IMAGE PICKER FUNCTION ===
  const handleImagePick = async () => {
    // Only allow image picking if in edit mode
    if (!profileUpdateMutation.isPending) return;

    // 1. Request Permissions
    if (Platform.OS !== 'web') {
      const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();
      if (status !== 'granted') {
        Alert.alert('Permission required', 'We need camera roll permissions to make this work!');
        return;
      }
    }
    
    setIsImageLoading(true);

    // 2. Launch Image Picker
    let result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true, // Allow user to crop/edit the image
      aspect: [1, 1], // Square aspect ratio for a profile picture
      quality: 0.7, // Reduced quality for faster upload/processing
    });
    
    setIsImageLoading(false);

    // 3. Handle Result
    if (!result.canceled) {
      const selectedAsset = result.assets[0];
      
      // *** UPDATE FORMIK STATE ***
      // This updates the profile_pic value in Formik, which will be sent on save
      formik.setFieldValue('profile_pic', selectedAsset.uri);
      
      console.log("New profile image URI set in Formik:", selectedAsset.uri);
      Alert.alert("Success", "Profile picture updated locally. Press 'Save Profile' to finalize.");

    } else {
      console.log('Image picking cancelled');
    }
  };
  // ===================================

  // Handler for the Edit/Save button
  const handleEditSave = () => {
    formik.handleSubmit();
  };


  return (
    <ScrollView className='flex-1 bg-white p-5'>
      
      {/* === Profile Header === */}
      <View className='items-center mt-10 mb-8'>
        
        {/* Profile Image/Avatar Component */}
        <TouchableOpacity 
          onPress={handleImagePick} // Trigger image selection on press
          className='w-28 h-28 rounded-full bg-gray-200 items-center justify-center mb-3 border-4 border-[#6B46C1] shadow-lg relative'
          // Disable touch if not in edit mode OR if an upload is ongoing
          disabled={!profileUpdateMutation.isPending || isImageLoading}
        >
          {/* Display Loading or Image/Placeholder */}
          {isImageLoading ? (
             <Text className='text-xs text-gray-500'>Loading...</Text>
          ) : formik.values.profile_pic ? (
            // Display the user's selected/current image from Formik state
            <Image 
              source={{ uri: formik.values.profile_pic }} 
              className='w-full h-full rounded-full'
            />
          ) : (
            // Display a placeholder icon if no image is set
            <User size={50} color="#6B46C1" /> 
          )}
          
          {/* Overlay for "Edit" icon when in editing mode */}
          {profileUpdateMutation.isPending && !isImageLoading && (
            <View className='absolute bottom-0 right-0 p-1 bg-[#6B46C1] rounded-full border-2 border-white'>
              <Camera size={18} color="white" />
            </View>
          )}

        </TouchableOpacity>
        
        {/* Use Formik or Auth data for display names */}
        <Text className='text-3xl text-center font-bold text-black mt-2'>{formik.values.full_name}</Text>
        <Text className='text-base text-center text-gray-500'>@{formik.values.username}</Text>
      </View>

      <View className='w-full max-w-sm mx-auto'>
        
        <Text className='text-xl font-semibold mb-3 text-gray-800'>Account Information</Text>

        {/* Full Name Field */}
        <SingleTextField
          label='Full Name'
          // ** Use value and Formik handlers **
          value={formik.values.full_name}
          onChangeText={formik.handleChange('full_name')}
          onBlur={formik.handleBlur('full_name')} // Important for validation
          editable={!profileUpdateMutation.isPending} // Enable editing only when isEditing is true
          error={formik.touched.full_name && formik.errors.full_name} // Display error
          secureTextEntry={false}
          multiline={false}
          className='mb-4'
        />

        {/* Username Field */}
        <SingleTextField
          label='Username'
          value={formik.values.username}
          onChangeText={formik.handleChange('username')}
          onBlur={formik.handleBlur('username')}
          editable={!profileUpdateMutation.isPending} 
          error={formik.touched.username && formik.errors.username}
          secureTextEntry={false}
          multiline={false}
          className='mb-4'
        />


        {/* Email Field */}
        <SingleTextField
          label='Email Address'
          value={formik.values.email}
          onChangeText={formik.handleChange('email')}
          onBlur={formik.handleBlur('email')}
          editable={!profileUpdateMutation.isPending}
          error={formik.touched.email && formik.errors.email}
          keyboardType='email-address'
          secureTextEntry={false}
          multiline={false}
          className='mb-4'
        />
        
        {/* SCC Field (Key changed to 'scc' for consistency) */}
        <SingleTextField
          label='SCC'
          value={formik.values.scc}
          onChangeText={formik.handleChange('scc')}
          onBlur={formik.handleBlur('scc')}
          editable={!profileUpdateMutation.isPending}
          error={formik.touched.scc && formik.errors.scc}
          keyboardType='numeric'
          secureTextEntry={false}
          multiline={false}
          className='mb-4'
        />
        
        {/* Bio Field (Example of a multi-line text field) */}
        <SingleTextField
          label='Bio (Optional)'
          value={formik.values.bio}
          onChangeText={formik.handleChange('bio')}
          onBlur={formik.handleBlur('bio')}
          editable={!profileUpdateMutation.isPending}
          error={formik.touched.bio && formik.errors.bio}
          secureTextEntry={false}
          multiline={true}
          numberOfLines={4}
          className='mb-4 h-24' // Add a fixed height for multiline text
        />

      </View>

      {/* --- */}

      {/* === Action Button === */}
      <View className='w-full max-w-sm mx-auto mb-10'>
        <CustomButton
          title={'Save Profile'}
          onPress={handleEditSave} // Calls formik.handleSubmit when isEditing is true
          className={profileUpdateMutation.isPending ? 'bg-green-600' : 'bg-[#6B46C1]'} 
          isLoading={profileUpdateMutation.isPending} // Use mutation loading state
        />
        
        <CustomButton
          title='Change Password'
          onPress={() => router.push("/(auth)/reset_password")}
          className='bg-red-500 mt-3'
          isLoading={false}
        />
      </View>

    </ScrollView>
  )
}

export default ProfilePage