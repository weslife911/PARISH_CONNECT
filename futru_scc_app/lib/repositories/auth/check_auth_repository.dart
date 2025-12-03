import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:futru_scc_app/config/api_config.dart';
import 'package:futru_scc_app/models/auth/check_auth_response_model.dart';
import 'package:futru_scc_app/repositories/storage/local_storage_repository.dart';
import 'package:futru_scc_app/utils/logger_util.dart'; // ADDED: Logger utility
import "package:http/http.dart";

final checkAuthRepositoryProvider = Provider((ref) => CheckAuthRepository(
  client: Client(),
  localStorageRepository: LocalStorageRepository()
));

final checkAuthRepositoryStateProvider = StateProvider<CheckAuthResponseModel?>((ref) => null);


class CheckAuthRepository {
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  CheckAuthRepository({
    required Client client,
    required LocalStorageRepository localStorageRepository,
  }): _client = client, _localStorageRepository = localStorageRepository;

  Future<CheckAuthResponseModel> checkAuth() async {
    // -------------------------------------------------------------------
    logger.d('Starting checkAuth() process...'); // FIXED
    // -------------------------------------------------------------------
    final ApiConfig config = ApiConfig();
    final String path = config.apiBasePath + config.checkAuthUrl;
    final Uri url = Uri.https(config.apiBaseUrl, path);
    logger.d('Constructed URL: $url'); // FIXED
    
    final jwtAuthToken = await _localStorageRepository.getJWTAuthToken();
    
    // Check if a token exists locally before making the request
    if (jwtAuthToken == null || jwtAuthToken.isEmpty) {
      logger.i('No JWT token found in local storage. Returning failure.'); // FIXED
      return CheckAuthResponseModel(
        success: false,
        message: "No authentication token found. Please log in.",
        user: null
      );
    }
    
    logger.d('JWT Token retrieved (first 10 chars): ${jwtAuthToken.substring(0, 10)}...'); // FIXED
    
    try {
      final response = await _client.get(
        url,
        headers: {
          "Authorization": "Bearer $jwtAuthToken"
        }
      );

      // -------------------------------------------------------------------
      logger.d('API call completed. Status Code: ${response.statusCode}'); // FIXED
      // -------------------------------------------------------------------

      // Explicitly handle 401 Unauthorized (Token expired/invalid)
      if (response.statusCode == 401) {
        await _localStorageRepository.removeJWTAuthToken(); 
        logger.w('Status 401 received. Token cleared and returning session expired message.'); // FIXED
        return CheckAuthResponseModel(
          success: false,
          message: "Session expired or invalid. Please log in again.",
          user: null
        );
      }
      
      final jsonResponse = checkAuthResponseModelFromJson(response.body);
      
      if(response.statusCode == 200 || response.statusCode == 201) {
        // -------------------------------------------------------------------
        logger.i('Status ${response.statusCode}. Auth check SUCCESS. User role: ${jsonResponse.user?.role}'); // FIXED
        // -------------------------------------------------------------------
        return CheckAuthResponseModel(
          success: jsonResponse.success,
          message: "",
          user: jsonResponse.user
        );
      } else {
        // -------------------------------------------------------------------
        logger.w('Status ${response.statusCode}. Auth check FAILURE. Message: ${jsonResponse.message}'); // FIXED
        // -------------------------------------------------------------------
        return CheckAuthResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
          user: null
        );
      }
    } catch(e) {
      // -------------------------------------------------------------------
      logger.e('An exception occurred during checkAuth: ${e.toString()}', error: e); // FIXED (Using logger.e and error parameter)
      // -------------------------------------------------------------------
      return CheckAuthResponseModel(
        success: false,
        message: "Failed to process server response: ${e.toString()}",
        user: null
      );
    }
  }
}