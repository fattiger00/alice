import 'package:alice/model/alice_menu_item.dart';
import 'package:alice/ui/alice_call_details_screen.dart';
import 'package:alice/core/alice_core.dart';
import 'package:alice/model/alice_http_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Theme, ThemeData;

import 'alice_alert_helper.dart';
import 'alice_call_list_item.dart';
import 'alice_stats_screen.dart';

class AliceCallsListScreen extends StatefulWidget {
  final AliceCore _aliceCore;

  AliceCallsListScreen(this._aliceCore);

  @override
  _AliceCallsListScreenState createState() => _AliceCallsListScreenState();
}

class _AliceCallsListScreenState extends State<AliceCallsListScreen> {
  List<AliceMenuItem> _menuItems = List();

  _AliceCallsListScreenState() {
    _menuItems.add(AliceMenuItem("Delete", Icons.delete));
    _menuItems.add(AliceMenuItem("Stats", Icons.insert_chart));
    _menuItems.add(AliceMenuItem("Save", Icons.save));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: widget._aliceCore.brightness,
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: widget._aliceCore.brightness,
        ),
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Alice - Calls"),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            child: Icon(
              CupertinoIcons.ellipsis,
              size: 30,
            ),
            onPressed: () {
              showCupertinoModalPopup(context: context, builder: _buildMenu);
            },
          ),
        ),
        child: Builder(
          builder: (context) {
            print(CupertinoTheme.brightnessOf(context));
            return Container(
              color: CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.white,
                darkColor: CupertinoColors.darkBackgroundGray,
              ).resolveFrom(context),
              // color: CupertinoColors.darkBackgroundGray,
              child: _getCallsList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Delete'),
          onPressed: () {
            Navigator.pop(context);
            _showRemoveDialog();
          },
        ),
        CupertinoActionSheetAction(
            child: Text('Stats'),
            onPressed: () {
              Navigator.pop(context);
              _showStatsScreen();
            }),
        CupertinoActionSheetAction(
          child: Text('Save'),
          onPressed: () {
            Navigator.pop(context);
            _saveToFile();
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('Cancel'),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _getCallsList() {
    return StreamBuilder(
        stream: widget._aliceCore.changesSubject.stream,
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (widget._aliceCore.calls.length == 0) {
            return Container(
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: CupertinoColors.activeOrange,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          "There are no calls to show",
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          "You have not send any http call or your Alice configuration is invalid.",
                          style: TextStyle(fontSize: 12),
                        )
                      ]),
                ));
          } else {
            return CupertinoScrollbar(
              child: ListView(
                children: _getListElements(),
              ),
            );
          }
        });
  }

  _getListElements() {
    List<Widget> widgets = List();
    widget._aliceCore.calls.forEach((AliceHttpCall call) {
      widgets.add(AliceCallListItem(call, _onListItemClicked));
    });
    return widgets;
  }

  void _onListItemClicked(AliceHttpCall call) {
    Navigator.push(
      widget._aliceCore.getContext(),
      CupertinoPageRoute(
        builder: (context) => AliceCallDetailsScreen(call, widget._aliceCore),
      ),
    );
  }

  void _showRemoveDialog() {
    AliceAlertHelper.showAlert(
        context, "Delete calls", "Do you want to delete http calls?",
        firstButtonTitle: "No",
        firstButtonAction: () => {},
        secondButtonTitle: "Yes",
        secondButtonAction: () => _removeCalls());
  }

  void _removeCalls() {
    widget._aliceCore.removeCalls();
  }

  void _showStatsScreen() {
    Navigator.push(
      widget._aliceCore.getContext(),
      CupertinoPageRoute(
        builder: (context) => AliceStatsScreen(widget._aliceCore),
      ),
    );
  }

  void _saveToFile() async {
    widget._aliceCore.saveHttpRequests(context);
  }
}
