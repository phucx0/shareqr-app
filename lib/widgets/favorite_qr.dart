import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_app/models/qr_item.dart';
import 'package:quick_app/screens/edit_qr_page.dart';
import 'package:quick_app/services/qr_service.dart';
import 'package:quick_app/widgets/qr_action_bottom_sheet.dart';

class FavoriteQr extends StatelessWidget {
  final QRItem qr;
  final double scale; 
  const FavoriteQr ({
    super.key,
    required this.qr,
    this.scale = 1.0
  });

  Future<void> handleTap(BuildContext context) async {
    showQRActionSheet(
      context: context,
      qr: qr,
      onDeleted: () async {
        // Xóa qr
        await QRService.removeQR(qr.id);
        // Refresh list
      },
      onEdited: () {
        // Navigate to edit page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditQRPage(qr: qr),
          ),
        );
      },
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: GestureDetector(
        onTap: () => handleTap(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 16, bottom: 8
          ),
          decoration: BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(0),
                child: QrImageView(
                  data: qr.qrData,
                  version: QrVersions.auto,
                  size: 100, // Fixed size
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                qr.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}