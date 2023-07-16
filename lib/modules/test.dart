import 'package:flutter/material.dart';

class TestYYYY extends StatelessWidget {
  const TestYYYY({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController texyEditController = TextEditingController();
    return Scaffold(
      body: Container(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            TextField(
              autofocus: true,
              controller: texyEditController,
              onChanged: (value) {},
              readOnly: false,
              onEditingComplete: () {
                debugPrint("fsfsafsaf");
              },
            ),
          ],
        ),
      )),
    );
  }
}
