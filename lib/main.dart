import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:nativeshell/nativeshell.dart';

import 'package:bulletter/UI/config_interface.dart' as configUi;

void main(List<String> args) async {
  disableShaderWarmUp();

  runApp(MainApp());
}

class CommonWindow extends StatelessWidget {
  const CommonWindow({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        child: WindowLayoutProbe(child: child),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MyHomePageState(title: ''));
  }
}

class MyHomePageState extends StatefulWidget {
  const MyHomePageState({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageState> {
  int _counter = 0;

  Window? otherWindow;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoge'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: otherWindow == null
          ? FloatingActionButton(
              onPressed: () async {
                final widnow = await Window.create(
                    configUi.TwitterAuthorizationWindowState.toInitData());
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () async {
                final widnow = await Window.create(
                    configUi.TwitterAuthorizationWindowState.toInitData());
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
    );
  }

  @override
  // TODO: implement windowSizingMode
  WindowSizingMode get windowSizingMode => throw UnimplementedError();
}
