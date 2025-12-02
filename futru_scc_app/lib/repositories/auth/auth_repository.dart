import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/config/api_config.dart';
import 'package:futru_scc_app/models/auth/auth_response_model.dart';
import 'package:futru_scc_app/repositories/storage/local_storage_repository.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
  client: Client(),
  localStorageRepository: LocalStorageRepository()
));

class AuthRepository {
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({
    required Client client,
    required LocalStorageRepository localStorageRepository,
  }): _client = client, _localStorageRepository = localStorageRepository;

  Future<AuthResponseModel> loginUser(String email, String password) async {
    final ApiConfig config = ApiConfig();
    final String path = config.apiBasePath + config.loginUrl;
    final Uri url = Uri.https(config.apiBaseUrl, path);
    final response = await _client.post(
      url,
      body: jsonEncode({
        "email": email,
        "password": password
      }),
      headers: {
        "Content-Type": "application/json",
      }
    );
    try {
      final jsonResponse = authResponseModelFromJson(response.body);
      if(response.statusCode == 200 || response.statusCode == 201) {
        await _localStorageRepository.setJWTAuthToken(jsonResponse.token!);
        return AuthResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
          token: jsonResponse.token
        );
      } else {
        return AuthResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      }
    } catch(e) {
      return AuthResponseModel(
        success: false,
        message: e.toString()
      );
    }
  }

  Future<AuthResponseModel> signupUser(String fullName, String userName, String deanery, String parish, String email, String password) async {
    final ApiConfig config = ApiConfig();
    final String path = config.apiBasePath + config.signupUrl;
    final Uri url = Uri.https(config.apiBaseUrl, path);
    final response = await _client.post(
      url,
      body: jsonEncode({
        "full_name": fullName,
        "username": userName,
        "email": email,
        "deanery": deanery,
        "parish": parish,
        "password": password
      }),
      headers: {
        "Content-Type": "application/json",
      }
    );
    try {
      final jsonResponse = authResponseModelFromJson(response.body);
      if(response.statusCode == 200 || response.statusCode == 201) {
        await _localStorageRepository.setJWTAuthToken(jsonResponse.token!);
        return AuthResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
          token: jsonResponse.token
        );
      } else {
        return AuthResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message
        );
      }
    } catch(e) {
      return AuthResponseModel(
        success: false,
        message: e.toString()
      );
    }
  }
}