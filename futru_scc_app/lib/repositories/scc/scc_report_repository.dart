import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/config/api_config.dart';
import 'package:futru_scc_app/models/scc/create_scc_record_response.dart';
import 'package:futru_scc_app/models/scc/scc_record_model.dart';
import 'package:futru_scc_app/repositories/storage/local_storage_repository.dart';
import 'package:http/http.dart';

final sccReportRepositoryProvider = Provider((ref) => SccReportRepository(
  client: Client(),
  localStorageRepository: LocalStorageRepository()
));

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
    print('DEBUG SCCRepo: --- API CALL STARTED ---');
    print('DEBUG SCCRepo: Request URL: $url');
    print('DEBUG SCCRepo: HTTP Method: POST');
    print('DEBUG SCCRepo: Authorization Token (Exists?): ${token!.isNotEmpty}');
    print('DEBUG SCCRepo: Request Body (JSON): ${jsonEncode(requestBody).substring(0, 100)}...'); // Print first 100 chars

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
      print('DEBUG SCCRepo: API Response Status Code: ${response.statusCode}');
      print('DEBUG SCCRepo: API Response Body: ${response.body}');

      final jsonResponse = createSccRecordResponseModelFromJson(response.body);
      
      if(response.statusCode == 200 || response.statusCode == 201) {
        print('DEBUG SCCRepo: Request successful (Status ${response.statusCode}).');
        return CreateSccRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      } else {
        print('DEBUG SCCRepo: Request failed (Status ${response.statusCode}).');
        return CreateSccRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      }
    } catch(e) {
      // DEBUG: Log any exception during the network call
      print('DEBUG SCCRepo: Network Exception: $e');
      return CreateSccRecordResponseModel(
        success: false,
        message: e.toString()
      );
    }
  }
}