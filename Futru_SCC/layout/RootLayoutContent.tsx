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
import { useNetInfo } from "@react-native-community/netinfo";
import NoInternetScreen from "@/components/Screens/NoInternetScreen";
import { useQueryClient } from "@tanstack/react-query";
import { Home, LogIn, CircleUserRound, Bolt, type Icon as LucideIcon } from 'lucide-react-native'; 

SplashScreen.preventAutoHideAsync();

interface DrawerItem {
    name: string; 
    drawerLabel: string;
    title: string;
    iconName: keyof typeof IconMap;
}

const IconMap = {
    Home: Home,
    LogIn: LogIn,
    CircleUserRound: CircleUserRound,
    Bolt: Bolt
};

// Only include top-level route groups in the drawer
const drawerItems: DrawerItem[] = [
    {
        name: '(scc)',
        drawerLabel: 'Home',
        title: 'SCC',
        iconName: 'Home',
    },
    {
        name: '(auth)',
        drawerLabel: 'Login',
        title: 'Login',
        iconName: 'LogIn',
    },
    {
        name: "(settings)/index",
        drawerLabel: "Settings",
        title: "Settings",
        iconName: "Bolt"
    }
];

function RootLayoutContent() {

    const checkAuth = useCheckAuthQuery();
    const sccGetRecordsQuery = useGetSCCRecordsQuery();
    
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
                        
                        {drawerItems.map((item) => {
                            const IconComponent = IconMap[item.iconName];

                            return (
                                <Drawer.Screen 
                                    key={item.name}
                                    name={item.name}
                                    options={{ 
                                        drawerLabel: item.drawerLabel,
                                        title: item.title,
                                        drawerIcon: ({ color, size }) => (
                                            <IconComponent color={color} size={size} />
                                        ),
                                    }} 
                                />
                            );
                        })}

                    </Drawer>
                </SafeAreaView>
            </KeyboardAvoidingView>
        </SafeAreaProvider>
    );
}

export default RootLayoutContent;