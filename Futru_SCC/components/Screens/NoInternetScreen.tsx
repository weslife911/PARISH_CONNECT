import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import NetInfo from '@react-native-community/netinfo';

interface Props {
  onRetry: () => void;
}

const NoInternetScreen: React.FC<Props> = ({ onRetry }) => {
  const handleRetry = () => {
    // 1. Force NetInfo to check the network status immediately
    NetInfo.refresh();
    // 2. Trigger the parent's logic (to re-fetch data)
    onRetry();
  };

  return (
    <SafeAreaProvider>
      <View style={styles.container}>
        <Text style={styles.title}>Network Unavailable</Text>
        <Text style={styles.message}>
          Please check your internet connection and tap {'Retry'}.
        </Text>
        
        <TouchableOpacity
          onPress={handleRetry}
          style={styles.button}
        >
          <Text style={styles.buttonText}>
            Retry
          </Text>
        </TouchableOpacity>
        
        <Text style={styles.hint}>
            The app will also refresh automatically when the network is restored.
        </Text>
      </View>
    </SafeAreaProvider>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#dc2626', // Error color
    marginBottom: 10,
  },
  message: {
    fontSize: 16,
    color: '#6b7280',
    marginBottom: 40,
    textAlign: 'center',
  },
  button: {
    backgroundColor: '#3b82f6', // Primary color
    paddingHorizontal: 30,
    paddingVertical: 15,
    borderRadius: 8,
    marginBottom: 20,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
  hint: {
    fontSize: 12,
    color: '#9ca3af',
    textAlign: 'center',
  }
});

export default NoInternetScreen;