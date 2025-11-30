import  { useEffect } from 'react'
import { useRouter } from 'expo-router'
import { Image, Text, View } from 'react-native'

function SplashScreenPage() {
  const router = useRouter();

  useEffect(() => {
    const timer = setTimeout(() => {
      // Navigate to the main SCC screen
      router.replace('/(scc)')
    }, 2000)

    return () => clearTimeout(timer)
  }, [router])

  return (
    <View className='justify-center items-center flex-1 bg-white'>
      <Image
        source={require('../assets/images/church.png')}
        className='mb-5'
        style={{ width: 250, height: 250 }}
        resizeMode="contain"
      />
      <Text className='text-3xl font-extrabold text-indigo-700 text-center px-4'>
        {"St. Micheal's Parish Futru"}
      </Text>
      <Text className='text-md text-gray-500 mt-2'>
        SCC Reporting
      </Text>
    </View>
  )
}

export default SplashScreenPage
