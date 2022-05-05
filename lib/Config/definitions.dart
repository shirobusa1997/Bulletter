import 'package:flutter/cupertino.dart';

// TwitterAuthorizeWindow Definitions
const String twitterAuthWindowTitle = 'Twitter Authorization';
const String authTempFileName = '.atemp';
const String appTitle = 'Bulletter';
const String appIconPath = 'images/3d_file_import3.ico';
const String appImagePath = 'images/3d_file_import3.png';
const Size initialSize = Size(600, 450);
const Size twitterAuthWindowSize = Size(300, 200);

enum EAppState {
  initializing, // 初期化中
  authorizing, // 認証中
  notAuthorized, // 未認証
  ready, // ツイート準備完了
  updatingStatus, // ツイート送信中(ユーザステータス更新中)
}
