import React, { Component, ErrorInfo, ReactNode } from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
  errorInfo: ErrorInfo | null;
}

class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      hasError: false,
      error: null,
      errorInfo: null,
    };
  }

  static getDerivedStateFromError(error: Error): State {
    return {
      hasError: true,
      error,
      errorInfo: null,
    };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('ErrorBoundary caught an error:', error, errorInfo);
    this.setState({
      error,
      errorInfo,
    });
  }

  handleReset = () => {
    this.setState({
      hasError: false,
      error: null,
      errorInfo: null,
    });
  };

  render() {
    if (this.state.hasError) {
      return (
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20, backgroundColor: '#fff' }}>
          <Text style={{ fontSize: 24, fontWeight: 'bold', color: '#dc2626', marginBottom: 10 }}>
            Something went wrong
          </Text>
          <Text style={{ fontSize: 16, color: '#6b7280', marginBottom: 20, textAlign: 'center' }}>
            The app encountered an error. Please try again.
          </Text>
          
          {__DEV__ && this.state.error && (
            <ScrollView style={{ maxHeight: 200, width: '100%', marginBottom: 20 }}>
              <Text style={{ fontSize: 12, color: '#ef4444', fontFamily: 'monospace' }}>
                {this.state.error.toString()}
              </Text>
              {this.state.errorInfo && (
                <Text style={{ fontSize: 10, color: '#9ca3af', fontFamily: 'monospace', marginTop: 10 }}>
                  {this.state.errorInfo.componentStack}
                </Text>
              )}
            </ScrollView>
          )}
          
          <TouchableOpacity
            onPress={this.handleReset}
            style={{
              backgroundColor: '#3b82f6',
              paddingHorizontal: 30,
              paddingVertical: 15,
              borderRadius: 8,
            }}
          >
            <Text style={{ color: 'white', fontSize: 16, fontWeight: '600' }}>
              Try Again
            </Text>
          </TouchableOpacity>
        </View>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;