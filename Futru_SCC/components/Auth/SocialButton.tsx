import React from 'react';
import { Image, View, ImageSourcePropType } from 'react-native';

const ICON_ASSETS: { [key: string]: ImageSourcePropType } = {
  'google': require('@/assets/images/google.png'), 
  'x': require('@/assets/images/x.png'),
};

interface SocialButtonProps {
    iconType?: string;
}

function SocialButton({ iconType = 'google' }: SocialButtonProps) {
  
  const imageSource: ImageSourcePropType = 
    ICON_ASSETS[iconType as keyof typeof ICON_ASSETS] || ICON_ASSETS['google'];

  return (
    <View 
      className="bg-grey rounded-xl flex-1 items-center justify-center" 
      style={{  backgroundColor: "#DAC7C7", marginRight: 21.5, marginLeft: 21.5 }}
    >
      <Image
        source={imageSource}
        style={{ width: 84, height: 84 }}
        className=""
      />
    </View>
  );
}

export default SocialButton;