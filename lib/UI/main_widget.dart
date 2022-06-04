import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:event/event.dart';
import 'package:eyro_toast/eyro_toast.dart';

import 'package:bulletter/UI/config_interface.dart' as configUi;
import 'package:bulletter/Config/definitions.dart' as definitions;
import 'package:bulletter/TwitterAPI/twitter_api_lib.dart' as twitterAPI;

class Choice {
  const Choice({required this.title});

  final String title;
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key? key, required this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.displayMedium;

    return Card(
      color: Colors.white,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            choice.title,
            style: textStyle,
          ),
        ],
      )),
    );
  }
}

@immutable
class TweetCard extends ChoiceCard {
  TweetCard({Key? key, required Choice choice})
      : super(key: key, choice: choice);

  String inputValue = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(definitions.defaultCardPadding),
        child: Column(
          children: [
            TextFormField(
              minLines: 3,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              autofocus: true,
              autocorrect: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Input your tweet"),
            ),
            TextButton(
                onPressed: () async {
                  // イベント通知に乗せるパラメタを設定
                  var args = Event<configUi.BulletterPINArgs>();
                  // サブスクライバーにイベントをブロードキャスト
                  args.broadcast(configUi.BulletterPINArgs(inputValue));

                  await EyroToast.showToast(
                      text: 'PostRequested: ' + inputValue,
                      duration: ToastDuration.short);
                },
                child: const Text('Tweet')),
          ],
        ),
      ),
    );
  }
}

@immutable
class DebugCard extends ChoiceCard {
  DebugCard({Key? key, required Choice choice})
      : super(key: key, choice: choice);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                final window =
                    await DesktopMultiWindow.createWindow(jsonEncode({
                  'args1': 'PIN Window',
                  'args2': 100,
                  'args3': true,
                  'bussiness': 'bussiness_test',
                }));
                window
                  ..setFrame(const Offset(0, 0) & const Size(1280, 720))
                  ..center()
                  ..setTitle('PIN Authendication Window')
                  ..show();
              },
              child: const Text('PIN Authendication Window')),
          TextButton(
            onPressed: () async {
              EyroToast.showToast(text: 'Toast Nortification Test');
            },
            child: const Text('Toast Notification Test'),
          ),
          TextButton(
            onPressed: () async {
              EyroToast.showToast(text: 'Toast Nortification Test');
              // Twitter アカウント認証
              twitterAPI.TwitterAPIUtil().authorize();
            },
            child: const Text('Twitter Authentification Test'),
          ),
        ],
      ),
    );
  }
}
