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
    return MaterialApp(
      home: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 14),
        child: WindowWidget(
          onCreateState: (initData) {
            WindowState? state;

            state ??=
                configUi.TwitterPINRequestWindowState.fromInitData(initData);
            state ??= configUi.ConfigWindowState();

            return state;
          },
        ),
      ),
    );
  }
}

// class MyHomePageState extends WindowState {
//   int _counter = 0;

//   Window? otherWindow;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Hoge'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: otherWindow == null
//           ? FloatingActionButton(
//               onPressed: () async {
//                 final window = await Window.create(
//                     configUi.TwitterAuthorizationWindowState.toInitData());
//               },
//               tooltip: 'Increment',
//               child: const Icon(Icons.add),
//             )
//           : FloatingActionButton(
//               onPressed: () async {
//                 await otherWindow!.close();
//               },
//               tooltip: 'Increment',
//               child: const Icon(Icons.add),
//             ),
//     );
//   }

//   @override
//   // TODO: implement windowSizingMode
//   WindowSizingMode get windowSizingMode => throw UnimplementedError();
// }