// fileName: addRecord.tsx

import React, { useState, useRef } from 'react';
import { 
    View, 
    ScrollView, 
    Alert, 
    KeyboardAvoidingView, 
    Platform, 
    Text,
    Image, 
    TouchableOpacity,
    StyleSheet,
    TextInput
} from "react-native";
import { Stack, useRouter } from 'expo-router';
// --- FORMIK AND YUP IMPORTS ---
import { useFormik } from 'formik'; 
import * as yup from 'yup';
// --- DATE PICKER IMPORTS ---
import DateTimePicker, { DateTimePickerEvent } from '@react-native-community/datetimepicker'; 
import { MaterialIcons } from '@expo/vector-icons'; 
// --- COMPONENT IMPORTS ---
import SingleTextField from '@/components/Common/SingleTextField'; 
import CustomButton from '@/components/Common/CustomButton'; 
import * as ImagePicker from 'expo-image-picker'; 
import { formatDateToISO } from '@/lib/formatDateToISO';
import { useCreateSCCRecordMutation } from '@/services/SCC/mutations';
import { sccRecordReturnType } from '@/types/sccTypes';

// --- CONSTANTS ---
const TOTAL_STEPS = 3; 

// Image URI type
type ImageUri = {
    uri: string;
};

// Initial state for the form
const initialFormValues = {
    sccName: '',
    faithSharingName: '', 
    host: '',             
    date: '', // The date string will be YYYY-MM-DD
    officiatingPriestName: '', 
    menAttendance: '',      
    womenAttendance: '',    
    youthAttendance: '',    
    catechumenAttendance: '',         
    wordOfLife: '',      
    totalOfferings: '',     
    task: '',             
    nextHost: '', 
            
};

type FormValues = typeof initialFormValues;

// Validation Schema using Yup (Unchanged, but crucial for date input)
const validationSchema = [
    // Step 1 Schema: Details
    yup.object({
        sccName: yup.string().required("SCC Name is required."),
        faithSharingName: yup.string().required("Faith Sharing Name is required."),
        // **Crucial:** Allows manual input validation for YYYY-MM-DD
        date: yup.string().required("Date is required.").matches(
            /^\d{4}-\d{2}-\d{2}$/, 
            "Date must be in YYYY-MM-DD format (e.g., 2025-12-31)."
        ), 
        officiatingPriest: yup.string().required("Officiating Priest/Facilitator is required."),
        host: yup.string().required("Host is required."),
    }),
    
    // Step 2 and 3 Schemas (Omitted for brevity, unchanged)
    yup.object({
        totalOfferings: yup
            .string()
            .required("Total Offerings is required.")
            .matches(/^[0-9]+(\.[0-9]{1,2})?$/, "Invalid currency format (e.g., 57500 or 57500.00)."), 
        // These fields are already set to validate as numbers in the schema.
        menAttendance: yup.string().matches(/^[0-9]*$/, "Must be a number.").nullable(),
        womenAttendance: yup.string().matches(/^[0-9]*$/, "Must be a number.").nullable(),
        youthAttendance: yup.string().matches(/^[0-9]*$/, "Must be a number.").nullable(),
        catechumen: yup.string().matches(/^[0-9]*$/, "Must be a number.").nullable(),
    }),
    
    yup.object({
        wordOfLife: yup.string().required("Word of Life is required.").min(10, "Word of Life should be descriptive (min 10 characters)."), 
        task: yup.string().required("Task/Outcome is required."),
        nextHost: yup.string().required("Next Host is required."),
    }),
];


// Helper to format Date object to YYYY-MM-DD string

