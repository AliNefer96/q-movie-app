import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  String _bearerToken;

  AuthProvider(this._bearerToken);

  String get bearerToken => _bearerToken;

  
  void updateBearerToken(String newToken) {
    _bearerToken = newToken;
    notifyListeners();
  }
}