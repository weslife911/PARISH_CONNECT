import { Stack } from 'expo-router'
import React from 'react'

function AuthLayout() {
  return (
    <Stack screenOptions={{ 
      headerShown: false
     }}>
        <Stack.Screen name='index' />
    </Stack>
  )
}

export default AuthLayout
