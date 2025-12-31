import 'package:parish_connect/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  Future<void> setJWTAuthToken(String jwtAuthTokenValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(jwtAuthTokenKey, jwtAuthTokenValue);
  }

  Future<String?> getJWTAuthToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? jwtAuthTokenValue = preferences.getString(jwtAuthTokenKey);
    return jwtAuthTokenValue;
  }

  Future<void> removeJWTAuthToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(jwtAuthTokenKey);
  }
}
