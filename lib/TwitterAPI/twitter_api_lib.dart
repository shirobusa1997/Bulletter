// Dart Core Lib
import 'dart:convert';

// OAuth and HTTP request
import 'package:bulletter/UI/config_interface.dart';
import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

// API Key setting
import 'package:bulletter/Config/config.dart' as config;

// URL launcher
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Twitter API wrapper
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

// Toast notification for debug
import 'package:eyro_toast/eyro_toast.dart';

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
  oauth1.Credentials? tokenCredentials;

  // TwitterAPIV2 オブジェクト
  v2.TwitterApi twitter = new v2.TwitterApi(bearerToken: "");

  // OS既定のWebブラウザでTwitterログイン用ページを開く
  void requestAuthorize() async {
    await auth.requestTemporaryCredentials('oob').then((res) async {
      // 資格情報を取得
      tokenCredentials = res.credentials;

      // 既定のWebブラウザでログイン用URLを開く
      launchUrlString(
          auth.getResourceOwnerAuthorizationURI(tokenCredentials!.token));
    });
  }

  void authorize(String pin) async {
    // ユーザ情報を取得
    final verifier = pin;
    final res = await auth.requestTokenCredentials(tokenCredentials!, verifier);

    // Client オブジェクトを生成
    final client = oauth1.Client(
        platform.signatureMethod, clientCredentials, res.credentials);

    final apiResponse = await client.get(
      Uri.parse(
          'https://api.twitter.com/1.1/statuses/home_timeline.json?count=1'),
    );

    twitter = v2.TwitterApi(
      bearerToken: config.consumer_Bearer,
      oauthTokens: v2.OAuthTokens(
          consumerKey: config.consumer_ApiKey,
          consumerSecret: config.consumer_ApiSecret,
          accessToken: res.credentials.token,
          accessTokenSecret: res.credentials.tokenSecret),
    );

    final me = await twitter.usersService.lookupMe();

    // ユーザ情報にアクセス
    await EyroToast.showToast(text: "Authorized: " + me.data.username);
  }

  void tweet(String content) async {
    final me = await twitter.tweetsService.createTweet(text: content);

    await EyroToast.showToast(text: "Tweeted" + content);
  }
}

void tweet() async {}
// - WORKING