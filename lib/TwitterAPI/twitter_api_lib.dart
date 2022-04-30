import 'dart:io';
import 'dart:convert';

// OAuth and HTTP Request
import 'package:bulletter/UI/config_interface.dart';
import 'package:event/event.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:http_auth/http_auth.dart';

// Window Management
import 'package:nativeshell/nativeshell.dart';

// Toast notification for debug
import 'package:eyro_toast/eyro_toast.dart';

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

    // PINを要求
    await auth.requestTemporaryCredentials('oob').then((res) async {
      // [USER] Twitter サイト上で認証の上PINコードの入力を要求する
      final window = await Window.create(TwitterPINRequestWindowState());
      var event = Event<BulletterPINArgs>();
      var verifier = "";
      event.subscribe((args) => verifier);
      return auth.requestTokenCredentials(res.credentials, verifier);
    }).then((res) async {
      // Client オブジェクトを生成
      var client = oauth1.Client(
          platform.signatureMethod, clientCredentials, res.credentials);
      // ユーザ情報にアクセス
      await EyroToast.showToast(
          text: 'CurrentUser : ' +
              res.optionalParameters['screen_name'].toString());
    });
  }
}

void tweet() async {}
// - WORKING