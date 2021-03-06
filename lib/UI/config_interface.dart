import 'dart:math';

import 'package:bulletter/TwitterAPI/twitter_api_lib.dart';
import 'package:bulletter/UI/main_widget.dart';
import 'package:bulletter/Config/definitions.dart' as definitions;
import 'package:bulletter/UI/provider.dart';
import 'package:eyro_toast/eyro_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:event/event.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

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
            Expanded(
              child: TextField(
                maxLines: null, // wrap text
                autofocus: true, // 自動でTextFieldをフォーカスさせる
                autocorrect: true, // 自動でTextFieldを選択状態にさせる
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Input PIN from Twitter Page',
                ),
                onChanged: (text) {
                  inputValue = text;
                },
              ),
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

class TwitterPINRequestCard extends ChoiceCard {
  TwitterPINRequestCard({Key? key, required Choice choice})
      : super(key: key, choice: choice);

  // PINコードの受け取り
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardProvider(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(definitions.defaultCardPadding),
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    TwitterAPIUtil.instance.requestAuthorize();
                    CardProvider().requestChangeAppState(
                        definitions.EAppState.authorizing);
                  },
                  child: const Text('Request Authorize')),
              TextFormField(
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                autofocus: true,
                autocorrect: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Input PIN Code from Twitter",
                ),
                controller: controller,
              ),
              TextButton(
                  onPressed: !definitions.isAuthorizing()
                      ? null
                      : () async {
                          final pin = controller.text;
                          await EyroToast.showToast(text: 'PINCode : ' + pin);
                          TwitterAPIUtil.instance.authorize(pin);
                        },
                  child: const Text('Authorize')),
              TextButton(
                  onPressed: !definitions.isAuthorizing()
                      ? null
                      : () async {
                          await EyroToast.showToast(text: 'Canceled');
                        },
                  child: const Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }
}
