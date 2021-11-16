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
              children: [
                const Icon(
                  Icons.no_cell_outlined,
                  size: 280,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.ac_unit_outlined),
                    SizedBox(width: 10),
                    Text(
                      "No Internet?!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.ac_unit_outlined),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
