import 'dart:convert';

import 'package:http_auth/http_auth.dart';

class Base64Util {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  // String to base64 hash
  String encode(String input) {
    return stringToBase64.encode(input);
  }

  // base64 hash to String value
  String decode(String input) {
    return stringToBase64.decode(input);
  }
}

class OAuthToken {
  final String tokenType, accessToken;

  OAuthToken(this.tokenType, this.accessToken);

  OAuthToken.fromJson(Map<String, dynamic> json)
    : tokenType = json['token_type'],
      accessToken = json['access_token'];
}

class TwitterAPIUtil {
  bool authorize() async {
    
  }
}