import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';

class GlobalMethods {
  Future<void> showDialogg(
      String title, String subtitle, Function fct, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.network(
                    'https://image.flaticon.com/icons/png/128/564/564619.png',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: PrimaryText(
                    text: title,
                  ),
                )
              ],
            ),
            content: PrimaryText(text: subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: PrimaryText(
                    text: 'Cancel',
                  )),
              TextButton(
                  onPressed: () {
                    fct();
                    Navigator.pop(context);
                  },
                  child: PrimaryText(
                    text: 'Okay',
                  ))
            ],
          );
        });
  }

  Future<void> authErroHandle(String subtitle, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.network(
                    '',
                    height: 20,
                    width: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: PrimaryText(
                    text: 'Error!',
                  ),
                )
              ],
            ),
            content: PrimaryText(text: subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: PrimaryText(
                    text: 'Okay',
                  ))
            ],
          );
        });
  }
}
