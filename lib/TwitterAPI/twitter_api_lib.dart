import 'dart:io';
import 'dart:convert';

// OAuth and HTTP Request
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http_auth/http_auth.dart';

// API Key Setting
import 'package:bulletter/Config/config.dart' as config;

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

// WORKING
class TwitterAPIUtil {
  void authorize() async {
    // Platform パラメータの定義
    var platform = oauth1.Platform(
        'https://api.twitter.com/oauth/request_token', // OAuth リクエストトークンを取得するための POST Request API
        'https://api.twitter.com/oauth/authorize', // ユーザ認証を行うための GET Request API
        'https://api.twitter.com/oauth/access_token', // OAuth リクエストトークンをアクセストークンに交換するための POST Request API
        oauth1.SignatureMethods.hmacSha1);

    // クライアント認証の定義
    const String apiKey = config.consumer_ApiKey;
    const String apiSecret = config.consumer_ApiSecret;
    var clientCredentials = oauth1.ClientCredentials(apiKey, apiSecret);

    // クライアント認証とAPI設定から認証用オブジェクトを作成
    var auth = oauth1.Authorization(clientCredentials, platform);
  }

  void tweet() async {}
} // - WORKING