import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/config/api_config.dart';
import 'package:parish_connect/models/auth/auth_response_model.dart';
import 'package:parish_connect/models/auth/profile/update_user_request_model.dart';
import 'package:parish_connect/models/auth/profile/update_user_response_model.dart';
import 'package:parish_connect/repositories/auth/check_auth_repository.dart';
import 'package:parish_connect/repositories/storage/local_storage_repository.dart';
import 'package:parish_connect/utils/logger_util.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
    ref: ref,
  ),
);

class AuthRepository {
  final Client _client;
  final LocalStorageRepository _localStorageRepository;
  final Ref _ref;

  AuthRepository({
    required Client client,
    required LocalStorageRepository localStorageRepository,
    required Ref ref,
  }) : _client = client,
       _localStorageRepository = localStorageRepository,
       _ref = ref;

  Future<AuthResponseModel> loginUser(String email, String password) async {
    final ApiConfig config = ApiConfig();
    final String path = config.apiBasePath + config.loginUrl;
    final Uri url = Uri.https(config.apiBaseUrl, path);

    final body = jsonEncode({"email": email, "password": password});
    logger.d('Login Request (URL: $url, Body: $body)');

    try {
      final response = await _client.post(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      logger.d(
        'Login Response (Status: ${response.statusCode}, Body: ${response.body})',
      );

      final jsonResponse = authResponseModelFromJson(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse.token != null) {
          await _localStorageRepository.setJWTAuthToken(jsonResponse.token!);

          // Trigger checkAuth to populate user state
          final checkAuth = await _ref
              .read(checkAuthRepositoryProvider)
              .checkAuth();

          if (!checkAuth.success) {
            return AuthResponseModel(
              success: false,
              message: checkAuth.message,
              token: "",
            );
          }
        }
        return jsonResponse;
      } else {
        return AuthResponseModel(
          success: false,
          message: jsonResponse.message ?? "Login failed",
          token: "",
        );
      }
    } catch (e) {
      logger.e('Login Error: Exception caught.', error: e);
      return AuthResponseModel(
        success: false,
        message: e.toString(),
        token: "",
      );
    }
  }

  Future<AuthResponseModel> signupUser(
    String fullName,
    String userName,
    String deanery,
    String parish,
    String email,
    String password,
  ) async {
    final ApiConfig config = ApiConfig();
    final String path = config.apiBasePath + config.signupUrl;
    final Uri url = Uri.https(config.apiBaseUrl, path);

    final body = jsonEncode({
      "full_name": fullName,
      "username": userName,
      "email": email,
      "deanery": deanery,
      "parish": parish,
      "password": password,
    });
    logger.d('Signup Request (URL: $url, Body: $body)');

    try {
      final response = await _client.post(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      logger.d(
        'Signup Response (Status: ${response.statusCode}, Body: ${response.body})',
      );

      final jsonResponse = authResponseModelFromJson(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse.token != null) {
          await _localStorageRepository.setJWTAuthToken(jsonResponse.token!);

          final checkAuth = await _ref
              .read(checkAuthRepositoryProvider)
              .checkAuth();

          if (!checkAuth.success) {
            return AuthResponseModel(
              success: false,
              message: checkAuth.message,
              token: "",
            );
          }
        }
        return jsonResponse;
      } else {
        return AuthResponseModel(
          success: false,
          message: jsonResponse.message ?? "Signup failed",
          token: "",
        );
      }
    } catch (e) {
      logger.e('Signup Error: Exception caught.', error: e);
      return AuthResponseModel(
        success: false,
        message: e.toString(),
        token: "",
      );
    }
  }

  Future<UpdateUserResponseModel> updateProfile(
    String userId,
    UpdateUserRequestModel updateData,
  ) async {
    final ApiConfig config = ApiConfig();
    final String path = "${config.apiBasePath}/update-profile/$userId";
    final Uri url = Uri.https(config.apiBaseUrl, path);

    final String body = updateUserModelToJson(updateData);
    final String? token = await _localStorageRepository.getJWTAuthToken();

    try {
      final response = await _client.put(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      logger.d(
        'Update Response (Status: ${response.statusCode}, Body: ${response.body})',
      );
      final jsonResponse = updateResponseModelFromJson(response.body);

      if (jsonResponse.success) {
        final getUpdatedUserDetails = await _ref
            .read(checkAuthRepositoryProvider)
            .checkAuth();

        if (!getUpdatedUserDetails.success) {
          return UpdateUserResponseModel(
            success: false,
            message:
                "Profile updated, but failed to refresh user data: ${getUpdatedUserDetails.message}",
          );
        }
        return jsonResponse;
      } else {
        return jsonResponse;
      }
    } catch (e) {
      logger.e('Update Error: Exception caught.', error: e);
      return UpdateUserResponseModel(
        success: false,
        message: "An error occurred during update: ${e.toString()}",
      );
    }
  }
}
