import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/config/api_config.dart';
import 'package:parish_connect/models/parish/create_parish_record_response.dart';
import 'package:parish_connect/models/parish/parish_records_response_model.dart';
import 'package:parish_connect/models/parish/parish_record_model.dart';
import 'package:parish_connect/repositories/storage/local_storage_repository.dart';
import 'package:parish_connect/utils/logger_util.dart';
import 'package:http/http.dart';

final parishReportRepositoryProvider = Provider(
  (ref) => ParishReportRepository(
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
  ),
);

final getParishRecordsFutureProvider =
    FutureProvider<ParishRecordsResponseModel>((ref) async {
      return await ref.read(parishReportRepositoryProvider).getParishRecords();
    });

class ParishReportRepository {
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  ParishReportRepository({
    required Client client,
    required LocalStorageRepository localStorageRepository,
  }) : _client = client,
       _localStorageRepository = localStorageRepository;

  Future<CreateParishRecordResponseModel> createParishReport(
    ParishReportModel report,
  ) async {
    final String baseUrl = ApiConfig().apiBaseUrl;
    final remainingUrl =
        ApiConfig().apiBasePath + ApiConfig().addParishRecordsUrl;

    final Uri url = Uri.https(baseUrl, remainingUrl);
    final Map<String, dynamic> requestBody = report.toJson();
    final String? token = await _localStorageRepository.getJWTAuthToken();

    logger.d('ParishRepo: --- API CALL STARTED (Create) ---');
    logger.d('ParishRepo: Request URL: $url');
    logger.d('ParishRepo: HTTP Method: POST');
    logger.d('ParishRepo: Authorization Token (Exists?): ${token!.isNotEmpty}');
    logger.d(
      'ParishRepo: Request Body (JSON - snippet): ${jsonEncode(requestBody).substring(0, 100)}...',
    );

    try {
      final Response response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      logger.d('ParishRepo: API Response Status Code: ${response.statusCode}');
      logger.d('ParishRepo: API Response Body: ${response.body}');

      final jsonResponse = createParishRecordResponseModelFromJson(
        response.body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(
          'ParishRepo: Request successful (Status ${response.statusCode}).',
        );
        return CreateParishRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
        );
      } else {
        logger.w('ParishRepo: Request failed (Status ${response.statusCode}).');
        return CreateParishRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
        );
      }
    } catch (e) {
      logger.e('ParishRepo: Network Exception during creation.', error: e);
      return CreateParishRecordResponseModel(
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<ParishRecordsResponseModel> getParishRecords() async {
    logger.d('ParishRepo: Starting getParishRecords() process.');

    final String baseUrl = ApiConfig().apiBaseUrl;
    final remainingUrl =
        ApiConfig().apiBasePath + ApiConfig().getParishRecordsUrl;

    final Uri url = Uri.https(baseUrl, remainingUrl);
    logger.d('ParishRepo: Constructed URL: $url');

    final String? token = await _localStorageRepository.getJWTAuthToken();

    if (token == null || token.isEmpty) {
      logger.w('ParishRepo: No JWT token found for getParishRecords request.');
      return ParishRecordsResponseModel(
        success: false,
        message: "Authentication token missing.",
        parishes: [],
      );
    }

    logger.d('ParishRepo: Token found. Making API GET request...');

    try {
      final Response response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      logger.d('ParishRepo: API Response Status: ${response.statusCode}');
      logger.d(
        'ParishRepo: API Response Body (snippet): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
      );

      final jsonResponse = parishRecordsResponseModelFromJson(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(
          'ParishRepo: Records fetched successfully. Found ${jsonResponse.parishes.length} records.',
        );
        return ParishRecordsResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
          parishes: jsonResponse.parishes,
        );
      } else {
        logger.w(
          'ParishRepo: API returned error status ${response.statusCode}. Message: ${jsonResponse.message}',
        );
        return ParishRecordsResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
          parishes: [],
        );
      }
    } catch (e, s) {
      logger.e(
        'ParishRepo: Critical Exception fetching records.',
        error: e,
        stackTrace: s,
      );
      return ParishRecordsResponseModel(
        success: false,
        message: "Network or Parsing Error: ${e.toString()}",
        parishes: [],
      );
    }
  }
}
