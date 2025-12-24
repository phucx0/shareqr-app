import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quick_app/models/shortcut_item.dart';
import 'package:quick_app/services/snackbar_service.dart';
import 'package:quick_app/services/storage_service.dart';
import 'package:quick_app/services/type_service.dart';
import 'package:quick_app/widgets/pick_item.dart';
import 'package:quick_app/widgets/top_snack_bar.dart';

class AddQRScreen extends StatefulWidget {
  const AddQRScreen({Key? key}) : super(key: key);

  @override
  State<AddQRScreen> createState() => _AddQRScreenState();
}

class _AddQRScreenState extends State<AddQRScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();
  final platforms = TypeService.getAllTypes();
  final ImagePicker _picker = ImagePicker();
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isScanning = false;

  String? selectedPlatform;
  String? selectedIcon;
  bool _autoDetected = false;
  
  // Danh sách biểu tượng
  final List<Map<String, dynamic>> icons = [
    {'id': 'bank', 'name': 'Bank', 'icon': Icons.account_balance, 'color': Color(0xFF3782FD)},
    {'id': 'social', 'name': 'Social', 'icon': Icons.public, 'color': Color(0xFF64748B)},
    {'id': 'link', 'name': 'Link', 'icon': Icons.link, 'color': Color(0xFF10B981)},
    {'id': 'qr', 'name': 'QR Code', 'icon': Icons.qr_code_2, 'color': Color(0xFFF59E0B)},
    {'id': 'payment', 'name': 'Payment', 'icon': Icons.payment, 'color': Color(0xFFEF4444)},
  ];

  @override
  void initState() {
    super.initState();
    selectedPlatform = platforms[0].id;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qrCodeController.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  // Tự động phát hiện loại QR code
  String _detectQRType(String qrData) {
    final lowerData = qrData.toLowerCase();
    
    // Bank QR patterns
    if (qrData.contains('00020101') || 
        qrData.contains('0002010102') ||
        lowerData.contains('napas') ||
        lowerData.contains('vnpay') ||
        lowerData.contains('momo') ||
        lowerData.contains('zalopay') ||
        (lowerData.contains('bank') && qrData.length > 50)) {
      return '0'; // Bank
    }
    
    if (lowerData.startsWith('bitcoin:') ||
        lowerData.startsWith('ethereum:') ||
        lowerData.startsWith('btc:') ||
        lowerData.startsWith('eth:') ||
        lowerData.contains('blockchain.com') ||
        lowerData.contains('coinbase.com') ||
        lowerData.contains('binance.com') ||
        // Bitcoin address patterns
        (qrData.startsWith('1') && qrData.length >= 26 && qrData.length <= 35) ||
        (qrData.startsWith('3') && qrData.length >= 26 && qrData.length <= 35) ||
        (qrData.toLowerCase().startsWith('bc1') && qrData.length >= 26)) {
      return '1'; // Crypto
    }

    // Social media patterns (ID: 2)
    if (lowerData.contains('facebook.com') || lowerData.contains('fb.com') ||
        lowerData.contains('fb.me') ||
        lowerData.contains('instagram.com') || 
        lowerData.contains('twitter.com') || lowerData.contains('x.com') ||
        lowerData.contains('linkedin.com') ||
        lowerData.contains('tiktok.com') ||
        lowerData.contains('youtube.com') || lowerData.contains('youtu.be') ||
        lowerData.contains('threads.net') ||
        lowerData.contains('snapchat.com') ||
        lowerData.contains('pinterest.com') ||
        lowerData.contains('reddit.com')) {
      return '2'; // Social
    }
    
    // Messaging apps (ID: 3)
    if (lowerData.contains('zalo.me') || lowerData.contains('zalo://') ||
        lowerData.contains('t.me') || lowerData.contains('telegram.me') ||
        lowerData.contains('wa.me') || lowerData.contains('whatsapp.com') ||
        lowerData.contains('viber://') ||
        lowerData.contains('line.me')) {
      return '3'; // Messenger
    }
    
    if (lowerData.startsWith('mailto:') ||
        RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(qrData)) {
      return '4';
    }

    // Phone (ID: 5)
    if (lowerData.startsWith('tel:') ||
        RegExp(r'^(\+84|0)\d{9,10}$').hasMatch(qrData.replaceAll(' ', ''))) {
      return '5';
    }
    if (qrData.startsWith('WIFI:')) {
      return '6';
    }
    // Default to link if it's a URL
    if (lowerData.startsWith('http://') || 
        lowerData.startsWith('https://') || 
        lowerData.contains('www.')) {
      return '10';
    }

    // Default
    return '10';
  }

  void _applyAutoDetection(String qrData) {
    final detectedTypeId = _detectQRType(qrData);
    
    // Tìm platform tương ứng
    final matchedPlatform = platforms.firstWhere(
      (p) => p.id == detectedTypeId,
      orElse: () => platforms.firstWhere(
        (p) => p.name.toLowerCase() == 'link',
        orElse: () => platforms[0],
      ),
    );
    
    setState(() {
      selectedPlatform = matchedPlatform.id;
      _autoDetected = true;
    });
    
    // Show notification
    _showMessage('Đã tự động phát hiện: ${matchedPlatform.getName(context)}');
  }

  @override
  Widget build(BuildContext context) {
    final isBankType = TypeService.getTypeById(selectedPlatform!).name.toLowerCase() == "payment";
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tạo QR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: const Text(
              'Lưu',
              style: TextStyle(
                color: Color(0xFF3782FD),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
              const Text(
                'Tên mã QR',
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
                  hintText: 'Đặt tên',
                ),
              ),
              const SizedBox(height: 24),
              // Mã QR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mã QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Button to scan from image - hiện với mọi loại nhưng bắt buộc với Bank
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
                maxLines: 1,
                controller: _qrCodeController,
                style: const TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  setState(() {});
                  if (value.isNotEmpty && !isBankType) {
                    _applyAutoDetection(value);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Dán mã QR hoặc link',
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
                        'Với QR thanh toán, vui lòng tải ảnh QR lên',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Chọn nền tảng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chọn nền tảng',
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
                            'Tự động',
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
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: platforms.length,
                  itemBuilder: (context, index) {
                    final platform = platforms[index];
                    final isSelected = selectedPlatform == platform.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPlatform = platform.id;
                          _autoDetected = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF3782FD) : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1,
                                  color: Color(isSelected ? 0xff006FFF : 0xff283447)
                                )
                              ),
                              child: SizedBox(
                                child: Center(
                                  child: SvgPicture.asset(
                                    width: 24,
                                    height: 24,
                                    platform.icon!,
                                    fit: BoxFit.cover,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              )
                            ),
                            const SizedBox(height: 8),
                            Text(
                              platform.getName(context),
                              maxLines: 2,
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF3782FD) : Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
      _showMessage('Đã dán từ clipboard');
    }
  }

  Future<void> _handleSave() async {
    if (_nameController.text.isEmpty) {
      SnackbarService.showMessage('Vui lòng nhập tên QR', context);
      return;
    }
    
    if (_qrCodeController.text.isEmpty) {
      SnackbarService.showMessage('Vui lòng nhập mã QR', context);
      return;
    }

    if (selectedPlatform == null) {
      SnackbarService.showMessage('Vui lòng chọn nền tảng', context);
      return;
    }

    final shortcut = ShortcutItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _nameController.text,
      colorValue: 1,
      qrData: _qrCodeController.text,
      position: 0,
      typeId: selectedPlatform!,
      appKey: selectedIcon ?? selectedPlatform!,
    );

    await StorageService.addShortcut(shortcut);
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
        _showMessage('Không tìm thấy mã QR trong ảnh', isError: true);
        return;
      }

      final qrData = barcodes.first.rawValue;
      if (qrData == null || qrData.isEmpty) {
        _showMessage('Không thể đọc dữ liệu QR', isError: true);
        return;
      }

      _qrCodeController.text = qrData;
      _applyAutoDetection(qrData);
      _showMessage('Đã quét thành công!');
    } catch (e) {
      if (mounted) {
        _showMessage('Lỗi khi quét ảnh', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
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
