import "./global.css";
import * as SplashScreen from 'expo-splash-screen';
import Toast from 'react-native-toast-message';
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import RootLayoutContent from "@/layout/RootLayoutContent";
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import ErrorBoundary from '@/components/Boundary/ErrorBoundary';

SplashScreen.preventAutoHideAsync();

const initialClient = new QueryClient({
    defaultOptions: {
      queries: {
        retry: 3, // Reduced from 5
        retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 10000),
        staleTime: 5 * 60 * 1000,
        refetchOnWindowFocus: false,
        refetchOnReconnect: true,
      },
      mutations: {
        retry: 2,
      }
    }
});

export default function RootLayout() {
  return (
    <ErrorBoundary>
      <GestureHandlerRootView style={{ flex: 1 }}> 
        <QueryClientProvider client={initialClient}>
          <RootLayoutContent/>
        </QueryClientProvider>
        <Toast/>
      </GestureHandlerRootView>
    </ErrorBoundary>
  );
}