import { Drawer } from "expo-router/drawer";
import { KeyboardAvoidingView, Platform, View } from "react-native";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import CustomHeader from "@/components/Common/CustomHeader";
import Loader from "@/components/Loader/Loader";
import { useEffect } from "react";
import { useCheckAuthQuery } from "@/services/Auth/queries";
import { useGetSCCRecordsQuery } from "@/services/SCC/queries";

SplashScreen.preventAutoHideAsync();

function RootLayoutContent() {

    // FIXED: Add proper error handling for queries
    const checkAuth = useCheckAuthQuery();
    const sccGetRecordsQuery = useGetSCCRecordsQuery();

    const [fontsLoaded, fontError] = useFonts({
        "Roboto-Mono": require("../assets/fonts/RobotoMono-Bold.ttf")
    });

    useEffect(() => {
        if (fontsLoaded || fontError) {
            SplashScreen.hideAsync();
        }
    }, [fontsLoaded, fontError]);

    // FIXED: Handle font loading errors
    useEffect(() => {
        if (fontError) {
            console.error("Font loading error:", fontError);
        }
    }, [fontError]);

    // FIXED: Add error states for queries
    useEffect(() => {
        if (checkAuth.isError) {
            console.error("Auth check error:", checkAuth.error);
        }
    }, [checkAuth.isError, checkAuth.error]);

    useEffect(() => {
        if (sccGetRecordsQuery.isError) {
            console.error("SCC records fetch error:", sccGetRecordsQuery.error);
        }
    }, [sccGetRecordsQuery.isError, sccGetRecordsQuery.error]);

    const isLoading = !fontsLoaded || checkAuth.isPending || sccGetRecordsQuery.isPending;

    if (isLoading) {
        return (
            <SafeAreaProvider>
                <View className="flex-1 bg-white">
                    <Loader />
                </View>
            </SafeAreaProvider>
        );
    }

    return (
        <SafeAreaProvider> 
            <KeyboardAvoidingView 
                className="flex-1"  
                behavior={Platform.OS === "ios" ? "padding" : "height"}
            >
                <Drawer screenOptions={{
                    headerShown: true,
                    header: ({ navigation }) => <CustomHeader />, 
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
        </SafeAreaProvider>
    );
}

export default RootLayoutContent;