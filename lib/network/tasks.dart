import 'package:flutter/material.dart';
import '../export_feature.dart';

class Task {
  bool isSuccess = false;
  bool isTimeOut = false;
  String msgError = "Unknown Error";

  void copyTask(Task task) {
    this.msgError = task.msgError;
    this.isSuccess = task.isSuccess;
  }

  void showSnackBarTimeOut({required BuildContext context, Function? onRetry}) {
    showSnackBar(context, msgError ,
        isError: true,
        duration: Duration(minutes: 5),
        snackBarAction: SnackBarAction(
          label: 'Retry',
          textColor: Theme.of(context).accentColor,
          onPressed: () => onRetry?.call(),
        ));
  }


}