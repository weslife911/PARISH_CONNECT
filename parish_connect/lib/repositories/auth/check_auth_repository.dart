import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parish_connect/config/api_config.dart';
import 'package:parish_connect/models/auth/check_auth_response_model.dart';
import 'package:parish_connect/repositories/storage/local_storage_repository.dart';
import 'package:parish_connect/utils/logger_util.dart';
import "package:http/http.dart";

final checkAuthRepositoryProvider = Provider<CheckAuthRepository>(
  (ref) => CheckAuthRepository(
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
    ref: ref,
  ),
);

final checkAuthRepositoryStateProvider = StateProvider<CheckAuthResponseModel?>(
  (ref) => null,
);

class CheckAuthRepository {
  final Client _client;
  final LocalStorageRepository _localStorageRepository;
  final Ref _ref;

  CheckAuthRepository({
    required Client client,
    required LocalStorageRepository localStorageRepository,
    required Ref ref,
  }) : _client = client,
       _localStorageRepository = localStorageRepository,
       _ref = ref;

  Future<CheckAuthResponseModel> checkAuth() async {
    logger.d('Starting checkAuth() process...');

    final ApiConfig config = ApiConfig();
    final String path = config.apiBasePath + config.checkAuthUrl;
    final Uri url = Uri.https(config.apiBaseUrl, path);

    final jwtAuthToken = await _localStorageRepository.getJWTAuthToken();

    if (jwtAuthToken == null || jwtAuthToken.isEmpty) {
      logger.i('No JWT token found in local storage.');
      return CheckAuthResponseModel(
        success: false,
        message: "No authentication token found. Please log in.",
        user: null,
      );
    }

    try {
      final response = await _client.get(
        url,
        headers: {"Authorization": "Bearer $jwtAuthToken"},
      );

      if (response.statusCode == 401) {
        await _localStorageRepository.removeJWTAuthToken();
        logger.w('Session expired (401). Token cleared.');
        return CheckAuthResponseModel(
          success: false,
          message: "Session expired. Please log in again.",
          user: null,
        );
      }

      final jsonResponse = checkAuthResponseModelFromJson(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('Auth check SUCCESS. User: ${jsonResponse.user?.username}');

        _ref.read(checkAuthRepositoryStateProvider.notifier).state =
            jsonResponse;

        return jsonResponse;
      } else {
        logger.w('Auth check FAILURE. Status: ${response.statusCode}');
        return CheckAuthResponseModel(
          success: false,
          message: jsonResponse.message ?? "Authentication failed",
          user: null,
        );
      }
    } catch (e) {
      logger.e('Exception during checkAuth', error: e);
      return CheckAuthResponseModel(
        success: false,
        message: "Network error: ${e.toString()}",
        user: null,
      );
    }
  }
}
