import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

void showalert(BuildContext context, String warning) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Something is missing...", style: TextStyle(fontSize: 18)),
        content: Text(
          warning,
          style: TextStyle(fontSize: 15),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void quickalert(
    BuildContext context, String name, QuickAlertType quickAlertType) {
  QuickAlert.show(
      context: context,
      type: quickAlertType,
      text: name,
      autoCloseDuration: const Duration(seconds: 3),
      showConfirmBtn: true);
}

// alert dialog box for delete task
void alertdialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Are you sure, you want to delete ?",
            style: TextStyle(fontSize: 18)),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              // await deleteUser(docIds[index]);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
