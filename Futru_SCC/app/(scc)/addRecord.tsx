// fileName: addRecord.tsx

import React, { useState } from 'react';
import { 
    View, 
    ScrollView, 
    Alert, 
    KeyboardAvoidingView, 
    Platform, 
    StyleSheet 
} from "react-native";
import { Stack } from 'expo-router';
import SingleTextField from '@/components/Common/SingleTextField';
import CustomButton from '@/components/Common/CustomButton';

// --- CONSTANTS ---
const TOTAL_STEPS = 3;

// Initial state for the form, mapping to the fields from details.tsx
const initialFormState = {
    sccName: '',
    title: '',
    date: '', 
    priest: '',
    menAttendance: '',
    womenAttendance: '',
    totalOfferings: '',
    description: '',
};

export default function AddRecord() {
    const [form, setForm] = useState(initialFormState);
    const [isSubmitting, setIsSubmitting] = useState(false);
    // New state to manage the current step
    const [currentStep, setCurrentStep] = useState(1); 

    // Generic handler to update form state
    const handleChange = (field: keyof typeof initialFormState, value: string) => {
        setForm(prev => ({
            ...prev,
            [field]: value
        }));
    };

    // Validation for each step
    const validateStep = (step: number): boolean => {
        switch (step) {
            case 1: // Event Details
                if (!form.sccName || !form.title || !form.date || !form.priest) {
                    Alert.alert("Missing Fields", "Please fill in all primary event details.");
                    return false;
                }
                return true;
            case 2: // Attendance & Financials
                // Attendance fields are optional but must be valid if entered. 
                // We'll treat totalOfferings as the only strongly required field for this step, 
                // but you can adjust this logic.
                if (!form.totalOfferings) {
                    Alert.alert("Missing Fields", "Please enter the total offerings.");
                    return false;
                }
                return true;
            case 3: // Description & Submit - No strong validation required here before moving to submit
                return true;
            default:
                return true;
        }
    };

    // Handler for the 'Next' button
    const handleNext = () => {
        if (validateStep(currentStep)) {
            if (currentStep < TOTAL_STEPS) {
                setCurrentStep(prev => prev + 1);
            }
        }
    };

    // Handler for the 'Previous' button
    const handlePrevious = () => {
        if (currentStep > 1) {
            setCurrentStep(prev => prev - 1);
        }
    };

    // Handler for the final submit button (only visible on the last step)
    const handleSubmit = () => {
        if (!validateStep(currentStep)) {
            return; // Should theoretically be caught by Next, but as a safeguard
        }

        setIsSubmitting(true);
        
        // --- API Submission Logic Goes Here ---
        console.log("Submitting Form Data:", form);
        
        // Simulate a network/API call delay
        setTimeout(() => {
            setIsSubmitting(false);
            Alert.alert("Success", "New record added successfully!");
            // Optionally navigate back or reset form after success
            // setForm(initialFormState); 
            // setCurrentStep(1);
        }, 1500);
    };

    // Function to render the fields for the current step
    const renderStepContent = () => {
        switch (currentStep) {
            case 1:
                return (
                    <View>
                        <SingleTextField
                            label="SCC Name"
                            text={form.sccName}
                            onChangeText={(text) => handleChange('sccName', text)}
                            placeholder="e.g., St. Thomas Aquinas"
                        />
                        <SingleTextField
                            label="Meeting Title"
                            text={form.title}
                            onChangeText={(text) => handleChange('title', text)}
                            placeholder="e.g., January Record"
                        />
                        <SingleTextField
                            label="Date (MM/DD/YYYY)"
                            text={form.date}
                            onChangeText={(text) => handleChange('date', text)}
                            placeholder="e.g., 01/01/2025"
                            keyboardType='default' 
                        />
                        <SingleTextField
                            label="Officiating Priest"
                            text={form.priest}
                            onChangeText={(text) => handleChange('priest', text)}
                            placeholder="e.g., Fr. John Bosco"
                        />
                    </View>
                );
            case 2:
                return (
                    <View>
                        <SingleTextField
                            label="Total Offerings (XAF)"
                            text={form.totalOfferings}
                            onChangeText={(text) => handleChange('totalOfferings', text.replace(/[^0-9.]/g, ''))} 
                            placeholder="e.g., 57500.00"
                            keyboardType='numeric'
                        />
                        <SingleTextField
                            label="Attendance - Men"
                            text={form.menAttendance}
                            onChangeText={(text) => handleChange('menAttendance', text.replace(/[^0-9]/g, ''))} 
                            placeholder="e.g., 15"
                            keyboardType='numeric'
                        />
                        <SingleTextField
                            label="Attendance - Women"
                            text={form.womenAttendance}
                            onChangeText={(text) => handleChange('womenAttendance', text.replace(/[^0-9]/g, ''))} 
                            placeholder="e.g., 25"
                            keyboardType='numeric'
                        />
                    </View>
                );
            case 3:
                return (
                    <View>
                        <SingleTextField
                            label="Description / Notes"
                            text={form.description}
                            onChangeText={(text) => handleChange('description', text)}
                            placeholder="Notes about the meeting, discussions, etc."
                            multiline={true} 
                            numberOfLines={5}
                        />
                    </View>
                );
            default:
                return null;
        }
    };

    return (
        <KeyboardAvoidingView 
            style={{ flex: 1 }} 
            behavior={Platform.OS === "ios" ? "padding" : "height"}
            keyboardVerticalOffset={Platform.OS === "ios" ? 100 : 0}
        >
            <Stack.Screen options={{ title: `Add New SCC Record (Step ${currentStep} of ${TOTAL_STEPS})` }} />
            <ScrollView 
                className="flex-1 bg-white px-4"
                contentContainerStyle={styles.scrollContainer}
            >
                <View style={styles.contentContainer}>
                    
                    {/* Render Content for Current Step */}
                    {renderStepContent()}

                    {/* Navigation Buttons */}
                    <View style={styles.buttonContainer}>
                        {/* Previous Button - Not visible on Step 1 */}
                        {currentStep > 1 && (
                            <CustomButton
                                title="Previous"
                                onPress={handlePrevious}
                                className='flex-1 mr-2 bg-gray-400'
                            />
                        )}

                        {/* Next Button - Visible on Step 1 and 2 */}
                        {currentStep < TOTAL_STEPS && (
                            <CustomButton
                                title="Next"
                                onPress={handleNext}
                                className='flex-1 ml-2'
                            />
                        )}

                        {/* Submit Button - Only visible on the last step */}
                        {currentStep === TOTAL_STEPS && (
                            <CustomButton
                                title="Add Record"
                                onPress={handleSubmit}
                                isLoading={isSubmitting}
                                className='flex-1' 
                            />
                        )}
                    </View>
                </View>
            </ScrollView>
        </KeyboardAvoidingView>
    );
}

const styles = StyleSheet.create({
    scrollContainer: {
        paddingVertical: 16,
    },
    contentContainer: {
        flex: 1,
        justifyContent: 'space-between', // Push buttons to the bottom if content is short
    },
    buttonContainer: {
        flexDirection: 'row',
        marginTop: 20, // Space above buttons
        marginBottom: 8, // Space at the bottom
    }
});