export default function AddRecord() {
    const [currentStep, setCurrentStep] = useState(1); 
    const [selectedImages, setSelectedImages] = useState<ImageUri[]>([]); 
    const [showDatePicker, setShowDatePicker] = useState(false); 
    const scrollViewRef = useRef<ScrollView>(null);
    const router = useRouter();

    const addRecordMutation = useCreateSCCRecordMutation();
    
    const formik = useFormik<FormValues>({
        initialValues: initialFormValues,
        validationSchema: yup.object().shape(validationSchema.reduce((acc, schema) => ({ ...acc, ...schema.fields }), {})),
        onSubmit: handleSubmit,
    });
    
    const { 
        values, 
        handleChange, 
        handleBlur, 
        errors, 
        touched, 
        isSubmitting, 
        setFieldValue, 
        setFieldTouched, 
        setTouched
    } = formik;


    // Handler for the final submit button (Omitted for brevity, unchanged)
    async function handleSubmit(values: FormValues) {
        
        addRecordMutation.mutate({
            sccName: values.sccName,
            faithSharingName: values.faithSharingName,
            host: values.host,
            date: values.date,
            officiatingPriestName: values.officiatingPriestName,
            menAttendance: parseInt(values.menAttendance),
            womenAttendance: parseInt(values.womenAttendance),
            youthAttendance: parseInt(values.youthAttendance),
            catechumenAttendance: parseInt(values.catechumenAttendance),
            wordOfLife: values.wordOfLife,
            totalOfferings: parseInt(values.totalOfferings),
            task: values.task,
            nextHost: values.nextHost
        }, {
            onSuccess: (data: sccRecordReturnType) => {
                if(data.success) {
                    router.push("/(scc)");
                }
            }
        })
    };

    // Date Picker Handlers
    const handleDateChange = (event: DateTimePickerEvent, selectedDate?: Date) => {
        
        if (Platform.OS === 'android') {
            setShowDatePicker(false);
        }

        if (event.type === 'set' && selectedDate) {
            const formattedDate = formatDateToISO(selectedDate);
            setFieldValue('date', formattedDate);
            setFieldTouched('date', true);
        } 
        
        if (Platform.OS === 'ios' && event.type !== 'set') {
             setShowDatePicker(false);
        }
    };

    // Helper to determine the date object for the picker value (Unchanged)
    const getCurrentDate = (dateValue: string): Date => {
         // ... date logic ...
         if (!dateValue) return new Date();
         return new Date(`${dateValue}T00:00:00.000Z`);
    };
    
    // --- Image Selection Logic (Omitted for brevity) ---
    // ...

    // Function to render the fields for the current step
    const renderStepContent = () => {
        // MODIFIED: Correctly strip non-digit characters for integers, and non-digit/non-decimal for currency
        const handleNumericChange = (field: keyof FormValues, text: string, isDecimal: boolean = false) => {
            const cleanText = isDecimal ? text.replace(/[^0-9.]/g, '') : text.replace(/[^0-9]/g, '');
            handleChange(field)(cleanText);
        };

        const hasError = (field: keyof FormValues) => touched[field] && errors[field];


        switch (currentStep) {
            case 1:
                return (
                    <View className="p-4">
                        <Text className='font-[Roboto-Mono] text-xl font-bold text-center' style={{ height: 40 }}>
                            ADD SCC RECORD 🔑
                        </Text>
                        <SingleTextField
                            label="SCC Name"
                            placeholder="e.g., St. Francis Xavier SCC"
                            value={values.sccName} // Corrected from text to value
                            onChangeText={handleChange('sccName')}
                            onBlur={handleBlur('sccName')}
                            error={hasError('sccName')} // Added error prop
                            keyboardType="default"
                            returnKeyType="next"
                        />
                         {/* Faith Sharing Name */}
                        <SingleTextField
                            label="Faith Sharing Name"
                            placeholder="e.g., St. Jude"
                            value={values.faithSharingName} // Corrected from text to value
                            onChangeText={handleChange('faithSharingName')}
                            onBlur={handleBlur('faithSharingName')}
                            error={hasError('faithSharingName')} // Added error prop
                            keyboardType="default"
                            returnKeyType="next"
                        />
                        {/* DATE INPUT & PICKER IMPLEMENTATION */}
                        <View style={styles.datePickerContainer}>
                            <Text style={styles.label}>Date of Gathering <Text className="text-red-500">*</Text></Text>
                            
                            <View style={[styles.dateInputWrapper, hasError('date') && styles.dateInputError]}>
                                {/* TextInput for manual entry */}
                                <TextInput
                                    style={styles.dateTextInput}
                                    placeholder="YYYY-MM-DD (e.g., 2025-12-31)"
                                    placeholderTextColor="#6B7280"
                                    value={values.date}
                                    onChangeText={handleChange('date')}
                                    onBlur={handleBlur('date')}
                                    keyboardType={Platform.OS === 'ios' ? 'numbers-and-punctuation' : 'default'}
                                    returnKeyType="done"
                                />

                                {/* Icon to trigger the Date Picker */}
                                <TouchableOpacity 
                                    onPress={() => {
                                        setShowDatePicker(true);
                                        setFieldTouched('date', true); // Mark as touched on open
                                    }}
                                    activeOpacity={0.8}
                                    style={styles.dateIcon}
                                >
                                    <MaterialIcons name="event" size={24} color="#6B7280" />
                                </TouchableOpacity>
                            </View>

                             {hasError('date') && (
                                <Text style={styles.errorText}>
                                    {errors.date}
                                </Text>
                            )}

                            {(showDatePicker || Platform.OS === 'ios') && (
                                <DateTimePicker
                                    testID="dateTimePicker"
                                    value={getCurrentDate(values.date)}
                                    mode="date"
                                    display={Platform.OS === 'ios' ? 'spinner' : 'default'} 
                                    onChange={handleDateChange} 
                                />
                            )}
                        </View>
                        {/* END DATE INPUT & PICKER IMPLEMENTATION */}

                        {/* Officiating Priest */}
                        <SingleTextField
                            label="Officiating Priest/Facilitator"
                            placeholder="e.g., Fr. Peter John"
                            value={values.officiatingPriestName}
                            onChangeText={handleChange('officiatingPriestName')}
                            onBlur={handleBlur('officiatingPriestName')}
                            error={hasError('officiatingPriestName')}
                            keyboardType="default"
                            returnKeyType="next"
                        />
                        
                        {/* Host */}
                        <SingleTextField
                            label="Host"
                            placeholder="Name of the person/family that hosted the gathering"
                            value={values.host}
                            onChangeText={handleChange('host')}
                            onBlur={handleBlur('host')}
                            error={hasError('host')}
                            keyboardType="default"
                            returnKeyType="done"
                        />
                    </View>
                );

            case 2:
                // Attendance & Financials 
                return (
                    // ... attendance fields ...
                    <View className="p-4">
                        {/* Men Attendance */}
                        <SingleTextField
                            label="Men Attendance"
                            placeholder="Enter number of men"
                            value={values.menAttendance}
                            onChangeText={(text) => handleNumericChange('menAttendance', text)} 
                            onBlur={handleBlur('menAttendance')}
                            error={hasError('menAttendance')}
                            keyboardType="number-pad"
                            returnKeyType="next"
                        />
                        {/* Women Attendance */}
                        <SingleTextField
                            label="Women Attendance"
                            placeholder="Enter number of women"
                            value={values.womenAttendance}
                             // Only allow integers (no decimal)
                            onChangeText={(text) => handleNumericChange('womenAttendance', text)}
                            onBlur={handleBlur('womenAttendance')}
                            error={hasError('womenAttendance')}
                            keyboardType="numeric"
                            returnKeyType="next"
                        />
                        {/* Youth Attendance */}
                        <SingleTextField
                            label="Youth Attendance"
                            placeholder="Enter number of youth"
                            value={values.youthAttendance}
                             // Only allow integers (no decimal)
                            onChangeText={(text) => handleNumericChange('youthAttendance', text)}
                            onBlur={handleBlur('youthAttendance')}
                            error={hasError('youthAttendance')}
                            keyboardType="numeric"
                            returnKeyType="next"
                        />
                        {/* Catechumen Attendance (New Field) */}
                        <SingleTextField
                            label="Catechumen Attendance"
                            placeholder="Enter number of Catechumens"
                            value={values.catechumenAttendance}
                             // Only allow integers (no decimal)
                            onChangeText={(text) => handleNumericChange('catechumenAttendance', text)}
                            onBlur={handleBlur('catechumen')}
                            error={hasError('catechumenAttendance')}
                            keyboardType="numeric"
                            returnKeyType="next"
                        />
                        {/* Total Offerings */}
                        <SingleTextField
                            label="Total Offerings (e.g., 500) "
                            placeholder="Total amount collected"
                            value={values.totalOfferings}
                            // Allow decimal for currency
                            onChangeText={(text) => handleNumericChange('totalOfferings', text, true)} 
                            onBlur={handleBlur('totalOfferings')}
                            error={hasError('totalOfferings')}
                            keyboardType="numeric"
                            returnKeyType="done"
                        />
                    </View>
                );

            case 3:
                // Outcomes & Next Steps (Omitted for brevity)
                return (
                    // ... outcome fields ...
                    <View className="p-4">
                        {/* Word of Life */}
                        <SingleTextField
                            label="Word of Life/Theme Verse"
                            placeholder="Enter the main Word of Life or theme of the gathering"
                            value={values.wordOfLife}
                            onChangeText={handleChange('wordOfLife')}
                            onBlur={handleBlur('wordOfLife')}
                            error={hasError('wordOfLife')}
                            keyboardType="default"
                            multiline={true}
                            numberOfLines={2}
                            returnKeyType="next"
                        />
                        
                        {/* Task (New Field) */}
                        <SingleTextField
                            label="Task/Outcome"
                            placeholder="What was the main action/task decided?"
                            value={values.task}
                            onChangeText={handleChange('task')}
                            onBlur={handleBlur('task')}
                            error={hasError('task')}
                            keyboardType="default"
                            multiline={true}
                            numberOfLines={2}
                            returnKeyType="next"
                        />
                        
                        {/* Next Host (New Field) */}
                        <SingleTextField
                            label="Next Host"
                            placeholder="Name of the person/family hosting the next gathering"
                            value={values.nextHost}
                            onChangeText={handleChange('nextHost')}
                            onBlur={handleBlur('nextHost')}
                            error={hasError('nextHost')}
                            keyboardType="default"
                            returnKeyType="done"
                        />

                        {/* Image Picker Section */}
                        <Text style={styles.label}>Upload Photos (Optional)</Text>
                        <CustomButton 
                            title="Select Images" 
                            onPress={() => { /* pickImage logic */ }} 
                            className='bg-orange-500 mb-4'
                        />

                        {/* Image Preview */}
                        {/* ... preview logic ... */}
                    </View>
                );

            default:
                return null;
        }
    };


    // MODIFIED: Correctly set touched state for all fields in the current schema on validation failure
    const handleNext = async () => {
        const stepSchema = validationSchema[currentStep - 1];
        
        try {
            // Validate the current step's subset of values against its schema
            await stepSchema.validate(values, { abortEarly: false });
            
            if (currentStep < TOTAL_STEPS) {
                setCurrentStep(prev => prev + 1);
                scrollViewRef.current?.scrollTo({ y: 0, animated: true });
            }
        } catch (err: any) {
            Alert.alert("Validation Error", "Please correct the errors on this page before continuing.");
            
            // This is the fix: create a new touched object with all error fields marked true
            const newTouched: { [key: string]: boolean } = {};
            if (err.inner) { // Yup validation error structure
                err.inner.forEach((error: any) => { 
                    if (error.path) {
                        newTouched[error.path] = true;
                    }
                });
            } else if (err.fields) { // Fallback for older Yup error structure
                Object.keys(err.fields).forEach(key => { 
                    newTouched[key] = true;
                });
            }
            
            // Merge with existing touched state to preserve previously touched fields
            setTouched({ ...touched, ...newTouched }); 
        }
    };

    const handleBack = () => {
        if (currentStep > 1) {
            setCurrentStep(prev => prev - 1);
            scrollViewRef.current?.scrollTo({ y: 0, animated: true });
        }
    }


    // The main component render (Unchanged)
    return (
        <KeyboardAvoidingView 
            style={{ flex: 1 }} 
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
            keyboardVerticalOffset={Platform.OS === "ios" ? 100 : 0}
        >
            <Stack.Screen options={{ title: `Add New SCC Record (Step ${currentStep} of ${TOTAL_STEPS})` }} />
            
            <ScrollView 
                ref={scrollViewRef}
                className="flex-1 bg-white"
                keyboardShouldPersistTaps="handled"
            >
                {renderStepContent()} 
                
                {/* Navigation Buttons */}
                <View className="p-4 pt-0">
                    <View className="flex-row justify-between mt-4">
                        {currentStep > 1 && (
                            <CustomButton title="Back" onPress={handleBack} className='flex-1 mr-2 bg-gray-400'/>
                        )}
                        {currentStep < TOTAL_STEPS && (
                            <CustomButton
                                title="Next"
                                onPress={handleNext} 
                                className={`flex-1 ${currentStep === 1 ? 'ml-0' : 'ml-2'} bg-blue-500`}
                                isLoading={isSubmitting} 
                            />
                        )}
                        {currentStep === TOTAL_STEPS && (
                            <CustomButton
                                title="Add Record"
                                onPress={handleSubmit} 
                                isLoading={addRecordMutation.isPending} 
                                className='flex-1 bg-green-500' 
                            />
                        )}
                    </View>
                </View>
            </ScrollView>
        </KeyboardAvoidingView>
    );
}

