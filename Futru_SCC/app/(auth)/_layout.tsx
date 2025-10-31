import { Stack } from 'expo-router'
import React from 'react'

function AuthLayout() {
  return (
    <Stack screenOptions={{ 
      headerShown: false
    }}>
      <Stack.Screen 
        name='index'
      />
      
      <Stack.Screen 
        name='signup'
      />
      
      <Stack.Screen 
        name='forgot_password'
      />
      
      <Stack.Screen 
        name='reset_password'
      />
      
      <Stack.Screen 
        name='profile'
      />
    </Stack>
  )
}

export default AuthLayout