import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NescoInAppWebViewScreen extends StatefulWidget {
  final String customerId;
  final String url;
  final String title;

  const NescoInAppWebViewScreen({
    super.key,
    required this.customerId,
    this.url = "https://customer.nesco.gov.bd/post/bill",
    this.title = "Bill Portal",
  });

  @override
  State<NescoInAppWebViewScreen> createState() => _NescoInAppWebViewScreenState();
}

class _NescoInAppWebViewScreenState extends State<NescoInAppWebViewScreen> {
  bool _isLoading = true;
  bool get _isNesco => widget.url.contains('customer.nesco.gov.bd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(widget.url),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
              userAgent: "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.6099.230 Mobile Safari/537.36",
            ),
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });

              if (!_isNesco) return;

              final String jsAutofillScript = '''
                (function() {
                  var input = document.getElementById('cust_no');
                  if (input) {
                    input.value = "${widget.customerId}";
                    var inputEvent = new Event('input', { bubbles: true });
                    input.dispatchEvent(inputEvent);

                    setTimeout(function() {
                      var submits = document.querySelectorAll('input[type=submit]');
                      for (var j = 0; j < submits.length; j++) {
                        if (submits[j].value.includes('বকেয়া') || submits[j].value.includes('রিচার্জ') || submits[j].value.includes('Usage')) {
                          submits[j].click();
                          break;
                        }
                      }
                    }, 300);
                  }
                })();
              ''';

              await controller.evaluateJavascript(source: jsAutofillScript);
            },
          ),

          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ),
        ],
      ),
    );
  }
}
