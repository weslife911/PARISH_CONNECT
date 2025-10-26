import { Drawer } from "expo-router/drawer";
import { KeyboardAvoidingView, Platform, View } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import CustomHeader from "@/components/Common/CustomHeader";
import Loader from "@/components/Loader/Loader";
// import { GestureHandlerRootView } from 'react-native-gesture-handler'; // REMOVED
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
                {/* <GestureHandlerRootView className="flex-1"> REMOVED */}
                    <View className="flex-1 bg-white">
                        <Loader />
                    </View>
                {/* </GestureHandlerRootView> REMOVED */}
            </SafeAreaProvider>
        );
    }

    return (
        <SafeAreaProvider> 
            {/* <GestureHandlerRootView className="flex-1"> REMOVED */}
                <KeyboardAvoidingView 
                    className="flex-1"  
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
            {/* </GestureHandlerRootView> REMOVED */}
        </SafeAreaProvider>
    );
}

export default RootLayoutContent;