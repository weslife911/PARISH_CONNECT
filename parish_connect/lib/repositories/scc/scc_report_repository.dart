import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/config/api_config.dart';
import 'package:parish_connect/models/scc/create_scc_record_response.dart';
import 'package:parish_connect/models/scc/records_response_model.dart';
import 'package:parish_connect/models/scc/scc_record_model.dart';
import 'package:parish_connect/repositories/storage/local_storage_repository.dart';
import 'package:parish_connect/utils/logger_util.dart'; // ADDED: Logger utility
import 'package:http/http.dart';

final sccReportRepositoryProvider = Provider((ref) => SccReportRepository(
  client: Client(),
  localStorageRepository: LocalStorageRepository()
));

final getSCCRecordsFutureProvider = FutureProvider<RecordsResponseModel>((ref) async {
  return await ref.read(sccReportRepositoryProvider).getSCCRecords();
});

class SccReportRepository {
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  SccReportRepository({
    required Client client,
    required LocalStorageRepository localStorageRepository,
  }): _client = client, _localStorageRepository = localStorageRepository;

  Future<CreateSccRecordResponseModel> createSCCReport(SccReportModel report) async {
    final String baseUrl = ApiConfig().apiBaseUrl;
    final remainingUrl = ApiConfig().apiBasePath + ApiConfig().addSCCRecordsUrl;

    final Uri url = Uri.https(baseUrl, remainingUrl);
    final Map<String, dynamic> requestBody = report.toJson();
    final String? token = await _localStorageRepository.getJWTAuthToken(); // Get token once

    // DEBUG: Log the final request details before sending
    logger.d('SCCRepo: --- API CALL STARTED ---'); // FIXED
    logger.d('SCCRepo: Request URL: $url'); // FIXED
    logger.d('SCCRepo: HTTP Method: POST'); // FIXED
    logger.d('SCCRepo: Authorization Token (Exists?): ${token!.isNotEmpty}'); // FIXED
    logger.d('SCCRepo: Request Body (JSON - snippet): ${jsonEncode(requestBody).substring(0, 100)}...'); // FIXED

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
      logger.d('SCCRepo: API Response Status Code: ${response.statusCode}'); // FIXED
      logger.d('SCCRepo: API Response Body: ${response.body}'); // FIXED

      final jsonResponse = createSccRecordResponseModelFromJson(response.body);

      if(response.statusCode == 200 || response.statusCode == 201) {
        logger.i('SCCRepo: Request successful (Status ${response.statusCode}).'); // FIXED
        return CreateSccRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      } else {
        logger.w('SCCRepo: Request failed (Status ${response.statusCode}).'); // FIXED
        return CreateSccRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      }
    } catch(e) {
      // DEBUG: Log any exception during the network call
      logger.e('SCCRepo: Network Exception.', error: e); // FIXED (Using logger.e and error parameter)
      return CreateSccRecordResponseModel(
        success: false,
        message: e.toString()
      );
    }
  }

  Future<RecordsResponseModel> getSCCRecords() async {
    logger.d('SCCRepo: Starting getSCCRecords() process.'); // DEBUG: Function start

    final String baseUrl = ApiConfig().apiBaseUrl;
    final remainingUrl = ApiConfig().apiBasePath + ApiConfig().getSCCRecordsUrl;

    final Uri url = Uri.https(baseUrl, remainingUrl);
    logger.d('SCCRepo: Constructed URL: $url'); // DEBUG: Log final URL

    final String? token = await _localStorageRepository.getJWTAuthToken();

    if (token == null || token.isEmpty) {
        logger.w('SCCRepo: No JWT token found for getSCCRecords request.'); // WARNING: Missing token
        return RecordsResponseModel(
            success: false,
            message: "Authentication token missing.",
            records: []
        );
    }

    logger.d('SCCRepo: Token found. Making API GET request...'); // DEBUG: Token confirmed

    try {
        final Response response = await _client.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );

        // DEBUG: Log the immediate response details
        logger.d('SCCRepo: API Response Status: ${response.statusCode}');
        logger.d('SCCRepo: API Response Body (snippet): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');

        final jsonResponse = recordsResponseModelFromJson(response.body);

        if(response.statusCode == 200 || response.statusCode == 201) {
            // INFO: Success case
            logger.i('SCCRepo: Records fetched successfully. Found ${jsonResponse.records.length} records.');
            return RecordsResponseModel(
              success: jsonResponse.success,
              message: jsonResponse.message,
              records: jsonResponse.records
            );
        } else {
            // WARNING: API returned an error status (e.g., 400, 500)
            logger.w('SCCRepo: API returned error status ${response.statusCode}. Message: ${jsonResponse.message}');
            return RecordsResponseModel(
              success: jsonResponse.success,
              message: jsonResponse.message,
              records: []
            );
        }
    } catch(e, s) {
        // ERROR: Network or parsing exception
        logger.e('SCCRepo: Critical Exception fetching records.', error: e, stackTrace: s);
        return RecordsResponseModel(
          success: false,
          message: "Network or Parsing Error: ${e.toString()}",
          records: []
        );
    }
}
}
