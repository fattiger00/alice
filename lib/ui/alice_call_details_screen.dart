import 'package:alice/core/alice_core.dart';
import 'package:alice/model/alice_http_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';

import 'alice_call_error_widger.dart';
import 'alice_call_overview_widget.dart';
import 'alice_call_request_widget.dart';
import 'alice_call_response_widget.dart';

class AliceCallDetailsScreen extends StatefulWidget {
  final AliceHttpCall call;
  final AliceCore core;

  AliceCallDetailsScreen(this.call, this.core);

  @override
  _AliceCallDetailsScreenState createState() => _AliceCallDetailsScreenState();
}

class _AliceCallDetailsScreenState extends State<AliceCallDetailsScreen>
    with SingleTickerProviderStateMixin {
  Widget _previousState;
  int currentSegment = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
        data: CupertinoThemeData(
          brightness: widget.core.brightness,
        ),
        child: StreamBuilder<AliceHttpCall>(
            stream: widget.core.callUpdateSubject,
            initialData: widget.call,
            builder: (context, callSnapshot) {
              if (widget.call.id == callSnapshot.data.id) {
                _previousState = CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    middle: Text('Alice - Details'),
                    trailing: CupertinoButton(
                      key: Key('share_key'),
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      child: Icon(CupertinoIcons.share, size: 26,),
                      onPressed: () {
                        Share.share(_getSharableResponseString(),
                            subject: 'Request Details');
                      },
                    ),
                  ),
                  child: CupertinoTabScaffold(
                    tabBar: CupertinoTabBar(
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.info),
                            title: Text('Overview')),
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.up_arrow),
                            title: Text('Request')),
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.down_arrow),
                            title: Text('Response')),
                        BottomNavigationBarItem(
                            icon: Icon(CupertinoIcons.tags),
                            title: Text('Error')),
                      ],
                    ),
                    tabBuilder: (context, index) {
                      return _getTabBarViewList()[index];
                    },
                  ),
                );
              }
              return _previousState;
            }));
  }

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  String _getSharableResponseString() {
    return '${widget.call.getCallLog()}\n\n${widget.call.getCurlCommand()}';
  }

  List<Widget> _getTabBarViewList() {
    List<Widget> widgets = List();
    widgets.add(AliceCallOverviewWidget(widget.call));
    widgets.add(AliceCallRequestWidget(widget.call));
    widgets.add(AliceCallResponseWidget(widget.call));
    widgets.add(AliceCallErrorWidget(widget.call));
    return widgets;
  }
}
