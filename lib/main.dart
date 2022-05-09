import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:system_tray/system_tray.dart';
import 'package:eyro_toast/eyro_toast.dart';

import 'package:bulletter/UI/config_interface.dart' as configUi;
import 'package:bulletter/Config/definitions.dart' as definitions;

import 'package:bulletter/UI/main_widget.dart';

void main() {
  // Flutter アプリ本体前に Flutter エンジンを用いる処理を実行できるように設定
  WidgetsFlutterBinding.ensureInitialized();

  // [DEBUG] トースト通知が発行できるように設定
  EyroToastSetup.shared.navigatorKey = GlobalKey<NavigatorState>();

  // Flutter アプリ本体を実行
  runApp(MainApp());

  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = win.size = definitions.initialSize;
    win.alignment = Alignment.center;
    win.title = definitions.appTitle;
  });
}

class CommonWindow extends StatelessWidget {
  const CommonWindow({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

const List<Choice> choices = <Choice>[
  Choice(title: 'TWEET'),
  Choice(title: 'YOUR TWEET'),
  Choice(title: 'CONFIG'),
];

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: definitions.appTitle,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainAppPage(
        title: '',
      ),
    );
  }
}

class MainAppPage extends StatefulWidget {
  const MainAppPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => MainAppState();
}

class MainAppState extends State<MainAppPage> {
  // システムトレイのインスタンス
  final SystemTray systemTray = SystemTray();
  // アプリ本体ウィンドウのインスタンス
  final AppWindow appWindow = AppWindow();

  Future<void> initSystemTray() async {
    await systemTray.initSystemTray(
      title: 'Bulletter',
      iconPath: Platform.isWindows
          ? definitions.appIconPath
          : definitions.appImagePath,
      toolTip: "Bulletter",
    );

    systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == "leftMouseDown") {
      } else if (eventName == "leftMouseUp") {
        appWindow.show();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    initSystemTray();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: EyroToastSetup.shared.navigatorKey,
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: choices.map((Choice choice) {
                return Tab(
                  text: choice.title,
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: choices.map((Choice choice) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: createCardContent(choice),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  ChoiceCard createCardContent(Choice choice) {
    switch (choice.title) {
      case 'TWEET':
        return TweetCard(choice: choice);
      case 'YOUR TWEET':
      case 'CONFIG':
      default:
        return ChoiceCard(choice: choice);
    }
  }
}
