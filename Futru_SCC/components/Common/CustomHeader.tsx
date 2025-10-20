import { View, TouchableOpacity, Text, TouchableWithoutFeedback } from 'react-native';
import { Menu, UserCircle, LogOut } from 'lucide-react-native';
import { useNavigation } from '@react-navigation/native';
import { useState } from 'react';
import { useAuthStore } from '@/store/useAuthStore';
import { UseLogoutMutation } from '@/services/Auth/mutations';

export default function CustomHeader() {
  const navigation = useNavigation();
  const [isPopoverVisible, setIsPopoverVisible] = useState(false);
  const logoutUser = UseLogoutMutation();  

  // Get both isAuthenticated and the logout function from the store
  const { isAuthenticated } = useAuthStore(); 

  const handleMenuPress = () => {
    // This is Expo Router's navigation for the drawer, wrapped by useNavigation
    navigation.openDrawer();
  }
    
  const handleProfilePress = () => {
    setIsPopoverVisible(!isPopoverVisible);
  };
  
  // FIX: Implement logic for each action
  const handleOptionSelect = (action: string) => {
    setIsPopoverVisible(false);
    
    switch (action) {
        case 'login':
            // Assuming the router is available or using navigation
            navigation.navigate('(auth)' as never); // Navigate to the auth group
            break;
        case 'logout':
            logoutUser.mutate();
            break;
        case 'view_profile':
            // navigation.navigate('profile' as never);
            console.log("Navigating to Profile");
            break;
        case 'settings':
            // navigation.navigate('settings' as never);
            console.log("Navigating to Settings");
            break;
        default:
            console.log(`Selected: ${action}`);
    }
  };

  const closePopover = () => {
    setIsPopoverVisible(false);
  };

  // Define ALL possible options and their authentication requirement
  const allPopoverOptions = [
    { label: "Login", action: "login", requiredAuth: false, icon: null, isDestructive: false },
    { label: 'Profile', action: 'view_profile', requiredAuth: true, icon: null, isDestructive: false },
    { label: 'Settings', action: 'settings', requiredAuth: true, icon: null, isDestructive: false },
    { label: 'Logout', action: 'logout', requiredAuth: true, icon: LogOut, isDestructive: true }, 
  ];
  
  // FIX: Filter options based on authentication state
  const displayedOptions = allPopoverOptions.filter(option => {
    if (isAuthenticated) {
        // Show only options that REQUIRE authentication
        return option.requiredAuth === true;
    } else {
        // Show only options that DO NOT REQUIRE authentication
        return option.requiredAuth === false;
    }
  });


  return (
    <View className="bg-purple-100 mx-4 mt-12 mb-4 rounded-full px-6 py-4 flex-row justify-between items-center relative z-20">
      
      {isPopoverVisible && (
        <TouchableWithoutFeedback onPress={closePopover}>
          <View className="absolute top-0 left-0 right-0 bottom-0" style={{ zIndex: 10 }}>
          </View>
        </TouchableWithoutFeedback>
      )}

      <TouchableOpacity 
        onPress={handleMenuPress}
        className="p-2"
        activeOpacity={0.7}
      >
        <Menu size={24} color="#000" strokeWidth={2} />
      </TouchableOpacity>

      <View className="relative z-50">
        <TouchableOpacity 
          onPress={handleProfilePress}
          className="p-2"
          activeOpacity={0.7}
        >
          <UserCircle size={28} color="#000" strokeWidth={2} />
        </TouchableOpacity>
        
        {isPopoverVisible && (
          <View 
            className="
              absolute 
              top-14 
              right-0 
              w-40 
              bg-white 
              rounded-lg 
              border 
              border-gray-200 
              shadow-lg 
              z-50
            "
          >
            {displayedOptions.map((item, index) => (
              <TouchableOpacity
                key={item.action}
                className={`
                  p-3 
                  flex-row items-center justify-start rounded-lg
                  ${index < displayedOptions.length - 1 && !item.isDestructive ? 'border-b border-gray-100' : ''}
                  ${item.isDestructive ? 'bg-red-500 mt-1' : ''} // FIX: Apply red background and margin for destructive actions
                `}
                onPress={() => handleOptionSelect(item.action)}
              >
                {/* FIX: Render icon if available */}
                {item.icon && <item.icon size={18} color={item.isDestructive ? "#fff" : "#000"} className="mr-2" />} 
                <Text 
                  className={`
                    text-sm 
                    ${item.isDestructive ? 'text-white' : 'text-gray-800'} // FIX: Text color for destructive actions
                  `}
                >
                  {item.label}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        )}
      </View>
    </View>
  );
}