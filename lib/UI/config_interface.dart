import 'package:flutter/cupertino.dart';

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
