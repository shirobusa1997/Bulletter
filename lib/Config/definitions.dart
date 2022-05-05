import 'package:flutter/cupertino.dart';

// TwitterAuthorizeWindow Definitions
const String twitterAuthWindowTitle = 'Twitter Authorization';
const String authTempFileName = '.atemp';
const Size twitterAuthWindowSize = Size(300, 200);

enum EAppState {
  initializing, // 初期化中
  authorizing, // 認証中
  notAuthorized, // 未認証
  ready, // ツイート準備完了
  updatingStatus, // ツイート送信中(ユーザステータス更新中)
}
