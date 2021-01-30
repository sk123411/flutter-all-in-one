import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeItem extends StatefulWidget {
  final String url;
  final String title;

  HomeItem({Key key, this.url, this.title}) : super(key: key);

  @override
  _HomeItemState createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
  WebViewController webviewKey;

  @override
  Widget build(BuildContext context) {
    print(widget.url);

    return WillPopScope(
      onWillPop: _handleBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          onWebViewCreated: (controlller) {
            webviewKey = controlller;
          },
        ),
      ),
    );
  }

  Future<bool> _handleBackPressed() async {
    var goBack=false;
    var value = await webviewKey.canGoBack();

    if (value) {
      webviewKey.goBack();
      return false;
    } else {
      await showDialog(
          context: (context),
          builder: (_) => AlertDialog(
                title: Text("Are you sure?"),
                content: Text("Do you want to exit from ${widget.title}"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      
                      setState(() {
                        goBack=true;
                      });

                      },
                      child: Text("Yes")),
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("No"))
                ],
              ));

             if(goBack) Navigator.pop(context);

      return goBack;
    }
  }
}
