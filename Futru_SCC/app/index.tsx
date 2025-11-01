import  { useEffect } from 'react'
import { useRouter } from 'expo-router'
import { Image, Text, View } from 'react-native'

function SplashScreenPage() {
  const router = useRouter();

  useEffect(() => {
    const timer = setTimeout(() => {
      router.replace('/(scc)')
    }, 2000)

    return () => clearTimeout(timer)
  }, [router])

  return (
    <View className='justify-center items-center flex-1'>
      <Image
        source={require('../assets/images/church.png')}
        className='mb-5 font-[Roboto-Mono]'
        style={{ width: 275, height: 275 }}
      />
      <Text className='h-48'>
        {"St. Micheal's Parish Futru"}
      </Text>
    </View>
  )
}

export default SplashScreenPage