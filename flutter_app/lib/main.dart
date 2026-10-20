import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const UpEventosApp());

class UpEventosApp extends StatelessWidget {
  const UpEventosApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'UP Eventos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF131315),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF131315),
            foregroundColor: Color(0xFFF2BE8C),
          ),
        ),
        home: const SiteScreen(),
      );
}

class SiteScreen extends StatefulWidget {
  const SiteScreen({super.key});
  @override
  State<SiteScreen> createState() => _SiteScreenState();
}

class _SiteScreenState extends State<SiteScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF131315))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _loading = true),
        onPageFinished: (_) => setState(() => _loading = false),
        onWebResourceError: (e) => debugPrint('WebView: ${e.description}'),
      ))
      ..loadFlutterAsset('assets/web/index.html');
  }

  Future<bool> _back() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _back,
        child: Scaffold(
          body: SafeArea(
            child: Stack(children: [
              WebViewWidget(controller: _controller),
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF2BE8C)),
                ),
            ]),
          ),
        ),
      );
}
