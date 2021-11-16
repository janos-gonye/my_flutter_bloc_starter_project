import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  static String routeName = 'not-found';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Override default `pop` functionality -> Only matters in browsers.
        // Even if the user navigates to many unknown routes, the back button
        //only needs to be pushed once to return to the last known route.
        Navigator.of(context)
            .popUntil((route) => route.settings.name != routeName);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Not Found'),
        ),
        body: const Center(
          child: SingleChildScrollView(
            child: Text(
              '404?!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
