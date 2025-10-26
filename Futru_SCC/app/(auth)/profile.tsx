import { View, Text, ScrollView, Image, TouchableOpacity, Alert, Platform } from 'react-native'
import SingleTextField from '@/components/Common/SingleTextField'
import CustomButton from '@/components/Common/CustomButton'
import { User, Camera } from 'lucide-react-native';
import { useState } from 'react'; 
// === NEW IMPORTS FOR IMAGE PICKER ===
import * as ImagePicker from 'expo-image-picker';
import { useRouter } from "expo-router"

// Mock user data mirroring the sign-up fields for display
interface UserProfile {
  fullName: string;
  username: string;
  scc: string;
  email: string;
  bio: string;
  profileImageUri: string | null; 
}

const mockUserProfile: UserProfile = {
  fullName: "Alice Johnson",
  username: "alice_j",
  scc: "8675",
  email: "alice.johnson@example.com",
  bio: "Passionate about web and mobile development, focusing on React Native and TypeScript. Always learning new things and contributing to open-source projects.",
  profileImageUri: null, // Start with no image
};

function ProfilePage() {
  
  const [user, setUser] = useState(mockUserProfile); 
  const [isEditing, setIsEditing] = useState(false); 
  const [isLoading, setIsLoading] = useState(false); // New state for loading
  const router = useRouter();

  // === UPDATED IMAGE PICKER FUNCTION ===
  const handleImagePick = async () => {
    // Only allow image picking if in edit mode
    if (!isEditing) return;

    // 1. Request Permissions
    if (Platform.OS !== 'web') {
      const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();
      if (status !== 'granted') {
        Alert.alert('Permission required', 'We need camera roll permissions to make this work!');
        return;
      }
    }
    
    setIsLoading(true);

    // 2. Launch Image Picker
    let result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true, // Allow user to crop/edit the image
      aspect: [1, 1], // Square aspect ratio for a profile picture
      quality: 1,
    });
    
    setIsLoading(false);

    // 3. Handle Result
    if (!result.canceled) {
      // result.assets is an array of selected assets
      const selectedAsset = result.assets[0];
      
      // Update the user state with the new URI
      setUser(prev => ({ ...prev, profileImageUri: selectedAsset.uri }));
      
      // NOTE: In a production app, you would now upload this 'selectedAsset.uri' 
      // to your backend server (e.g., using a FormData API call).
      console.log("New profile image URI:", selectedAsset.uri);
      Alert.alert("Success", "Profile picture updated locally. Press 'Save Profile' to finalize.");

    } else {
      console.log('Image picking cancelled');
    }
  };
  // ===================================

  // Handler for the Edit/Save button
  const handleEditSave = () => {
    if (isEditing) {
       console.log('Saving profile data and image...');
       // In a real app, if the image URI has changed, you would trigger the final upload/save here.
       // For this example, we just toggle the mode.
    }
    setIsEditing(prev => !prev);
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
          disabled={!isEditing || isLoading}
        >
          {/* Display Loading or Image/Placeholder */}
          {isLoading ? (
             <Text className='text-xs text-gray-500'>Loading...</Text>
          ) : user.profileImageUri ? (
            // Display the user's selected image
            <Image 
              source={{ uri: user.profileImageUri }} 
              className='w-full h-full rounded-full'
            />
          ) : (
            // Display a placeholder icon if no image is set
            <User size={50} color="#6B46C1" /> 
          )}
          
          {/* Overlay for "Edit" icon when in editing mode */}
          {isEditing && !isLoading && (
            <View className='absolute bottom-0 right-0 p-1 bg-[#6B46C1] rounded-full border-2 border-white'>
              <Camera size={18} color="white" />
            </View>
          )}

        </TouchableOpacity>
        
        <Text className='text-3xl font-bold text-black mt-2'>{user.fullName}</Text>
        <Text className='text-base text-gray-500'>@{user.username}</Text>
      </View>

      {/* --- */}

      {/* === Profile Details === */}
      <View className='w-full max-w-sm mx-auto'>
        
        <Text className='text-xl font-semibold mb-3 text-gray-800'>Account Information</Text>

        {/* Full Name Field */}
        <SingleTextField
          label='Full Name'
          text={user.fullName}
          onChangeText={(text) => setUser(prev => ({ ...prev, fullName: text }))}
          secureTextEntry={false}
          multiline={false}
          className='mb-4'
        />

        {/* Email Field */}
        <SingleTextField
          label='Email Address'
          text={user.email}
          onChangeText={(text) => setUser(prev => ({ ...prev, email: text }))}
          keyboardType='email-address'
          secureTextEntry={false}
          multiline={false}
          className='mb-4'
        />

        {/* SCC Field */}
        <SingleTextField
          label='SCC'
          text={user.scc}
          onChangeText={(text) => setUser(prev => ({ ...prev, scc: text }))}
          keyboardType='numeric'
          secureTextEntry={false}
          multiline={false}
          className='mb-4'
        />

      </View>

      {/* --- */}

      {/* === Action Button === */}
      <View className='w-full max-w-sm mx-auto mb-10'>
        <CustomButton
          title={isEditing ? 'Save Profile' : 'Edit Profile'}
          onPress={handleEditSave}
          className={isEditing ? 'bg-green-600' : 'bg-[#6B46C1]'} 
          isLoading={false} 
        />
        
        <CustomButton
          title='Change Password'
          onPress={() => router.push("/(auth)/reset_password")}
          className='bg-red-500 mt-3'
        />
      </View>

    </ScrollView>
  )
}

export default ProfilePage