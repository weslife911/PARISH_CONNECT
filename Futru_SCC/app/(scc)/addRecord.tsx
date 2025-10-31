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
import { useFormik } from 'formik'; 
import * as yup from 'yup';
import DateTimePicker, { DateTimePickerEvent } from '@react-native-community/datetimepicker'; 
import { MaterialIcons } from '@expo/vector-icons'; 
import SingleTextField from '@/components/Common/SingleTextField'; 
import CustomButton from '@/components/Common/CustomButton'; 
import * as ImagePicker from 'expo-image-picker'; 
import { formatDateToISO } from '@/lib/formatDateToISO';
import { useCreateSCCRecordMutation } from '@/services/SCC/mutations';
import { sccRecordReturnType } from '@/types/sccTypes';

interface Base64Image {
    base64: string;
    mimeType: string;
}
type ImageType = Base64Image;

const TOTAL_STEPS = 3;
const MAX_IMAGES = 5;
// FIXED: Add image size limit (2MB per image)
const MAX_IMAGE_SIZE_MB = 2;

const initialFormValues = {
    sccName: '',
    faithSharingName: '', 
    host: '',             
    date: new Date().toISOString().split("T")[0],
    officiatingPriestName: '', 
    menAttendance: '',      
    womenAttendance: '',    
    youthAttendance: '',    
    catechumenAttendance: '',         
    wordOfLife: '',      
    totalOfferings: '',     
    task: '',             
    nextHost: '',
    images: [] as ImageType[],
};

type FormValues = typeof initialFormValues;

const validationSchema = [
    yup.object({
        sccName: yup.string().required("SCC Name is required."),
        faithSharingName: yup.string().required("Faith Sharing Name is required."),
        date: yup.string().required("Date is required.").matches(
            /^\d{4}-\d{2}-\d{2}$/, 
            "Date must be in YYYY-MM-DD format (e.g., 2025-12-31)."
        ), 
        officiatingPriestName: yup.string().required("Officiating Priest/Facilitator is required."),
        host: yup.string().required("Host is required."),
    }),
    
    yup.object({
        totalOfferings: yup
            .string()
            .required("Total Offerings is required.")
            .matches(/^[0-9]+(\.[0-9]{1,2})?$/, "Invalid currency format (e.g., 57500 or 57500.00)."), 
        menAttendance: yup.string().matches(/^[0-9]*$/, "Must be a number.").nullable(),
        womenAttendance: yup.string().matches(/^[0-9]*$/, "Must be a number.").nullable(),
        youthAttendance: yup.string().matches(/^[0-9]*$/, "Must be a number.").nullable(),
        catechumenAttendance: yup.string().matches(/^[0-9]*$/, "Must be a number.").nullable(),
    }),
    
    yup.object({
        wordOfLife: yup.string().required("Word of Life is required.").min(10, "Word of Life should be descriptive (min 10 characters)."), 
        task: yup.string().required("Task/Outcome is required."),
        nextHost: yup.string().required("Next Host is required."),
    }),
];

