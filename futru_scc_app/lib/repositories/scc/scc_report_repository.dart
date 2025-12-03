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
    final remainingUrl = ApiConfig().apiBasePath + ApiConfig().getSCCRecordsUrl;

    final Uri url = Uri.https(baseUrl, remainingUrl);
    final Map<String, dynamic> requestBody = report.toJson();
    try {
      final Response response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_localStorageRepository.getJWTAuthToken()}'
        },
        body: jsonEncode(requestBody)
      );
      final jsonResponse = createSccRecordResponseModelFromJson(response.body);
      if(response.statusCode == 200 || response.statusCode == 201) {
        return CreateSccRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      } else {
        return CreateSccRecordResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      }
    } catch(e) {
      return CreateSccRecordResponseModel(
        success: false,
        message: e.toString()
      );
    }
  }
}