import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// Update paths to match your project structure
import 'package:futru_scc_app/config/api_config.dart'; 
import 'package:futru_scc_app/models/parish/create_parish_record_response.dart'; 
import 'package:futru_scc_app/models/parish/parish_records_response_model.dart'; 
import 'package:futru_scc_app/models/parish/parish_record_model.dart'; 
import 'package:futru_scc_app/repositories/storage/local_storage_repository.dart';
import 'package:futru_scc_app/utils/logger_util.dart'; // Using the logger utility
import 'package:http/http.dart';

// 1. Riverpod Provider for the Repository
final parishReportRepositoryProvider = Provider((ref) => ParishReportRepository(
  client: Client(),
  localStorageRepository: LocalStorageRepository()
));

// 2. Riverpod FutureProvider for fetching all records
final getParishRecordsFutureProvider = FutureProvider<ParishRecordsResponseModel>((ref) async {
  return await ref.read(parishReportRepositoryProvider).getParishRecords();
});

class ParishReportRepository {
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  ParishReportRepository({
    required Client client,
    required LocalStorageRepository localStorageRepository,
  }): _client = client, _localStorageRepository = localStorageRepository;


  /// Creates a new Parish Commission record via POST request.
  Future<CreateParishRecordResponseModel> createParishReport(ParishReportModel report) async {
    final String baseUrl = ApiConfig().apiBaseUrl;
    // Assuming ApiConfig().addParishRecordsUrl is defined and points to /add-record
    final remainingUrl = ApiConfig().apiBasePath + ApiConfig().addParishRecordsUrl; 

    final Uri url = Uri.https(baseUrl, remainingUrl);
    final Map<String, dynamic> requestBody = report.toJson();
    final String? token = await _localStorageRepository.getJWTAuthToken();

    // DEBUG: Log the final request details before sending
    logger.d('ParishRepo: --- API CALL STARTED (Create) ---');
    logger.d('ParishRepo: Request URL: $url');
    logger.d('ParishRepo: HTTP Method: POST');
    logger.d('ParishRepo: Authorization Token (Exists?): ${token!.isNotEmpty}');
    // Log a snippet of the body to avoid flooding logs
    logger.d('ParishRepo: Request Body (JSON - snippet): ${jsonEncode(requestBody).substring(0, 100)}...'); 

    try {
      final Response response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(requestBody)
      );

      // DEBUG: Log the API response details
      logger.d('ParishRepo: API Response Status Code: ${response.statusCode}');
      logger.d('ParishRepo: API Response Body: ${response.body}');

      final jsonResponse = createParishRecordResponseModelFromJson(response.body);
      
      if(response.statusCode == 200 || response.statusCode == 201) {
        logger.i('ParishRepo: Request successful (Status ${response.statusCode}).');
        return CreateParishRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      } else {
        logger.w('ParishRepo: Request failed (Status ${response.statusCode}).');
        return CreateParishRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      }
    } catch(e) {
      // DEBUG: Log any exception during the network call
      logger.e('ParishRepo: Network Exception during creation.', error: e);
      return CreateParishRecordResponseModel(
        success: false,
        message: e.toString()
      );
    }
  }


  /// Fetches all Parish Commission records via GET request.
  Future<ParishRecordsResponseModel> getParishRecords() async {
    logger.d('ParishRepo: Starting getParishRecords() process.');
    
    final String baseUrl = ApiConfig().apiBaseUrl;
    // Assuming ApiConfig().getParishRecordsUrl is defined and points to /records
    final remainingUrl = ApiConfig().apiBasePath + ApiConfig().getParishRecordsUrl;

    final Uri url = Uri.https(baseUrl, remainingUrl);
    logger.d('ParishRepo: Constructed URL: $url');
    
    final String? token = await _localStorageRepository.getJWTAuthToken();
    
    if (token == null || token.isEmpty) {
        logger.w('ParishRepo: No JWT token found for getParishRecords request.');
        return ParishRecordsResponseModel(
            success: false,
            message: "Authentication token missing.",
            parishes: []
        );
    }
    
    logger.d('ParishRepo: Token found. Making API GET request...');

    try {
        final Response response = await _client.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        
        // DEBUG: Log the immediate response details
        logger.d('ParishRepo: API Response Status: ${response.statusCode}');
        logger.d('ParishRepo: API Response Body (snippet): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');

        final jsonResponse = parishRecordsResponseModelFromJson(response.body);

        if(response.statusCode == 200 || response.statusCode == 201) {
            // INFO: Success case
            logger.i('ParishRepo: Records fetched successfully. Found ${jsonResponse.parishes.length} records.'); 
            return ParishRecordsResponseModel(
              success: jsonResponse.success,
              message: jsonResponse.message,
              parishes: jsonResponse.parishes // Key is 'parishes'
            );
        } else {
            // WARNING: API returned an error status (e.g., 400, 500)
            logger.w('ParishRepo: API returned error status ${response.statusCode}. Message: ${jsonResponse.message}');
            return ParishRecordsResponseModel(
              success: jsonResponse.success,
              message: jsonResponse.message,
              parishes: []
            );
        }
    } catch(e, s) {
        // ERROR: Network or parsing exception
        logger.e('ParishRepo: Critical Exception fetching records.', error: e, stackTrace: s);
        return ParishRecordsResponseModel(
          success: false,
          message: "Network or Parsing Error: ${e.toString()}",
          parishes: []
        );
    }
  }
}