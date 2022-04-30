import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:event/event.dart';

import 'package:nativeshell/nativeshell.dart';

import 'package:bulletter/Config/definitions.dart' as definitions;

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
