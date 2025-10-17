import { Drawer } from "expo-router/drawer";
import { KeyboardAvoidingView, Platform } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import "./global.css";
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import CustomHeader from "@/components/Common/CustomHeader";
import { Stack } from "expo-router";
import Loader from "@/components/Loader/Loader";

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {

  const [fontsLoaded] = useFonts({
    "Roboto-Mono": require("../assets/fonts/RobotoMono-Bold.ttf")
  });

  if (!fontsLoaded) {
    return <Loader/>;
  }

  SplashScreen.hideAsync();

  return (
    <SafeAreaProvider>
      <KeyboardAvoidingView className="flex-1 bg-white"  behavior={ Platform.OS === "ios" ? "padding" : "height" }>
        <Drawer screenOptions={{
          headerShown: true,
          header: ({ navigation }) => <CustomHeader />, 
          headerTransparent: true,
          headerShadowVisible: false,
          drawerType: 'slide', 
          overlayColor: '#00000050',
          drawerPosition: 'left',
        }}>
          <Drawer.Screen 
            name="(scc)" 
            options={{ 
              drawerLabel: 'Home',
              title: 'Home',
            }} 
          />

          <Drawer.Screen 
            name="(auth)" 
            options={{ 
              drawerLabel: 'Login',
              title: 'Login',
            }} 
          />
          
        <Stack screenOptions={{
          header: () => <CustomHeader />,
          headerTransparent: true,
          headerShadowVisible: false,
        }}>
          <Stack.Screen 
            name="index" 
            options={{ 
              headerShown: false
            }} 
          />
          <Stack.Screen name="(scc)" />
          <Stack.Screen name="(auth)" />
        </Stack>
        </Drawer>
      </KeyboardAvoidingView>
    </SafeAreaProvider>
  );
}

