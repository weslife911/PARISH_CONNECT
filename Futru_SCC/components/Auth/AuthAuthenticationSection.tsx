import React from 'react';
import { Text, View } from "react-native";
// Assuming HorizontalRule is a simple line component
import HorizontalRule from "../Common/HorizontalRule"; 
import SocialButton from "./SocialButton";


function AuthAuthenticationSection() {
  return (
    <View className='items-center' style={{ marginTop: 39 }}>
        <Text style={{ marginBottom : 3 }}>
            OR
        </Text>
        <HorizontalRule style={{ marginBottom: 23 }} />
        <View className='flex-row justify-center'>
            <SocialButton iconType="google" /> 
            <SocialButton iconType="x" />
        </View>
    </View>
  )
}

export default AuthAuthenticationSection;