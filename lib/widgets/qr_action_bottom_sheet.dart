import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_app/core/theme/app_theme.dart';
import 'package:quick_app/l10n/l10n.dart';
import 'package:quick_app/services/snackbar_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quick_app/models/qr_item.dart';
import 'package:quick_app/services/favorite_qr_service.dart';

class QRActionBottomSheet extends StatefulWidget {
  final QRItem qr;
  final VoidCallback? onDeleted;
  final VoidCallback? onEdited;

  const QRActionBottomSheet({
    super.key,
    required this.qr,
    this.onDeleted,
    this.onEdited,
  });

  @override
  State<QRActionBottomSheet> createState() => _QRActionBottomSheetState();
}

class _QRActionBottomSheetState extends State<QRActionBottomSheet> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoriteQRService.isFavorite(widget.qr.id);
  }

  Future<void> _toggleFavorite() async {
    try {
      if (isFavorite) {
        await FavoriteQRService.deleteFavoriteByQRId(widget.qr.id);
      } else {
        await FavoriteQRService.addFavorite(
          shortcutId: widget.qr.id,
          note: widget.qr.description.isNotEmpty 
              ? widget.qr.description 
              : null,
        );
      }
      
      setState(() {
        isFavorite = !isFavorite;
      });
      
      if (mounted) {
        HapticFeedback.lightImpact();
        SnackbarService.showMessage(
          isFavorite ? l10n.addedToFavorites : l10n.removedFromFavorites, 
          context
        );
      }
    } catch (e) {
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Lỗi: ${e.toString()}')),
        // );
      }
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.qr.qrData));

    SnackbarService.showMessage(
      l10n.copied,
      context
    );
  }

  void _shareQR() {
    // Share QR data as text
    Share.share(
      widget.qr.qrData,
      subject: widget.qr.title,
    );
  }

  void _editQR() {
    Navigator.pop(context);
    widget.onEdited?.call();
  }

  Future<void> _deleteQR() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              l10n.deleteQrTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.qrDeletePermanent,
          style: TextStyle(color: Colors.white70),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Navigator.pop(context);
      widget.onDeleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header with favorite and close
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.qr.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // const SizedBox(height: 4),
                        Text(
                          widget.qr.getType!.getName(context),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Favorite Button
                  Material(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: _toggleFavorite,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.amber : Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Close Button
                  Material(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // QR Code
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 56),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).focusColor,
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: QrImageView(
                data: widget.qr.qrData,
                version: QrVersions.auto,
                size: 250,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.contentQR,
                    style: TextStyle( 
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                        color: AppTheme.medium,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      maxLines: 2,
                      widget.qr.qrData,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.commonQuickAction,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    // color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.share,
                    label: l10n.commonShare,
                    color: const Color.fromARGB(255, 44, 111, 255),
                    onTap: _shareQR,
                  ),
                  _ActionButton(
                    icon: Icons.copy,
                    label: l10n.commonCopy,
                    color: const Color.fromARGB(255, 3, 201, 125),
                    onTap: _copyToClipboard,
                  ),
                  _ActionButton(
                    icon: Icons.edit,
                    label: l10n.commonEdit,
                    color: const Color.fromARGB(255, 247, 150, 4),
                    onTap: _editQR,
                  ),
                  _ActionButton(
                    icon: Icons.delete,
                    label: l10n.commonDelete,
                    color: Colors.redAccent,
                    onTap: _deleteQR,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

// Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            // color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Helper function to show the bottom sheet
void showQRActionSheet({
  required BuildContext context,
  required QRItem qr,
  VoidCallback? onDeleted,
  VoidCallback? onEdited,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => QRActionBottomSheet(
      qr: qr,
      onDeleted: onDeleted,
      onEdited: onEdited,
    ),
  );
}