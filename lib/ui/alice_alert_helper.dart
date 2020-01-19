import 'package:flutter/cupertino.dart';

class AliceAlertHelper {
  static void showAlert(BuildContext context, String title, String description,
      {String firstButtonTitle = "Accept",
      String secondButtonTitle,
      Function firstButtonAction,
      Function secondButtonAction}) {
    List<Widget> actions = List();
    if (firstButtonTitle != null) {
      actions.add(CupertinoButton(
        child: Text(firstButtonTitle),
        onPressed: () {
          if (firstButtonAction != null) {
            firstButtonAction();
          }
          Navigator.of(context).pop();
        },
      ));
    }
    if (secondButtonTitle != null) {
      actions.add(CupertinoButton(
        child: Text(secondButtonTitle),
        onPressed: () {
          if (secondButtonAction != null) {
            secondButtonAction();
          }
          Navigator.of(context).pop();
        },
      ));
    }
    showCupertinoDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return CupertinoAlertDialog(
              title: Text(title), content: Text(description), actions: actions);
        });
  }
}
