
import 'package:flutter/material.dart';

import 'package:event/event.dart';


class BulletterPINArgs extends EventArgs {
  String inputValue;
  BulletterPINArgs(this.inputValue);
}

class TwitterPINRequestWindowState extends StatelessWidget {
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
}
