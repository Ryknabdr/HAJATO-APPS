import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String callbackUrl;

  const PaymentWebViewScreen({
    Key? key,
    required this.paymentUrl,
    required this.callbackUrl,
  }) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  InAppWebViewController? webViewController;
  double progress = 0;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pembayaran Midtrans',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Get.defaultDialog(
              title: "Batalkan Pembayaran?",
              middleText: "Jika Anda keluar sekarang, status transaksi Anda mungkin belum ter-update.",
              textConfirm: "Ya, Keluar",
              textCancel: "Kembali",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () {
                Get.back(); // Tutup dialog konfirmasi
                Get.back(); // Keluar dari WebView
              },
            );
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,          // Aktif untuk form Visa & OTP Bank
              domStorageEnabled: true,          // Simpan session kartu bank
              thirdPartyCookiesEnabled: true,   // Sinkronisasi redirect bank
              useShouldOverrideUrlLoading: true, // Filter URL untuk E-Wallet Deeplink
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onProgressChanged: (controller, progressValue) {
              setState(() {
                progress = progressValue / 100;
                if (progress == 1) {
                  isLoading = false;
                }
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url;
              String urlString = uri.toString();

              // 1. Cek jika link mengarah ke callback URL sukses/finish dari backend lo
              if (urlString.contains(widget.callbackUrl) || 
                  urlString.contains("status_code=200") || 
                  urlString.contains("transaction_status=settlement") ||
                  urlString.contains("transaction_status=capture")) {
                
                Get.back(result: 'SUCCESS'); // Tutup webview dan bawa status sukses
                return NavigationActionPolicy.CANCEL;
              }

              // 2. Cek jika user klik GoPay/ShopeePay/Dana (Skema deeplink bukan http/https)
              if (!["http", "https", "file", "chrome", "data", "javascript"].contains(uri?.scheme)) {
                try {
                  Uri intentUri = Uri.parse(urlString);
                  if (await canLaunchUrl(intentUri)) {
                    await launchUrl(intentUri, mode: LaunchMode.externalApplication);
                    return NavigationActionPolicy.CANCEL;
                  }
                } catch (e) {
                  debugPrint("Gagal memicu e-wallet: $e");
                }
              }

              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
        ],
      ),
    );
  }
}