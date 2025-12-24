import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_app/models/shortcut_item.dart';
import 'package:quick_app/screens/edit_qr_page.dart';
import 'package:quick_app/services/storage_service.dart';
import 'package:quick_app/widgets/qr_action_bottom_sheet.dart';

class FavoriteQr extends StatelessWidget {
  final ShortcutItem shortcut;
  const FavoriteQr ({
    super.key,
    required this.shortcut
  });

  Future<void> handleTap(BuildContext context) async {
    showQRActionSheet(
      context: context,
      shortcut: shortcut,
      onDeleted: () async {
        // Xóa shortcut
        await StorageService.removeShortcut(shortcut.id);
        // Refresh list
      },
      onEdited: () {
        // Navigate to edit page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditQRPage(shortcut: shortcut),
          ),
        );
      },
    );
  } 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleTap(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xff1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xff283447),
            width: 1
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color(0xff283447)
                
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: QrImageView(
                data: shortcut.qrData,
                version: QrVersions.auto,
                size: 100.0,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            SizedBox(height: 8,),
            Text(shortcut.title,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                height: 1,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      )
    );
  }
}