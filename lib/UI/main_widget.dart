import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:event/event.dart';
import 'package:eyro_toast/eyro_toast.dart';

import 'package:bulletter/UI/config_interface.dart' as configUi;
import 'package:bulletter/Config/definitions.dart' as definitions;
import 'package:system_tray/system_tray.dart';

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
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.multiline, // 複数行入力モード
            maxLines: null, // 最大行数
            decoration: const InputDecoration(
              hintText: 'Tweet content',
            ),
            onChanged: (text) {
              inputValue = text;
            },
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
    );
  }
}
