import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kangaroom/generated/l10n.dart';
import 'package:kangaroom/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  late WebViewController _webViewController;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(
          color: colorWhite,
        ),
        title: Text(
          S.of(context).chatbot,
          style: titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse('https://chatbot-w0kq.onrender.com/'))
              ..setNavigationDelegate(
                NavigationDelegate(
                  onPageStarted: (url) {
                    setState(() {
                      isLoading = true; // Show the loading indicator
                    });
                  },
                  onPageFinished: (url) async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    setState(() {
                      isLoading = false; // Hide the loading indicator
                    });
                  },
                ),
              ),
          ),
          if (isLoading)
            Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ), // Loading indicator
            ),
        ],
      ),
    );
  }
}