export default function AddRecord() {
    const [currentStep, setCurrentStep] = useState(1); 
    const [selectedImages, setSelectedImages] = useState<ImageType[]>([]); 
    const [showDatePicker, setShowDatePicker] = useState(false); 
    const scrollViewRef = useRef<ScrollView>(null);
    const router = useRouter();

    const addRecordMutation = useCreateSCCRecordMutation();

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

    // FIXED: Add image size validation
    const checkImageSize = (base64: string, mimeType: string): boolean => {
        const base64Length = base64.length;
        const sizeInBytes = (base64Length * 3) / 4;
        const sizeInMB = sizeInBytes / (1024 * 1024);
        return sizeInMB <= MAX_IMAGE_SIZE_MB;
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
                quality: 0.5, // FIXED: Reduced quality to 0.5 to reduce size
                base64: true,
            });

            if (!result.canceled && result.assets) {
                const validImages: ImageType[] = [];
                const invalidImages: string[] = [];

                for (const asset of result.assets) {
                    if (asset.base64) {
                        const isValidSize = checkImageSize(asset.base64, asset.mimeType || 'image/jpeg');
                        
                        if (isValidSize) {
                            validImages.push({
                                base64: asset.base64,
                                mimeType: asset.mimeType || 'image/jpeg',
                            });
                        } else {
                            invalidImages.push(asset.fileName || 'Unknown');
                        }
                    }
                }

                if (invalidImages.length > 0) {
                    Alert.alert(
                        "Images Too Large", 
                        `${invalidImages.length} image(s) exceeded ${MAX_IMAGE_SIZE_MB}MB and were not added.`
                    );
                }

                if (validImages.length > 0) {
                    setSelectedImages(prev => [...prev, ...validImages]);
                }
            }
        } catch (error) {
            console.error("Image picker error:", error);
            Alert.alert("Error", "Failed to select images. Please try again.");
        }
    };

    const removeImage = (base64: string) => {
        setSelectedImages(prev => prev.filter(img => img.base64 !== base64));
    };
    
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

        const submissionPayload: { [key: string]: any } = {
            sccName: values.sccName,
            faithSharingName: values.faithSharingName,
            host: values.host,
            date: values.date,
            officiatingPriestName: values.officiatingPriestName,
            wordOfLife: values.wordOfLife,
            task: values.task,
            nextHost: values.nextHost,
            
            menAttendance: safeParseInt(values.menAttendance),
            womenAttendance: safeParseInt(values.womenAttendance),
            youthAttendance: safeParseInt(values.youthAttendance),
            catechumenAttendance: safeParseInt(values.catechumenAttendance),

            totalOfferings: safeParseFloat(values.totalOfferings),

            images: selectedImages.map(image => ({
                base64: image.base64,
                mimeType: image.mimeType,
            })),
        };

        Object.keys(submissionPayload).forEach(key => 
            submissionPayload[key] === undefined && delete submissionPayload[key]
        );
        
        // FIXED: Better error handling
        try {
            await addRecordMutation.mutateAsync(submissionPayload as any, {
                onSuccess: (data: sccRecordReturnType) => {
                    if(data.success) {
                        router.push("/(scc)");
                    } else {
                        Alert.alert("Error", data.message || "Failed to create record");
                    }
                },
                onError: (error: any) => {
                    console.error("Submission error:", error);
                    const errorMessage = error?.response?.data?.message || error?.message || "Failed to create record";
                    Alert.alert("Submission Failed", errorMessage);
                }
            });
        } catch (error) {
            console.error("Submission error:", error);
        }
    }

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

    const handleDateChange = (event: DateTimePickerEvent, selectedDate?: Date) => {
        if (Platform.OS === 'android') {
            setShowDatePicker(false);
        }

        if (event.type === 'set' && selectedDate) {
            try {
                const formattedDate = formatDateToISO(selectedDate);
                setFieldValue('date', formattedDate);
                setFieldTouched('date', true);
            } catch (error) {
                console.error("Date formatting error:", error);
                Alert.alert("Error", "Failed to format date");
            }
        } 
        
        if (Platform.OS === 'ios' && event.type !== 'set') {
             setShowDatePicker(false);
        }
    };

    const getCurrentDate = (dateValue: string): Date => {
         if (!dateValue) return new Date();
         try {
             return new Date(`${dateValue}T00:00:00.000Z`);
         } catch (error) {
             console.error("Date parsing error:", error);
             return new Date();
         }
    };

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
                        <Text className='font-[Roboto-Mono] text-xl font-bold text-center' style={{ height: 40 }}>
                            ADD SCC RECORD 📝
                        </Text>
                        <SingleTextField
                            label="SCC Name"
                            placeholder="e.g., St. Francis Xavier SCC"
                            value={values.sccName}
                            onChangeText={handleChange('sccName')}
                            onBlur={handleBlur('sccName')}
                            error={hasError('sccName')}
                            keyboardType="default"
                            returnKeyType="next"
                        />
                        <SingleTextField
                            label="Faith Sharing Name"
                            placeholder="e.g., St. Jude"
                            value={values.faithSharingName}
                            onChangeText={handleChange('faithSharingName')}
                            onBlur={handleBlur('faithSharingName')}
                            error={hasError('faithSharingName')}
                            keyboardType="default"
                            returnKeyType="next"
                        />
                        
                        <View style={styles.datePickerContainer}>
                            <Text style={styles.label}>Date of Gathering <Text className="text-red-500">*</Text></Text>
                            
                            <View style={[styles.dateInputWrapper, hasError('date') && styles.dateInputError]}>
                                <TextInput
                                    style={styles.dateTextInput}
                                    placeholder="YYYY-MM-DD (e.g., 2025-12-31)"
                                    placeholderTextColor="#6B7280"
                                    value={values.date}
                                    onChangeText={handleChange('date')}
                                    onBlur={handleBlur('date')}
                                    keyboardType={Platform.OS === 'ios' ? 'numbers-and-punctuation' : 'default'}
                                    returnKeyType="done"
                                    editable={false}
                                />

                                <TouchableOpacity 
                                    onPress={() => {
                                        setShowDatePicker(true);
                                        setFieldTouched('date', true);
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

                            {showDatePicker && (
                                <DateTimePicker
                                    testID="dateTimePicker"
                                    value={getCurrentDate(values.date)}
                                    mode="date"
                                    display={Platform.OS === 'ios' ? 'spinner' : 'default'} 
                                    onChange={handleDateChange} 
                                />
                            )}
                        </View>

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
                return (
                    <View className="p-4">
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
                        <SingleTextField
                            label="Women Attendance"
                            placeholder="Enter number of women"
                            value={values.womenAttendance}
                            onChangeText={(text) => handleNumericChange('womenAttendance', text)}
                            onBlur={handleBlur('womenAttendance')}
                            error={hasError('womenAttendance')}
                            keyboardType="numeric"
                            returnKeyType="next"
                        />
                        <SingleTextField
                            label="Youth Attendance"
                            placeholder="Enter number of youth"
                            value={values.youthAttendance}
                            onChangeText={(text) => handleNumericChange('youthAttendance', text)}
                            onBlur={handleBlur('youthAttendance')}
                            error={hasError('youthAttendance')}
                            keyboardType="numeric"
                            returnKeyType="next"
                        />
                        <SingleTextField
                            label="Catechumen Attendance"
                            placeholder="Enter number of Catechumens"
                            value={values.catechumenAttendance}
                            onChangeText={(text) => handleNumericChange('catechumenAttendance', text)}
                            onBlur={handleBlur('catechumenAttendance')}
                            error={hasError('catechumenAttendance')}
                            keyboardType="numeric"
                            returnKeyType="next"
                        />
                        <SingleTextField
                            label="Total Offerings (e.g., 500)"
                            placeholder="Total amount collected"
                            value={values.totalOfferings}
                            onChangeText={(text) => handleNumericChange('totalOfferings', text, true)} 
                            onBlur={handleBlur('totalOfferings')}
                            error={hasError('totalOfferings')}
                            keyboardType="numeric"
                            returnKeyType="done"
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

                        <Text style={styles.label}>Upload Photos (Optional - Max {MAX_IMAGE_SIZE_MB}MB each)</Text>
                        <CustomButton 
                            title="Select Images" 
                            onPress={pickImage} 
                            className='bg-orange-500 mb-4'
                        />

                        {selectedImages.length > 0 && (
                            <View className="flex-row flex-wrap mb-4">
                                {selectedImages.map((image, index) => (
                                    <View key={`${image.base64.substring(0, 10)}-${index}`} style={styles.imagePreviewContainer}>
                                        <Image 
                                            source={{ uri: `data:${image.mimeType};base64,${image.base64}` }} 
                                            style={styles.imagePreview} 
                                        />
                                        <TouchableOpacity 
                                            onPress={() => removeImage(image.base64)}
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

    const handleNext = async () => {
        const stepSchema = validationSchema[currentStep - 1];
        
        try {
            await stepSchema.validate(values, { abortEarly: false });
            
            if (currentStep < TOTAL_STEPS) {
                setCurrentStep(prev => prev + 1);
                scrollViewRef.current?.scrollTo({ y: 0, animated: true });
            }
        } catch (err: any) {
            Alert.alert("Validation Error", "Please correct the errors on this page before continuing.");
            
            const newTouched: { [key: string]: boolean } = {};
            if (err.inner) {
                err.inner.forEach((error: any) => { 
                    if (error.path) {
                        newTouched[error.path] = true;
                    }
                });
            } else if (err.fields) {
                Object.keys(err.fields).forEach(key => { 
                    newTouched[key] = true;
                });
            }
            
            setTouched({ ...touched, ...newTouched }); 
        }
    };

    const handleBack = () => {
        if (currentStep > 1) {
            setCurrentStep(prev => prev - 1);
            scrollViewRef.current?.scrollTo({ y: 0, animated: true });
        }
    }

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