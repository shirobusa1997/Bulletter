import 'dart:html';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:bulletter/UI/config_interface.dart' as configUi;

void main() {
  runApp(MainApp());
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

class Choice {
  const Choice({required this.title});

  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'TWEET'),
  const Choice(title: 'CONFIG'),
];

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Bulletter'),
            bottom: TabBar(
              tabs: choices.map((Choice choice) {
                return Tab(
                  text: choice.title,
                );
              }).toList(),
            ),
            actions: [],
          ),
        ),
      ),
    );
  }
}

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({required Key key, required this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.displayLarge;

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
