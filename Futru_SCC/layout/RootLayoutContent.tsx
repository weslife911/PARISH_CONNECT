import { Drawer } from "expo-router/drawer";
import { KeyboardAvoidingView, Platform, View } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import CustomHeader from "@/components/Common/CustomHeader";
import Loader from "@/components/Loader/Loader";
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { useEffect } from "react";
import { UseCheckAuthQuery } from "@/services/Auth/queries";

SplashScreen.preventAutoHideAsync();

function RootLayoutContent() {

    const checkAuth = UseCheckAuthQuery();

    const [fontsLoaded] = useFonts({
        "Roboto-Mono": require("../assets/fonts/RobotoMono-Bold.ttf")
    });

    useEffect(() => {
        if (fontsLoaded) {
            SplashScreen.hideAsync();
        }
    }, [fontsLoaded]);

    const isLoading = !fontsLoaded || checkAuth.isPending;

    if (isLoading) {
        return (
            <SafeAreaProvider>
                <GestureHandlerRootView className="flex-1">
                    <View className="flex-1 bg-white">
                        <Loader />
                    </View>
                </GestureHandlerRootView>
            </SafeAreaProvider>
        );
    }

    return (
        // Ensured SafeAreaProvider is bg-white
        <SafeAreaProvider className="bg-white"> 
            {/* Ensured GestureHandlerRootView is bg-white */}
            <GestureHandlerRootView className="flex-1 bg-white"> 
                {/* Ensured KeyboardAvoidingView is bg-white */}
                <KeyboardAvoidingView 
                    className="flex-1 bg-white"  
                    behavior={Platform.OS === "ios" ? "padding" : "height"}
                >
                    <Drawer screenOptions={{
                        headerShown: true,
                        // CustomHeader handles SafeArea internally now
                        header: ({ navigation }) => <CustomHeader />, 
                        // Removed headerTransparent: true
                        drawerType: 'slide', 
                        overlayColor: '#00000050',
                        drawerPosition: 'left',
                    }}>

                        <Drawer.Screen 
                            name="(scc)"
                            options={{ 
                                drawerLabel: 'Home',
                                title: 'SCC',
                            }} 
                        />

                        <Drawer.Screen 
                            name="(auth)"
                            options={{ 
                                drawerLabel: 'Login',
                                title: 'Login',
                            }} 
                        />
                    </Drawer>
                </KeyboardAvoidingView>
            </GestureHandlerRootView>
        </SafeAreaProvider>
    );
}

export default RootLayoutContent;