import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_app/core/theme/app_theme.dart';
import 'package:quick_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:quick_app/services/snackbar_service.dart';
import 'package:quick_app/services/storage_service.dart';
import 'package:quick_app/services/type_service.dart';
import 'package:quick_app/widgets/pick_item.dart';
import '../models/shortcut_item.dart';

class EditQRPage extends StatefulWidget {
  final ShortcutItem shortcut;

  const EditQRPage({super.key, required this.shortcut});

  @override
  State<EditQRPage> createState() => _EditQRPageState();
}

class _EditQRPageState extends State<EditQRPage> {
  late TextEditingController _controller;
  final ImagePicker _picker = ImagePicker();
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.shortcut.qrData);
  }

  @override
  void dispose() {
    _controller.dispose();
    _barcodeScanner.close();
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
                label: 'Thư viện ảnh',
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              PickItem(
                icon: Icons.camera_alt,
                label: 'Chụp ảnh',
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

      final inputImage = InputImage.fromFilePath(image.path);
      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (!mounted) return;

      if (barcodes.isEmpty) {
        SnackbarService.showMessage('Không tìm thấy mã QR trong ảnh', context, isError: true);
        return;
      }

      final qrData = barcodes.first.rawValue;
      if (qrData == null || qrData.isEmpty) {
        SnackbarService.showMessage('Không thể đọc dữ liệu QR', context, isError: true);
        return;
      }

      _controller.text = qrData;
      // _applyAutoDetection(qrData);
      SnackbarService.showMessage('Đã quét thành công!', context);
    } catch (e) {
      if (mounted) {
        SnackbarService.showMessage('Lỗi khi quét ảnh', context, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final type = TypeService.getTypeById(widget.shortcut.typeId);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.commonEdit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                                // color: widget.shortcut.typeBadgeColor.withOpacity(0.3),
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
                            eyeStyle: QrEyeStyle(
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
                                  widget.shortcut.type!.icon!,
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
                                    widget.shortcut.title,
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
                          const Text(
                            'QR Code Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                            label: Text(_isScanning ? 'Đang quét...' : 'Từ ảnh', 
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
                        readOnly: widget.shortcut.appKey.toLowerCase() == "bank",
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter QR code data...',
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
                              // color: widget.shortcut.typeBadgeColor,
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
                await StorageService.updateQRData(_controller.text, widget.shortcut);
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