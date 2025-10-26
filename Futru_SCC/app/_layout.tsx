import "./global.css";
import * as SplashScreen from 'expo-splash-screen';
import Toast from 'react-native-toast-message';
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import RootLayoutContent from "@/layout/RootLayoutContent";
import { GestureHandlerRootView } from 'react-native-gesture-handler';

SplashScreen.preventAutoHideAsync();

const initialClient = new QueryClient({
    defaultOptions: {
      queries: {
        retry: 5,
        retryDelay: 1000
      }
    }
});


export default function RootLayout() {

  return (
    <GestureHandlerRootView style={{ flex: 1 }}> 
      <QueryClientProvider client={initialClient}>
        <RootLayoutContent/>
      </QueryClientProvider>
      <Toast/>
    </GestureHandlerRootView>
  );
}