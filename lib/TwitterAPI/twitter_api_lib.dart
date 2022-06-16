import 'dart:convert';

// OAuth and HTTP Request
import 'package:bulletter/UI/config_interface.dart';
import 'package:event/event.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

// Toast notification for debug
import 'package:eyro_toast/eyro_toast.dart';

// API Key Setting
import 'package:bulletter/Config/config.dart' as config;
import 'package:twitter_api_v2/twitter_api_v2.dart';

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
  static final TwitterAPIUtil instance = TwitterAPIUtil._internal();

  factory TwitterAPIUtil() {
    return instance;
  }

  // 内部コンストラクタ
  TwitterAPIUtil._internal() {}

  // クライアント認証リクエスト用情報
  final clientCredentials = oauth1.ClientCredentials(
      config.consumer_ApiKey, config.consumer_ApiSecret);

  // Platform パラメータ定義
  final platform = oauth1.Platform(
      'https://api.twitter.com/oauth/request_token', // OAuth リクエストトークンを取得するための POST Request API
      'https://api.twitter.com/oauth/authorize', // ユーザ認証を行うための GET Request API
      'https://api.twitter.com/oauth/access_token', // OAuth リクエストトークンをアクセストークンに交換するための POST Request API
      oauth1.SignatureMethods.hmacSha1);

  // クライアント認証とAPI設定から認証用オブジェクトを作成
  late final auth = oauth1.Authorization(clientCredentials, platform);

  void authorize() async {
    // PINを要求
    await auth.requestTemporaryCredentials('oob').then((res) async {
      // [USER] Twitter サイト上で認証の上PINコードの入力を要求する
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