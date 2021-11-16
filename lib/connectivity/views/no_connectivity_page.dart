import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoConnectivityPage extends StatelessWidget {
  const NoConnectivityPage({Key? key}) : super(key: key);

  static String routeName = 'no-connectivity';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('No Connectivity'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                Icon(
                  Icons.no_cell_outlined,
                  size: 280,
                ),
                Text(
                  "No Connection?!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
