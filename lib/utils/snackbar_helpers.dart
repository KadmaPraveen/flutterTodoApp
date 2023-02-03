import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showErrorMessage_global(BuildContext context,
 {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor:Colors.red,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessMessage_global(BuildContext context,
 {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
