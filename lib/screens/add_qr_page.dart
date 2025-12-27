import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_app/l10n/l10n.dart';
import 'package:quick_app/models/qr_enum.dart';
import 'package:quick_app/models/qr_item.dart';
import 'package:quick_app/models/qr_type.dart';
import 'package:quick_app/screens/qr_scanner_screen.dart';
import 'package:quick_app/services/qr_detector.dart';
import 'package:quick_app/services/snackbar_service.dart';
import 'package:quick_app/services/qr_service.dart';
import 'package:quick_app/services/type_service.dart';
import 'package:quick_app/widgets/pick_item.dart';
import 'package:quick_app/widgets/qr_type_grid.dart';
import 'package:quick_app/widgets/top_snack_bar.dart';
import 'package:uuid/uuid.dart';

class AddQRScreen extends StatefulWidget {
  final String? initialQRData;
  const AddQRScreen({
    Key? key,
    this.initialQRData
  }) : super(key: key);

  @override
  State<AddQRScreen> createState() => _AddQRScreenState();
}

class _AddQRScreenState extends State<AddQRScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController();
  late List<QrTypeModel> qrTypes;
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;

  QrType? selectedQRType;
  String? selectedIcon;
  bool _autoDetected = false;

  @override
  void initState() {
    super.initState();
    _scannerController.dispose();
    qrTypes = TypeService.getAllTypes();

    // Sort theo enum → ổn định, không phụ thuộc ngôn ngữ
    qrTypes.sort((a, b) => a.type.index.compareTo(b.type.index));

    selectedQRType = qrTypes[0].type;

    // Nếu có initialQRData, điền vào và auto-detect
    if (widget.initialQRData != null && widget.initialQRData!.isNotEmpty) {
      _qrCodeController.text = widget.initialQRData!;
      // Delay một chút để UI render xong
      Future.delayed(Duration.zero, () {
        _applyAutoDetection(widget.initialQRData!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qrCodeController.dispose();
    super.dispose();
  }

  String getDomainName(String url) {
    final uri = Uri.parse(url);
    final host = uri.host.replaceFirst('www.', '');
    return host.split('.').first;
  }



  // Tự động phát hiện loại QR code
  QrType _detectQRType(String qrData) {
    final lowerData = qrData.toLowerCase();
    final qrtype = QrDetector.detectQR(qrData);

    switch (qrtype) {
      case QrType.social:
        String newName = getDomainName(lowerData);
        if(_nameController.text.isEmpty || _nameController.text != newName) _nameController.text = newName;
        return QrType.social;

      case QrType.url:
        String newName = getDomainName(lowerData);
        if(_nameController.text.isEmpty || _nameController.text != newName) _nameController.text = newName;
        return QrType.url;

      case QrType.messenger:
        String newName = getDomainName(lowerData);
        if(_nameController.text.isEmpty || _nameController.text != newName) _nameController.text = newName;
        return QrType.messenger;

      default:
        break;
    }
    return qrtype;
  }

  void _applyAutoDetection(String qrData) {
    final detectedTypeId = _detectQRType(qrData);
    
    // Tìm platform tương ứng
    final matchedPlatform = qrTypes.firstWhere(
      (p) => p.type == detectedTypeId,
      orElse: () => qrTypes.firstWhere(
        (p) => p.name.toLowerCase() == 'link',
        orElse: () => qrTypes[0],
      ),
    );
    
    setState(() {
      selectedQRType = matchedPlatform.type;
      _autoDetected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    'QR',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _handleSave,
                    child: Text(
                      l10n.commonSave,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // QR Code Preview
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: _qrCodeController.text.isNotEmpty
                            ? QrImageView(
                                data: _qrCodeController.text,
                                version: QrVersions.auto,
                                size: 240,
                              )
                            : Container(
                                width: 240,
                                height: 240,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.qr_code,
                                  size: 120,
                                  color: Colors.grey[400],
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Tên phím tắt
                      Text(
                        l10n.nameQR,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: l10n.enterQRName,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Mã QR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.contentQR,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              // Nút quét QR realtime
                              GestureDetector(
                                onTap: _openQRScanner,
                                child: const Icon(Icons.qr_code_scanner, size: 24),
                              ),
                              const SizedBox(width: 8),
                              // Nút load từ ảnh
                              GestureDetector(
                                onTap: _isScanning ? null : _pickAndScanImage,
                                child: const Icon(Icons.image, size: 24),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        maxLines: 1,
                        controller: _qrCodeController,
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (value) {
                          _applyAutoDetection(value);
                        },
                        decoration: InputDecoration(
                          hintText: l10n.enterQRContent,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.content_paste, color: Colors.white54, size: 20),
                            onPressed: _pasteFromClipboard,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.warningContentQR,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Chọn nền tảng
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.selectPlatform,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_autoDetected)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFF10B981).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome, size: 14, color: Color(0xFF10B981)),
                                  SizedBox(width: 4),
                                  Text(
                                    l10n.autoDetect,
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      QrTypeGrid(
                        QRTypes: qrTypes,
                        onTap: (index) {
                          setState(() {
                            selectedQRType = qrTypes[index].type;
                            _autoDetected = false;
                          });
                        },
                        selectedType: selectedQRType ?? QrType.text,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _qrCodeController.text = clipboardData.text!;
      });
      _applyAutoDetection(clipboardData.text!);
    }
  }

  Future<void> _handleSave() async {
    if (_nameController.text.isEmpty) {
      SnackbarService.showMessage(l10n.pleaseEnterQRName, context, isError: true);
      return;
    }
    
    if (_qrCodeController.text.isEmpty) {
      SnackbarService.showMessage(l10n.pleaseEnterQRContent, context, isError: true);
      return;
    }

    if (selectedQRType == null) {
      SnackbarService.showMessage(l10n.pleaseSelectPlatform, context, isError: true);
      return;
    }

    final uuid = Uuid();
    final qr = QRItem(
      id: uuid.v4(),
      title: _nameController.text,
      colorValue: 1,
      qrData: _qrCodeController.text,
      position: 0,
      type: selectedQRType!,
      appKey: selectedIcon ?? selectedQRType!.toString(),
    );

    await QRService.addQR(qr);
    if(mounted) {
      Navigator.pop(context);
    }
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

      _qrCodeController.text = qrData;
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

  // Mở màn hình quét QR realtime
  void _openQRScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          onQRDetected: (String qrData) {
            setState(() {
              _qrCodeController.text = qrData;
            });
            _applyAutoDetection(qrData);
            _showMessage(l10n.scanSuccess);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => TopSnackBar(
        message: message,
        isError: isError,
        onDismiss: () => overlayEntry.remove(),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    // Auto dismiss sau 3 giây
    Future.delayed(const Duration(seconds: 10), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
