import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_app/screens/search_page.dart';
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
            SizedBox(
              child: Center(
                child: SvgPicture.asset(
                  width: 36,
                  height: 36,
                  "assets/svg/icon.svg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text(
              'ShareQR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                // color: Color(0xffFF5722),
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF1F2937),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: IconButton(
            //     icon: const Icon(Icons.search, color: Colors.white),
            //     onPressed: () async {
            //       await Navigator.push(
            //         context, 
            //         MaterialPageRoute(
            //           builder: (context) => SearchShortcutPage()
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}