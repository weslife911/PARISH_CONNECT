import React from 'react';
import {
    View,
    Text,
    TouchableOpacity,
    ScrollView,
    Switch,
} from 'react-native';
import { Stack, useRouter } from 'expo-router';
import { useLogoutMutation } from '@/services/Auth/mutations';
import { useAuthStore } from '@/store/useAuthStore';

// --- Theme Simulation Setup (In a real app, this would be a separate file/context) ---

// Define theme types
type ThemeName = 'default' | 'dark';
type Theme = {
    primaryBg: string;
    secondaryBg: string;
    primaryText: string;
    secondaryText: string;
    accent: string;
    border: string;
};

const themes: Record<ThemeName, Theme> = {
    default: {
        primaryBg: 'bg-gray-50',
        secondaryBg: 'bg-white',
        primaryText: 'text-gray-800',
        secondaryText: 'text-gray-600',
        accent: 'bg-indigo-600',
        border: 'border-gray-200',
    },
    dark: {
        primaryBg: 'bg-gray-900',
        secondaryBg: 'bg-gray-800',
        primaryText: 'text-gray-50',
        secondaryText: 'text-gray-300',
        accent: 'bg-indigo-500',
        border: 'border-gray-700',
    },
};

// Simulated theme context hook
const useThemeContext = () => {
    // In a real app, theme and setTheme would be managed via React Context or Redux
    const [currentTheme, setCurrentTheme] = React.useState<ThemeName>('default');
    const [notificationsEnabled, setNotificationsEnabled] = React.useState(true);

    const theme = themes[currentTheme];

    return {
        theme,
        currentTheme,
        setCurrentTheme,
        notificationsEnabled,
        setNotificationsEnabled,
    };
};
// --- END Theme Simulation Setup ---

// --- Helper Components ---

interface SettingsSectionProps {
    title: string;
    children: React.ReactNode;
}

const SettingsSection = ({ title, children }: SettingsSectionProps) => (
    <View className="mb-6 mx-4">
        <Text className="text-xl font-bold text-indigo-600 mb-3">{title}</Text>
        <View className="rounded-xl shadow-sm overflow-hidden">{children}</View>
    </View>
);

interface SettingsItemProps {
    label: string;
    children?: React.ReactNode;
    isLast?: boolean;
    onPress?: () => void;
    currentTheme: Theme;
}

const SettingsItem = ({ label, children, isLast = false, onPress, currentTheme }: SettingsItemProps) => (
    <TouchableOpacity
        className={`flex-row justify-between items-center p-4 ${currentTheme.secondaryBg} ${!isLast ? `border-b ${currentTheme.border}` : ''}`}
        onPress={onPress}
        disabled={!onPress}
    >
        <Text className={`text-base ${currentTheme.primaryText}`}>{label}</Text>
        <View>{children}</View>
    </TouchableOpacity>
);

// --- Main Component ---

export default function SettingsPage() {
    const router = useRouter();
    const logoutMutation = useLogoutMutation();
    const { isAuthenticated } = useAuthStore();
    const { 
        theme, 
        currentTheme, 
        setCurrentTheme,
        notificationsEnabled,
        setNotificationsEnabled
    } = useThemeContext();

    const toggleTheme = (themeName: ThemeName) => {
        setCurrentTheme(themeName);
    };

    const toggleNotifications = () => {
        setNotificationsEnabled(prev => !prev);
    };

    return (
        <>
            <Stack.Screen
                options={{
                    title: 'Settings',
                    headerStyle: { backgroundColor: theme.secondaryBg },
                    headerTintColor: currentTheme === 'dark' ? '#f9fafb' : '#1f2937', // Adjust text color for dark mode header
                    headerShadowVisible: false,
                }}
            />
            <ScrollView className={`flex-1 ${theme.primaryBg} pt-4`}>
                
                {/* Theme Selection */}
                <SettingsSection title="Theme & Appearance">
                    <SettingsItem
                        label="Dark Mode"
                        currentTheme={theme}
                    >
                        <Switch
                            trackColor={{ false: theme.border, true: '#818cf8' }}
                            thumbColor={currentTheme === 'dark' ? '#f4f3f4' : '#f4f3f4'}
                            onValueChange={() => toggleTheme(currentTheme === 'dark' ? 'default' : 'dark')}
                            value={currentTheme === 'dark'}
                        />
                    </SettingsItem>
                    <SettingsItem 
                        label="Current Theme" 
                        isLast 
                        currentTheme={theme}
                    >
                        <Text className={`font-semibold capitalize ${theme.secondaryText}`}>
                            {currentTheme}
                        </Text>
                    </SettingsItem>
                </SettingsSection>
                
                {/* Notification Settings */}
                <SettingsSection title="Notifications">
                    <SettingsItem
                        label="Enable Notifications"
                        currentTheme={theme}
                        onPress={toggleNotifications}
                    >
                        <Switch
                            trackColor={{ false: theme.border, true: '#818cf8' }}
                            thumbColor={notificationsEnabled ? '#f4f3f4' : '#f4f3f4'}
                            onValueChange={toggleNotifications}
                            value={notificationsEnabled}
                        />
                    </SettingsItem>
                    <SettingsItem
                        label="Sound Alerts"
                        currentTheme={theme}
                        isLast
                    >
                        <Switch
                            trackColor={{ false: theme.border, true: '#818cf8' }}
                            thumbColor={'#f4f3f4'}
                            // Simulated state for this example
                            value={notificationsEnabled} 
                            disabled={!notificationsEnabled}
                        />
                    </SettingsItem>
                </SettingsSection>

                {/* Account Settings */}
                {isAuthenticated && <SettingsSection title="Account">
                    <SettingsItem 
                        label="Change Password" 
                        currentTheme={theme}
                        onPress={() => router.push("/(auth)/forgot_password")}
                    >
                        <Text className="text-lg text-gray-400">{">"}</Text>
                    </SettingsItem>
                    <SettingsItem 
                        label="Update Profile" 
                        currentTheme={theme}
                        onPress={() => router.push("/(auth)/profile")}
                    >
                        <Text className="text-lg text-gray-400">{">"}</Text>
                    </SettingsItem>
                    <SettingsItem 
                        label="Logout" 
                        currentTheme={theme}
                        isLast
                        onPress={() => {
                            logoutMutation.mutate();
                            router.push("/(scc)");
                        }}
                    >
                        <Text className="text-red-500 font-semibold">Sign Out</Text>
                    </SettingsItem>
                </SettingsSection>}
                
                <View className="mb-10 mx-4">
                    <Text className={`text-center text-xs ${theme.secondaryText}`}>
                        SCC Reporting App v1.0.0
                    </Text>
                </View>

            </ScrollView>
        </>
    );
}