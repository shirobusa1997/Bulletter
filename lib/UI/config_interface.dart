import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:event/event.dart';

import 'package:nativeshell/nativeshell.dart';

import 'package:bulletter/Config/definitions.dart' as definitions;
import 'package:bulletter/main.dart';

// 設定メニューのウィンドウ定義
class ConfigWindowState extends WindowState {
  // ウィジェットの構造定義
  @override
  Widget build(BuildContext context) {
    return CommonWindow(child: ConfigWindow());
  }

  // ウィンドウのリサイズ設定
  @override
  WindowSizingMode get windowSizingMode =>
      WindowSizingMode.atLeastIntrinsicSize;

  // ウィンドウの初期化処理
  @override
  Future<void> initializeWindow(Size intrinsicContentSize) async {
    if (Platform.isMacOS) {
      // macOS 向けの初期化処理をここに追記
      // ex: メニューバーの初期化(Menu.setAsAppMenu())とか
    }
    await window.setTitle('Bulletter ConfigMenu');

    return super.initializeWindow(intrinsicContentSize);
  }
}

// 設定メニューのウィジェット本体定義
class ConfigWindow extends StatefulWidget {
  const ConfigWindow();

  @override
  State<StatefulWidget> createState() => _ConfigWindowState();
}

// 設定メニューウィジェットのステート定義
class _ConfigWindowState extends State<ConfigWindow> {
  @override
  void initState() {
    super.initState();
  }

  Window? otherWindow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Push FloatingActionButton to authorize Twitter account.',
            ),
          ],
        ),
      ),
      floatingActionButton: otherWindow == null
          ? FloatingActionButton(
              onPressed: () async {
                final window = await Window.create(
                    TwitterAuthorizationWindowState.toInitData());
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () async {
                await otherWindow!.close();
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
    );
  }
}

class TwitterAuthorizationWindowState extends WindowState {
  @override
  Widget build(BuildContext context) {
    return Text('This is Another Window.');
  }

  @override
  // TODO: implement windowSizingMode
  WindowSizingMode get windowSizingMode => throw UnimplementedError();

  static dynamic toInitData() => {
        'class': 'OtherWindow',
      };

  static TwitterAuthorizationWindowState? fromInitData(dynamic initData) {
    if (initData is Map && initData['class'] == 'OtherWindow') {
      return TwitterAuthorizationWindowState();
    }
    return null;
  }
}

class BulletterPINArgs extends EventArgs {
  String inputValue;
  BulletterPINArgs(this.inputValue);
}

class TwitterPINRequestWindowState extends WindowState {
  String inputValue = "";

  @override
  Future<void> initializeWindow(Size intrinsicContentSize) async {
    Offset? origin;

    final parentGeometry = await window.parentWindow?.getGeometry();
    if (parentGeometry?.frameOrigin != null &&
        parentGeometry?.frameSize != null) {
      origin = parentGeometry!.frameOrigin!
          .translate(parentGeometry.frameSize!.width + 20, 0);
    }

    await window.setGeometry(Geometry(
      frameOrigin: origin,
      contentSize: intrinsicContentSize,
    ));
    await window.setStyle(WindowStyle(canResize: false));
    await window.show();
  }

  static dynamic toInitData() => {
        'class': 'otherWindow',
      };

  static TwitterPINRequestWindowState? fromInitData(dynamic initData) {
    if (initData is Map && initData['class'] == 'otherWindow') {
      return TwitterPINRequestWindowState();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Input PIN from Twitter Page',
              ),
              onChanged: (text) {
                inputValue = text;
              },
            ),
            TextButton(
                onPressed: () {
                  // イベント通知に乗せるパラメタを設定
                  var args = Event<BulletterPINArgs>();
                  // サブスクライバーにイベントをブロードキャスト
                  args.broadcast(BulletterPINArgs(inputValue));
                },
                child: const Text('Authorize')),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement windowSizingMode
  WindowSizingMode get windowSizingMode => throw UnimplementedError();
}