// Keeping a minimal StyleSheet for fixed dimensions for the image preview and new Date Picker styles
const styles = StyleSheet.create({
    imagePreview: {
        width: 100, 
        height: 100,
    },
    // NEW STYLES for Date Picker
    datePickerContainer: {
        marginBottom: 16,
    },
    label: {
        fontSize: 16,
        color: '#1F2937', 
        marginBottom: 8,
        fontWeight: '500',
    },
    // The wrapper style is the new boundary/border for the combined input/icon
    dateInputWrapper: { 
        flexDirection: 'row',
        alignItems: 'center',
        borderRadius: 8,
        borderColor: '#D1D5DB', // light gray
        borderWidth: 1,
        backgroundColor: '#F9FAFB', // very light gray
        paddingHorizontal: 8, // Adjust padding
    },
    dateTextInput: { // Style for the text input itself
        flex: 1, // Takes up most of the space
        fontSize: 16,
        color: '#1F2937',
        paddingVertical: 12,
        paddingHorizontal: 8, // Remove the horizontal padding handled by the wrapper
    },
    dateIcon: {
        padding: 8, // Padding around the icon for easy tapping
    },
    dateInputError: {
        borderColor: '#EF4444', // red
    },
    errorText: {
        fontSize: 12,
        color: '#EF4444', 
        marginTop: 4,
    },
});