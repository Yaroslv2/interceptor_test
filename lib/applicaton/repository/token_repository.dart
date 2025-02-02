import 'package:interceptor_test/applicaton/constants/storage_keys.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenRepository {
  static late final SharedPreferences _sharedPrefs;

  TokenRepository();

  static Future init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  Future<bool> saveTokensInStorage(
      {required String access, required String refresh}) async {
    if (!await _sharedPrefs.setString(StorageKeys.accessToken, access)) {
      return false;
    }
    if (!await _sharedPrefs.setString(StorageKeys.refreshToken, refresh)) {
      return false;
    }
    return true;
  }

  String? getAccessToken() {
    if (!_sharedPrefs.containsKey(StorageKeys.accessToken)) {
      return null;
    }

    return _sharedPrefs.getString(StorageKeys.accessToken);
  }

  String? getRefreshToken() {
    if (!_sharedPrefs.containsKey(StorageKeys.refreshToken)) {
      return null;
    }

    return _sharedPrefs.getString(StorageKeys.refreshToken);
  }

  bool isTokenExpired() {
    String? access = getAccessToken();
    if (access == null) {
      return true;
    }

    return Jwt.getExpiryDate(access)!.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch < 60;
  }
}
