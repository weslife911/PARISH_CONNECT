import { Drawer } from "expo-router/drawer";
import { KeyboardAvoidingView, Platform } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import CustomHeader from "@/components/Common/CustomHeader";
import Loader from "@/components/Loader/Loader";
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { useEffect } from "react";
import { UseCheckAuthQuery } from "@/services/Auth/queries";
import { UseLogoutMutation } from "@/services/Auth/mutations";

SplashScreen.preventAutoHideAsync();

function RootLayoutContent() {
    // ALL HOOKS MUST BE CALLED BEFORE ANY CONDITIONAL RETURNS
    const [fontsLoaded] = useFonts({
        "Roboto-Mono": require("../assets/fonts/RobotoMono-Bold.ttf")
    });

    const checkAuth = UseCheckAuthQuery();
    const logoutUser = UseLogoutMutation(); 

    useEffect(() => {
        if (fontsLoaded) {
            SplashScreen.hideAsync();
        }
    }, [fontsLoaded]);

    // NOW check loading state AFTER all hooks
    if (!fontsLoaded || checkAuth.isPending || logoutUser.isPending) {
        return <Loader/>;
    }

    return (
        <SafeAreaProvider>
            <GestureHandlerRootView className="flex-1">
                <KeyboardAvoidingView 
                    className="flex-1 bg-white"  
                    behavior={Platform.OS === "ios" ? "padding" : "height"}
                >
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