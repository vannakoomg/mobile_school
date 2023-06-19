// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PopupNewVersion {
  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: const Text(
              'A new version of ICS APP is available.\nPlease update to version 3.0 now.'),
          actions: <Widget>[
            // TextButton(
            //   style: TextButton.styleFrom(
            //     textStyle: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   child: const Text('REMIND ME LATER'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'UPDATE',
                style: TextStyle(color: Colors.cyan),
              ),
              onPressed: () {
                if (Platform.isAndroid || Platform.isIOS) {
                  final url = Platform.isAndroid
                      ? "https://play.google.com/store/apps/details?id=com.kh.ics.school"
                      : "https://apps.apple.com/kh/app/icsis/id1469492150";
                  customLaunch(url);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }
}
