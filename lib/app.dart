import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyStartProjectApp extends StatelessWidget {
  const MyStartProjectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        return const Scaffold(
          body: Center(
            child: Text('Hello world'),
          ),
        );
      },
    );
  }
}
