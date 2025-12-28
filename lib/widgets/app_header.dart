import 'package:flutter/material.dart';
import 'package:quick_app/screens/add_qr_page.dart';
import 'package:quick_app/screens/qr_scanner_screen.dart';
import 'package:quick_app/screens/setting_page.dart';

class AppHeader extends StatelessWidget {
  // final VoidCallback onSettingsTap;

  const AppHeader({
    super.key, 
    // required this.onSettingsTap
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'ShareQR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          spacing: 0,
          children: [
            IconButton(
              padding: EdgeInsets.all(0),
              icon: const Icon(
                Icons.qr_code_scanner, 
                size: 24,
              ),
              onPressed: () async {
                // Bước 1: Mở màn hình quét QR
                final qrData = await Navigator.push<String>(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => QRScannerScreen(
                      onQRDetected: (String data) {
                        // Return data về màn hình trước
                        Navigator.pop(context, data);
                      },
                    ),
                  ),
                );
                
                // Bước 2: Nếu có QR data, mở AddQRScreen với data đó
                if (qrData != null && qrData.isNotEmpty) {
                  if (context.mounted) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddQRScreen(
                          initialQRData: qrData,
                        ),
                      ),
                    );
                  }
                }
              }
            ),
            IconButton(
              icon: const Icon(
                Icons.settings, 
                size: 24,
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}