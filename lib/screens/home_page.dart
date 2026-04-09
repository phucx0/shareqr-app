import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_app/core/theme/app_theme.dart';
import 'package:quick_app/l10n/l10n.dart';
import 'package:quick_app/models/favorite_qr.dart';
import 'package:quick_app/models/qr_enum.dart';
import 'package:quick_app/screens/add_qr_page.dart';
import 'package:quick_app/screens/edit_qr_page.dart';
import 'package:quick_app/services/favorite_qr_service.dart';
import 'package:quick_app/services/snackbar_service.dart';
import 'package:quick_app/widgets/animated_fab.dart';
import 'package:quick_app/widgets/favorite_qr_list.dart';
import 'package:quick_app/widgets/qr_action_bottom_sheet.dart';
import '../models/qr_item.dart';
import '../widgets/app_header.dart';
import '../widgets/qr_grid.dart';
import '../services/qr_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QRItem> qrs = [];
  bool isLoading = true;
  QrType? selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadQRs();
  }

  Future<void> _loadQRs() async {
    try {
      setState(() {
        qrs = QRService.getAllQRs();
        isLoading = false;
        print('QRs: ${qrs.length}');
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(bool isFavorite, QRItem qr) async {
    try {
      if (isFavorite) {
        await FavoriteQRService.deleteFavoriteByQRId(qr.id);
        SnackbarService.showMessage(l10n.removedFromFavorites, context);
      } else {
        await FavoriteQRService.addFavorite(
          shortcutId: qr.id,
          note: qr.description.isNotEmpty ? qr.description : null,
        );
        SnackbarService.showMessage(l10n.addedToFavorites, context);
      }
    } catch (e) {
      if (mounted) {
        SnackbarService.showMessage(
          'Lỗi: ${e.toString()}',
          context,
          isError: true,
        );
      }
    }
  }

  void openAddFavoriteQR({VoidCallback? onEdited}) {
    List<QRItem> sortedQRs = List.from(qrs); // tạo bản copy
    sortedQRs.sort((a, b) {
      // 1. favorite lên đầu
      int favCompare = (b.isFavorite ? 1 : 0) - (a.isFavorite ? 1 : 0);
      if (favCompare != 0) return favCompare;

      // 2. cùng isFavorite → sort theo tên alphabet
      return a.title.compareTo(b.title);
    });

    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              spacing: 16,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  child: Column(
                    spacing: 16,
                    children: sortedQRs.map((qr) {
                      bool isFavorite = qr.isFavorite;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                qr.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                qr.getType!.getName(context),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  // color: Colors.white60
                                ),
                              ),
                            ],
                          ),

                          InkWell(
                            onTap: () async {
                              await _toggleFavorite(isFavorite, qr);
                              setModalState(() {});
                              onEdited?.call();
                              sortedQRs.sort(
                                (a, b) =>
                                    (b.isFavorite ? 1 : 0) -
                                    (a.isFavorite ? 1 : 0),
                              );
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite
                                    ? Colors.amber
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // Empty state - khích lệ tạo QR đầu tiên
    if (qrs.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // QR Code Icon
                  SvgPicture.asset(
                    "assets/svg/greeting.svg",
                    height: 250,
                    width: 250,
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      const Text(
                        'Chào mừng đến với',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'ShareQR',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'Tạo QR đầu tiên của bạn và quản lý thông tin nhanh chóng, dễ dàng.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Create Button
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddQRScreen()),
                      );
                      _loadQRs();
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(inherit: true),
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Icon(Icons.add, size: 24),
                        // const SizedBox(width: 8),
                        const Text(
                          'Bắt đầu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor, // màu nền
        statusBarIconBrightness: Brightness.dark, // icon đen
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              // top: 8.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeader(),
                const SizedBox(height: 16),

                ValueListenableBuilder(
                  valueListenable: Hive.box<QRItem>('QRsBox').listenable(),
                  builder: (context, qrsBox, _) {
                    return ValueListenableBuilder(
                      valueListenable: Hive.box<FavoriteQR>(
                        'favoriteQRBox',
                      ).listenable(),
                      builder: (context, favoriteBox, _) {
                        final favoriteQRList =
                            FavoriteQRService.getFavoriteShortcuts();
                        return FavoriteQrList(
                          qrs: favoriteQRList,
                          onAddTap: openAddFavoriteQR,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),
                // Main content - scrollable
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    spacing: 16,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.qrCodeList,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: Hive.box<QRItem>(
                          'QRsBox',
                        ).listenable(),
                        builder: (context, Box<QRItem> box, _) {
                          final _QRs = box.values.toList();
                          qrs = _QRs;
                          return QRGrid(qrs: qrs, onTap: _handleShortcutTap);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: AnimatedFab(
          onPressed: () async {
            final navigator = Navigator.of(context); // Lưu trước
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddQRScreen()),
            );

            if (result != null) {
              navigator.pop(result);
            }
          },
          icon: Icon(Icons.add, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Future<void> _handleShortcutTap(QRItem qr) async {
    showQRActionSheet(
      context: context,
      qr: qr,
      onDeleted: () async {
        // Xóa shortcut
        await QRService.removeQR(qr.id);
        // Refresh list
        setState(() {
          // reload shortcuts
        });
      },
      onEdited: () {
        // Navigate to edit page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditQRPage(qr: qr)),
        );
      },
    );
  }
}
