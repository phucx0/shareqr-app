import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_app/l10n/l10n.dart';
import 'package:quick_app/core/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:quick_app/models/qr_enum.dart';
import 'package:quick_app/services/snackbar_service.dart';
import 'package:quick_app/services/qr_service.dart';
import 'package:quick_app/services/type_service.dart';
import 'package:quick_app/widgets/pick_item.dart';
import '../models/qr_item.dart';

class EditQRPage extends StatefulWidget {
  final QRItem qr;

  const EditQRPage({super.key, required this.qr});

  @override
  State<EditQRPage> createState() => _EditQRPageState();
}

class _EditQRPageState extends State<EditQRPage> {
  late TextEditingController _controller;
  final ImagePicker _picker = ImagePicker();
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.qr.qrData);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<ImageSource?> _selectImageSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PickItem(
                icon: Icons.photo_library,
                label: l10n.imageGallery,
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              PickItem(
                icon: Icons.camera_alt,
                label: l10n.takePhoto,
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndScanImage() async {
    try {
      // 1. Chọn nguồn ảnh
      final source = await _selectImageSource();
      if (source == null) return;

      // 2. Pick ảnh
      final image = await _picker.pickImage(source: source);
      if (image == null) return;

      if (!mounted) return;

      // 3. Bắt đầu scan
      setState(() => _isScanning = true);

      // 4. Scan ảnh bằng mobile_scanner
      final result = await _scannerController.analyzeImage(image.path);

      if (!mounted) return;

      if (result == null || result.barcodes.isEmpty) {
        SnackbarService.showMessage(l10n.noQRFoundInImage, context, isError: true);
        return;
      }

      final qrData = result.barcodes.first.rawValue;
      if (qrData == null || qrData.isEmpty) {
        SnackbarService.showMessage(l10n.cannotReadQRData, context, isError: true);
        return;
      }

      _controller.text = qrData;
      SnackbarService.showMessage(l10n.scanSuccess, context);
    } catch (e) {
      if (mounted) {
        SnackbarService.showMessage(l10n.scanImageError, context, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = TypeService.getTypeById(widget.qr.type);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.commonEdit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: _controller.text.isEmpty 
                                ? 'Empty Data' 
                                : _controller.text,
                            version: QrVersions.auto,
                            size: 200.0,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Type info card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.dark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.medium,
                            width: 1
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              child: Center(
                                child: SvgPicture.asset(
                                  width: 30,
                                  height: 30,
                                  widget.qr.getType!.icon.toString(),
                                  fit: BoxFit.cover,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.qr.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    type.getName(context),
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.contentQR,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _isScanning ? null : _pickAndScanImage,
                            icon: _isScanning
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.image, size: 14),
                            label: Text(_isScanning ? l10n.scanning : l10n.fromImage, 
                              style: TextStyle(
                                fontSize: 14
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff3782FD),
                              foregroundColor: Color(0xffFFFFFF),
                              minimumSize: Size.zero,     
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      TextField(
                        controller: _controller,
                        maxLines: 1,
                        readOnly: widget.qr.type == QrType.payment,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: l10n.enterQRName,
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF1E293B),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await QRService.updateQRData(_controller.text, widget.qr);
                Navigator.pop(context, _controller.text);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Text(
              l10n.commonSaveChanges,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}