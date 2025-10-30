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
import * as FileSystem from 'expo-file-system';
import * as MediaLibrary from 'expo-media-library';
import { formatDateToISO } from '@/lib/formatDateToISO';
import { useCreateSCCRecordMutation } from '@/services/SCC/mutations';
import { sccRecordReturnType } from '@/types/sccTypes';

// --- CONSTANTS ---
const TOTAL_STEPS = 3; 
const MAX_IMAGES = 5;

// Image URI type for selected files
type ImageUri = {
    uri: string;
    mimeType?: string;
};

// Initial state for the form
const initialFormValues = {
    sccName: '',
    faithSharingName: '', 
    host: '',             
    date: '',
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

// Validation Schema using Yup
const validationSchema = [
    // Step 1 Validation
    yup.object({ 
        sccName: yup.string().required("SCC Name is required"),
        faithSharingName: yup.string().required("Faith sharing Name is required"),
        host: yup.string().required("Host name is required"),
        date: yup.string().required("Date is required"),
        officiatingPriestName: yup.string().required("Officiating Priest is required"),
    }),
    // Step 2 Validation
    yup.object({
        menAttendance: yup.number().integer().min(0).nullable().transform((value, originalValue) => originalValue === '' ? null : value),
        womenAttendance: yup.number().integer().min(0).nullable().transform((value, originalValue) => originalValue === '' ? null : value),
        youthAttendance: yup.number().integer().min(0).nullable().transform((value, originalValue) => originalValue === '' ? null : value),
        catechumenAttendance: yup.number().integer().min(0).nullable().transform((value, originalValue) => originalValue === '' ? null : value),
    }),
    // Step 3 Validation
    yup.object({
        wordOfLife: yup.string().required("Word of Life is required"),
        totalOfferings: yup.number().min(0).nullable().transform((value, originalValue) => originalValue === '' ? null : value),
        task: yup.string().required("Task is required"),
        nextHost: yup.string().required("Next Host is required"),
    })
];

export default function AddRecord() {
    const [currentStep, setCurrentStep] = useState(1); 
    const [selectedImages, setSelectedImages] = useState<ImageUri[]>([]); 
    const [showDatePicker, setShowDatePicker] = useState(false); 
    const scrollViewRef = useRef<ScrollView>(null);
    const router = useRouter();

    const addRecordMutation = useCreateSCCRecordMutation();
    
    // --- FIXED: Image Selection and Permission Logic ---
    const verifyMediaPermissions = async () => {
        try {
            const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();
            if (status !== 'granted') {
                Alert.alert(
                    "Permission Required", 
                    "We need media library permissions to select photos for the record.",
                    [{ text: "OK" }]
                );
                return false;
            }
            return true;
        } catch (error) {
            console.error("Permission error:", error);
            Alert.alert("Error", "Failed to request permissions");
            return false;
        }
    };

    const pickImage = async () => {
        if (!(await verifyMediaPermissions())) return;

        if (selectedImages.length >= MAX_IMAGES) {
            Alert.alert("Limit Reached", `You can upload a maximum of ${MAX_IMAGES} images per record.`);
            return;
        }

        try {
            const result = await ImagePicker.launchImageLibraryAsync({
                mediaTypes: ImagePicker.MediaTypeOptions.Images,
                allowsMultipleSelection: true,
                selectionLimit: MAX_IMAGES - selectedImages.length,
                quality: 0.7,
            });

            if (!result.canceled && result.assets) {
                const newImages: ImageUri[] = result.assets.map(asset => ({
                    uri: asset.uri,
                    mimeType: asset.mimeType || 'image/jpeg', 
                }));
                setSelectedImages(prev => [...prev, ...newImages]);
            }
        } catch (error) {
            console.error("Image picker error:", error);
            Alert.alert("Error", "Failed to select images. Please try again.");
        }
    };

    const removeImage = (uri: string) => {
        setSelectedImages(prev => prev.filter(img => img.uri !== uri));
    };

    // --- FIXED: PDF Saving Logic with proper error handling ---
    const savePdfToDocuments = async (pdfUri: string, fileName: string) => {
        try {
            let destinationUri: string;
            
            if (Platform.OS === 'android') {
                // Request Storage Access Framework permissions on Android
                const permissions = await FileSystem.StorageAccessFramework.requestDirectoryPermissionsAsync();

                if (!permissions.granted) {
                    Alert.alert("Permission Denied", "Cannot save file without access to storage.");
                    return;
                }
                
                // Create a file in the user's selected directory
                const newFileUri = await FileSystem.StorageAccessFramework.createFileAsync(
                    permissions.directoryUri,
                    fileName,
                    'application/pdf'
                );

                destinationUri = newFileUri;

                // Check if source file exists
                const fileInfo = await FileSystem.getInfoAsync(pdfUri);
                if (!fileInfo.exists) {
                    Alert.alert("Error", "Source PDF file not found");
                    return;
                }

                // Copy the file content
                const content = await FileSystem.readAsStringAsync(pdfUri, {
                    encoding: FileSystem.EncodingType.Base64
                });
                
                await FileSystem.StorageAccessFramework.writeAsStringAsync(
                    destinationUri,
                    content,
                    { encoding: FileSystem.EncodingType.Base64 }
                );
                
            } else if (Platform.OS === 'ios') {
                // On iOS, save to document directory (accessible via Files app)
                destinationUri = FileSystem.documentDirectory + fileName;
                
                const fileInfo = await FileSystem.getInfoAsync(pdfUri);
                if (!fileInfo.exists) {
                    Alert.alert("Error", "Source PDF file not found");
                    return;
                }
                
                await FileSystem.copyAsync({ from: pdfUri, to: destinationUri });
            } else {
                // Default for other platforms
                destinationUri = FileSystem.documentDirectory + fileName;
                await FileSystem.copyAsync({ from: pdfUri, to: destinationUri });
            }

            Alert.alert("PDF Saved", `The PDF was saved successfully!`);

        } catch (error: any) {
            console.error("Error saving PDF:", error);
            Alert.alert("Error", `Could not save the PDF file. ${error.message || 'Please try again.'}`);
        }
    };

    // Handler for the final submit button
    async function handleSubmit(values: FormValues) {
        const safeParseInt = (value: string): number | undefined => {
            if (!value || value.trim() === '') return undefined;
            const parsed = parseInt(value, 10);
            return isNaN(parsed) ? undefined : parsed;
        };
        
        const safeParseFloat = (value: string): number | undefined => {
            if (!value || value.trim() === '') return undefined;
            const parsed = parseFloat(value);
            return isNaN(parsed) ? undefined : parsed;
        }
        
        // Create FormData for multipart upload
        const formData = new FormData();
        
        // Append all form values
        formData.append('sccName', values.sccName);
        formData.append('faithSharingName', values.faithSharingName);
        formData.append('host', values.host);
        formData.append('date', values.date);
        formData.append('officiatingPriestName', values.officiatingPriestName);
        
        // Append optional numeric fields
        const menAttendance = safeParseInt(values.menAttendance);
        if (menAttendance !== undefined) formData.append('menAttendance', menAttendance.toString());
        
        const womenAttendance = safeParseInt(values.womenAttendance);
        if (womenAttendance !== undefined) formData.append('womenAttendance', womenAttendance.toString());
        
        const youthAttendance = safeParseInt(values.youthAttendance);
        if (youthAttendance !== undefined) formData.append('youthAttendance', youthAttendance.toString());

        const catechumenAttendance = safeParseInt(values.catechumenAttendance);
        if (catechumenAttendance !== undefined) formData.append('catechumenAttendance', catechumenAttendance.toString());

        formData.append('wordOfLife', values.wordOfLife);

        const totalOfferings = safeParseFloat(values.totalOfferings);
        if (totalOfferings !== undefined) formData.append('totalOfferings', totalOfferings.toString());

        formData.append('task', values.task);
        formData.append('nextHost', values.nextHost);

        // Append selected images to FormData
        selectedImages.forEach((image, index) => {
            const fileName = image.uri.split('/').pop() || `image-${index}.jpg`; 
            
            formData.append('images', {
                uri: image.uri,
                type: image.mimeType || 'image/jpeg', 
                name: fileName,
            } as any);
        });

        // Use the FormData object in the mutation
        await addRecordMutation.mutate(formData as any, { 
            onSuccess: (data: sccRecordReturnType) => {
                if(data.success) {
                    router.push("/(scc)");
                }
            }
        });
    }

    const formik = useFormik<FormValues>({
        initialValues: initialFormValues,
        validationSchema: validationSchema[currentStep - 1],
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

    // Handler for Date Picker
    const onDateChange = (event: DateTimePickerEvent, selectedDate: Date | undefined) => {
        setShowDatePicker(Platform.OS === 'ios');
        if (selectedDate) {
            setFieldValue('date', formatDateToISO(selectedDate));
            setFieldTouched('date', true, false);
        }
    };

    const getCurrentDate = (): Date => {
        const dateString = values.date || new Date().toISOString().split('T')[0];
        return new Date(dateString);
    };

    const handleNext = async () => {
        // Validate current step fields
        await setTouched(
            Object.keys(validationSchema[currentStep - 1].fields).reduce((acc, key) => ({ ...acc, [key]: true }), {}),
            true
        );

        try {
            await validationSchema[currentStep - 1].validate(values, { abortEarly: false });
            
            if (currentStep < TOTAL_STEPS) {
                setCurrentStep(currentStep + 1);
                scrollViewRef.current?.scrollTo({ x: 0, y: 0, animated: true });
            }
        } catch (error: any) {
            console.log("Validation failed on step", currentStep, error.errors);
        }
    };

    const handleBack = () => {
        if (currentStep > 1) {
            setCurrentStep(currentStep - 1);
            scrollViewRef.current?.scrollTo({ x: 0, y: 0, animated: true });
        }
    }

    // Function to render the fields for the current step
    const renderStepContent = () => {
        const handleNumericChange = (field: keyof FormValues, text: string, isDecimal: boolean = false) => {
            const cleanText = isDecimal ? text.replace(/[^0-9.]/g, '') : text.replace(/[^0-9]/g, '');
            handleChange(field)(cleanText);
        };

        const hasError = (field: keyof FormValues) => touched[field] && errors[field];

        switch (currentStep) {
            case 1:
                return (
                    <View className="p-4">
                        <SingleTextField
                            label="SCC Name"
                            placeholder="Enter the SCC's official name"
                            value={values.sccName}
                            onChangeText={handleChange('sccName')}
                            onBlur={handleBlur('sccName')}
                            error={hasError('sccName')}
                        />
                        <SingleTextField
                            label="Faith Sharing Name"
                            placeholder="Enter the name of the meeting/sharing"
                            value={values.faithSharingName}
                            onChangeText={handleChange('faithSharingName')}
                            onBlur={handleBlur('faithSharingName')}
                            error={hasError('faithSharingName')}
                        />
                        <SingleTextField
                            label="Host"
                            placeholder="Name of the Host"
                            value={values.host}
                            onChangeText={handleChange('host')}
                            onBlur={handleBlur('host')}
                            error={hasError('host')}
                        />
                        
                        <View style={styles.datePickerContainer}>
                            <Text style={styles.label}>Date</Text>
                            <TouchableOpacity onPress={() => setShowDatePicker(true)} style={[styles.dateInputWrapper, hasError('date') && styles.dateInputError]}>
                                <TextInput
                                    style={styles.dateTextInput}
                                    value={values.date}
                                    placeholder="Select Date (YYYY-MM-DD)"
                                    editable={false}
                                />
                                <MaterialIcons name="calendar-today" size={24} color="#6B7280" style={styles.dateIcon} />
                            </TouchableOpacity>
                            {hasError('date') && <Text style={styles.errorText}>{errors.date}</Text>}
                            {showDatePicker && (
                                <DateTimePicker
                                    value={getCurrentDate()}
                                    mode="date"
                                    display="default"
                                    onChange={onDateChange}
                                    maximumDate={new Date()}
                                />
                            )}
                        </View>

                        <SingleTextField
                            label="Officiating Priest Name"
                            placeholder="Enter the name of the priest"
                            value={values.officiatingPriestName}
                            onChangeText={handleChange('officiatingPriestName')}
                            onBlur={handleBlur('officiatingPriestName')}
                            error={hasError('officiatingPriestName')}
                            returnKeyType="next"
                        />
                    </View>
                );

            case 2:
                return (
                    <View className="p-4">
                        <Text className="text-xl font-bold mb-4 text-gray-800">Attendance</Text>
                        <SingleTextField
                            label="Men Attendance"
                            placeholder="Enter number of men"
                            value={values.menAttendance}
                            onChangeText={(text) => handleNumericChange('menAttendance', text)}
                            onBlur={handleBlur('menAttendance')}
                            error={hasError('menAttendance')}
                            keyboardType="numeric"
                        />
                        <SingleTextField
                            label="Women Attendance"
                            placeholder="Enter number of women"
                            value={values.womenAttendance}
                            onChangeText={(text) => handleNumericChange('womenAttendance', text)}
                            onBlur={handleBlur('womenAttendance')}
                            error={hasError('womenAttendance')}
                            keyboardType="numeric"
                        />
                        <SingleTextField
                            label="Youth Attendance"
                            placeholder="Enter number of youth"
                            value={values.youthAttendance}
                            onChangeText={(text) => handleNumericChange('youthAttendance', text)}
                            onBlur={handleBlur('youthAttendance')}
                            error={hasError('youthAttendance')}
                            keyboardType="numeric"
                        />
                        <SingleTextField
                            label="Catechumen Attendance"
                            placeholder="Enter number of catechumen"
                            value={values.catechumenAttendance}
                            onChangeText={(text) => handleNumericChange('catechumenAttendance', text)}
                            onBlur={handleBlur('catechumenAttendance')}
                            error={hasError('catechumenAttendance')}
                            keyboardType="numeric"
                        />
                        
                        <SingleTextField
                            label="Total Offerings"
                            placeholder="Enter total offerings amount (e.g., 50.00)"
                            value={values.totalOfferings}
                            onChangeText={(text) => handleNumericChange('totalOfferings', text, true)}
                            onBlur={handleBlur('totalOfferings')}
                            error={hasError('totalOfferings')}
                            keyboardType="numeric"
                        />
                    </View>
                );

            case 3:
                return (
                    <View className="p-4">
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

                        <Text style={styles.label}>Upload Photos (Optional) ({selectedImages.length}/{MAX_IMAGES})</Text>
                        <CustomButton 
                            title="Select Images" 
                            onPress={pickImage}
                            className='bg-orange-500 mb-4'
                        />

                        {/* Image Preview Area */}
                        {selectedImages.length > 0 && (
                            <View className="flex-row flex-wrap mb-4">
                                {selectedImages.map((image) => (
                                    <View key={image.uri} style={styles.imagePreviewContainer}>
                                        <Image source={{ uri: image.uri }} style={styles.imagePreview} />
                                        <TouchableOpacity 
                                            onPress={() => removeImage(image.uri)} 
                                            style={styles.removeImageButton}
                                        >
                                            <MaterialIcons name="cancel" size={24} color="#EF4444" />
                                        </TouchableOpacity>
                                    </View>
                                ))}
                            </View>
                        )}
                    </View>
                );

            default:
                return null;
        }
    };

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
                                onPress={formik.handleSubmit}
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

const styles = StyleSheet.create({
    label: {
        fontSize: 16,
        color: '#1F2937', 
        marginBottom: 8,
        fontWeight: '500',
    },
    imagePreviewContainer: {
        position: 'relative',
        marginRight: 8,
        marginBottom: 8,
    },
    imagePreview: {
        width: 80, 
        height: 80,
        borderRadius: 8,
    },
    removeImageButton: {
        position: 'absolute',
        top: -5,
        right: -5,
        backgroundColor: 'white',
        borderRadius: 12,
        padding: 1,
    },
    errorText: {
        fontSize: 12,
        color: '#EF4444',
        marginTop: 4,
    },
    datePickerContainer: {
        marginBottom: 16,
    },
    dateInputWrapper: { 
        flexDirection: 'row',
        alignItems: 'center',
        borderRadius: 8,
        borderColor: '#D1D5DB',
        borderWidth: 1,
        backgroundColor: '#F9FAFB',
        paddingHorizontal: 8,
    },
    dateTextInput: {
        flex: 1,
        fontSize: 16,
        color: '#1F2937',
        paddingVertical: 12,
        paddingHorizontal: 8,
    },
    dateIcon: {
        padding: 8,
    },
    dateInputError: {
        borderColor: '#EF4444',
    },
});