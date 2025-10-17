import { View, StyleSheet } from 'react-native';

const HorizontalRule = ({ color = '#ccc', height = 1, width = '100%', style }: {
    color?: string;
    height?: number;
    width?: string | number;
    style?: object;
}) => {
    return (
    <View style={[styles.hr, { backgroundColor: color, height: height, width: width }, style]} />
    );
};

const styles = StyleSheet.create({
    hr: {
    },
});

export default HorizontalRule;