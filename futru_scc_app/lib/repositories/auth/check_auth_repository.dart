import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:futru_scc_app/config/api_config.dart';
import 'package:futru_scc_app/models/auth/check_auth_response_model.dart';
import 'package:futru_scc_app/repositories/storage/local_storage_repository.dart';
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
    print('DEBUG: Starting checkAuth() process...');
    // -------------------------------------------------------------------
    final ApiConfig config = ApiConfig();
    final String path = config.apiBasePath + config.checkAuthUrl;
    final Uri url = Uri.https(config.apiBaseUrl, path);
    print('DEBUG: Constructed URL: $url');
    
    final jwtAuthToken = await _localStorageRepository.getJWTAuthToken();
    
    // Check if a token exists locally before making the request
    if (jwtAuthToken == null || jwtAuthToken.isEmpty) {
      print('DEBUG: No JWT token found in local storage. Returning failure.');
      return CheckAuthResponseModel(
        success: false,
        message: "No authentication token found. Please log in.",
        user: null
      );
    }
    
    print('DEBUG: JWT Token retrieved (first 10 chars): ${jwtAuthToken.substring(0, 10)}...');
    
    try {
      final response = await _client.get(
        url,
        headers: {
          "Authorization": "Bearer $jwtAuthToken"
        }
      );

      // -------------------------------------------------------------------
      print('DEBUG: API call completed. Status Code: ${response.statusCode}');
      // -------------------------------------------------------------------

      // Explicitly handle 401 Unauthorized (Token expired/invalid)
      if (response.statusCode == 401) {
        await _localStorageRepository.removeJWTAuthToken(); 
        print('DEBUG: Status 401 received. Token cleared and returning session expired message.');
        return CheckAuthResponseModel(
          success: false,
          message: "Session expired or invalid. Please log in again.",
          user: null
        );
      }
      
      final jsonResponse = checkAuthResponseModelFromJson(response.body);
      
      if(response.statusCode == 200 || response.statusCode == 201) {
        // -------------------------------------------------------------------
        print('DEBUG: Status ${response.statusCode}. Auth check SUCCESS. User role: ${jsonResponse.user?.role}');
        // -------------------------------------------------------------------
        return CheckAuthResponseModel(
          success: jsonResponse.success,
          message: "",
          user: jsonResponse.user
        );
      } else {
        // -------------------------------------------------------------------
        print('DEBUG: Status ${response.statusCode}. Auth check FAILURE. Message: ${jsonResponse.message}');
        // -------------------------------------------------------------------
        return CheckAuthResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
          user: null
        );
      }
    } catch(e) {
      // -------------------------------------------------------------------
      print('ERROR: An exception occurred during checkAuth: ${e.toString()}');
      // -------------------------------------------------------------------
      return CheckAuthResponseModel(
        success: false,
        message: "Failed to process server response: ${e.toString()}",
        user: null
      );
    }
  }
}