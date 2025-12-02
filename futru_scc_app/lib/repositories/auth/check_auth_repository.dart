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
    final ApiConfig config = ApiConfig();
    final String path = config.apiBasePath + config.checkAuthUrl;
    final Uri url = Uri.https(config.apiBaseUrl, path);
    final jwtAuthToken = await _localStorageRepository.getJWTAuthToken();
    final response = await _client.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtAuthToken"
      }
    );

    try {
      final jsonResponse = checkAuthResponseModelFromJson(response.body);
      if(response.statusCode == 200 || response.statusCode == 201) {
        return CheckAuthResponseModel(
          success: jsonResponse.success,
          message: "",
          user: jsonResponse.user
        );
      } else {
        return CheckAuthResponseModel(
          success: jsonResponse.success,
          message: jsonResponse.message,
          user: null
        );
      }
    } catch(e) {
      return CheckAuthResponseModel(
        success: false,
        message: e.toString(),
        user: null
      );
    }
  }
}