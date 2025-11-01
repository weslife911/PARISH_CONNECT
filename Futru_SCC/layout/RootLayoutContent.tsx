// RootLayoutContent.tsx (Corrected)

import { Drawer } from "expo-router/drawer";
import { KeyboardAvoidingView, Platform, View } from "react-native";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import CustomHeader from "@/components/Common/CustomHeader";
import Loader from "@/components/Loader/Loader";
import { useEffect } from "react";
import { useCheckAuthQuery } from "@/services/Auth/queries";
import { useGetSCCRecordsQuery } from "@/services/SCC/queries";
import { useNetInfo } from "@react-native-community/netinfo"; // 👈 New Import
import NoInternetScreen from "@/components/Screens/NoInternetScreen";
import { useQueryClient } from "@tanstack/react-query"; // 👈 New Import

SplashScreen.preventAutoHideAsync();

function RootLayoutContent() {

    const checkAuth = useCheckAuthQuery();
    const sccGetRecordsQuery = useGetSCCRecordsQuery();
    
    // --- NETWORK LOGIC ---
    const netInfo = useNetInfo();
    const queryClient = useQueryClient();
    const isDefinitelyOffline = netInfo.isInternetReachable === false;

    const [fontsLoaded, fontError] = useFonts({
        "Roboto-Mono": require("../assets/fonts/RobotoMono-Bold.ttf")
    });
    
    useEffect(() => {
        if (fontsLoaded || fontError) {
            SplashScreen.hideAsync();
        }
    }, [fontsLoaded, fontError]);

    useEffect(() => {
        if (fontError) {
            console.error("Font loading error:", fontError);
        }
    }, [fontError]);

    useEffect(() => {
        if (checkAuth.isError) {
            console.error("Auth check error:", checkAuth.error);
        }
    }, [checkAuth.isError, checkAuth.error]);

    useEffect(() => {
        if (sccGetRecordsQuery.isError) {
            console.error("SCC records error:", sccGetRecordsQuery.error);
        }
    }, [sccGetRecordsQuery.isError, sccGetRecordsQuery.error]);

    const isLoading = !fontsLoaded || checkAuth.isPending || sccGetRecordsQuery.isPending;

    if (isDefinitelyOffline) {
        return (
            <NoInternetScreen 
                onRetry={() => {
                    queryClient.invalidateQueries(); 
                }}
            />
        );
    }

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
                <SafeAreaView style={{ flex: 1 }} edges={['left', 'right', 'bottom']}>
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
                </SafeAreaView>
            </KeyboardAvoidingView>
        </SafeAreaProvider>
    );
}

export default RootLayoutContent;