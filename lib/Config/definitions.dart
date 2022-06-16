import 'package:flutter/cupertino.dart';

import 'package:event/event.dart';

import 'package:bulletter/TwitterAPI/twitter_api_lib.dart' as twtterAPILib;

// TwitterAuthorizeWindow Definitions
const String twitterAuthWindowTitle = 'Twitter Authorization';
const String authTempFileName = '.atemp';
const String appTitle = 'Bulletter';
const String appIconPath = 'images/3d_file_import3.ico';
const String appImagePath = 'images/3d_file_import3.png';
const double defaultCardPadding = 10.0; // Cardのパディング
const Size initialSize = Size(400, 300); // ウィジェットの初期サイズ
const Size twitterAuthWindowSize = Size(300, 200); // PIN認証ウィンドウの初期サイズ

enum EAppState {
  initializing, // 初期化中
  authorizing, // 認証中
  notAuthorized, // 未認証
  ready, // ツイート準備完了
  updatingStatus, // ツイート送信中(ユーザステータス更新中)
}

enum EBulletterEventType {
  pinRequested, // PIN認証要求
  postRequested, // ツイート要求
  logoutRequested, // ログアウト要求
  closeRequested, // アプリ終了要求
}

bool isReady() {
  return BulletterSingleton.instance.appState == EAppState.ready;
}

bool isAuthorizing() {
  return BulletterSingleton.instance.appState == EAppState.authorizing;
}

class BulletterEventArgs extends EventArgs {
  EBulletterEventType eventType;
  String inputValue;

  BulletterEventArgs(this.eventType, this.inputValue);
}

// Bulletter シングルトンファクトリクラス

class BulletterSingleton {
  // シングルトンインスタンス
  static final BulletterSingleton instance = BulletterSingleton._internal();

  // シングルトンのファクトリーメソッド
  factory BulletterSingleton() {
    return instance;
  }

  // 内部コンストラクタ
  BulletterSingleton._internal() {}

  // アプリケーションステート
  EAppState appState = EAppState.initializing;
}
