import "./global.css";
import * as SplashScreen from 'expo-splash-screen';
import Toast from 'react-native-toast-message';
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import RootLayoutContent from "@/layout/RootLayoutContent";
// import { router, useSegments } from "expo-router";

SplashScreen.preventAutoHideAsync();

const initialClient = new QueryClient({
    defaultOptions: {
      queries: {
        retry: 5,
        retryDelay: 1000
      }
    }
});

// function useProtectedRoute(isAuthenticated: boolean, isAuthChecking: boolean) {
//     const segments = useSegments();
    
//     const unprotectedRoutes = ['(auth)', 'index']; 

//     useEffect(() => {
//         if (isAuthChecking) return;

//         const inAuthGroup = segments[0] === '(auth)';
        
//         if (isAuthenticated && inAuthGroup) {
//             router.replace('/'); 
//         } else if (!isAuthenticated && !inAuthGroup) {
//             const currentRoute = segments[0];
            
//             if (!unprotectedRoutes.includes(currentRoute)) {
//                 console.log(`Redirecting from ${currentRoute} to /login`);
//                 router.replace('/(auth)'); 
//             }
//         }
//     }, [isAuthenticated, segments, isAuthChecking, unprotectedRoutes]);
// }


export default function RootLayout() {

  return (
    <>
      <QueryClientProvider client={initialClient}>
        <RootLayoutContent/>
      </QueryClientProvider>
      <Toast/>
    </>
  );
}