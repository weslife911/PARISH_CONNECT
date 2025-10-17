import { View, TouchableOpacity, Text, TouchableWithoutFeedback } from 'react-native';
import { Menu, UserCircle } from 'lucide-react-native';
import { useNavigation } from '@react-navigation/native';
import { useState } from 'react';

export default function CustomHeader() {
  const navigation = useNavigation();
  const [isPopoverVisible, setIsPopoverVisible] = useState(false); 

  const handleMenuPress = () => {
    navigation.openDrawer();
  }
    
  const handleProfilePress = () => {
    setIsPopoverVisible(!isPopoverVisible);
  };
  
  const handleOptionSelect = (option: string) => {
    console.log(`Selected: ${option}`);
    setIsPopoverVisible(false);
  };

  const popoverOptions = [
    { label: 'Profile', action: 'view_profile' },
    { label: 'Settings', action: 'settings' },
    { label: 'Logout', action: 'logout' },
  ];

  const closePopover = () => {
    setIsPopoverVisible(false);
  };

  return (
    // The main header container remains the same
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
            {popoverOptions.map((item, index) => (
              <TouchableOpacity
                key={item.action}
                className={`
                  p-3 
                  ${index < popoverOptions.length - 1 ? 'border-b border-gray-100' : ''}
                `}
                onPress={() => handleOptionSelect(item.action)}
              >
                <Text className="text-sm text-gray-800">{item.label}</Text>
              </TouchableOpacity>
            ))}
          </View>
        )}
      </View>
    </View>
  );
}