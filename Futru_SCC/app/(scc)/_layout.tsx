import { Stack } from 'expo-router'

export default function SCCLayout() {
  return (
    <Stack screenOptions={{
      headerShown: false
    }}>
      <Stack.Screen name='index' /> 
      
      <Stack.Screen name='addRecord' />
      
      <Stack.Screen name='details/[id]' /> 
    </Stack>
  )
}