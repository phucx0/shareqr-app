import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quick_app/core/theme/app_theme.dart';
import 'package:quick_app/models/favorite_qr.dart';
import 'package:quick_app/models/qr_type.dart';
import 'package:quick_app/screens/add_qr_page.dart';
import 'package:quick_app/screens/edit_qr_page.dart';
import 'package:quick_app/services/favorite_qr_service.dart';
import 'package:quick_app/services/snackbar_service.dart';
import 'package:quick_app/services/type_service.dart';
import 'package:quick_app/widgets/favorite_qr_list.dart';
import 'package:quick_app/widgets/qr_action_bottom_sheet.dart';
import '../models/shortcut_item.dart';
import '../widgets/app_header.dart';
import '../widgets/shortcut_grid.dart';
import '../services/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ShortcutItem> shortcuts = [];
  bool isLoading = true;
  QRType? selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadShortcuts();
  }

  Future<void> _loadShortcuts() async {
    try {
      setState(() {
        shortcuts = StorageService.getAllShortcuts();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> _toggleFavorite(bool isFavorite, ShortcutItem shortcut) async {
    try {
      if (isFavorite) {
        await FavoriteQRService.deleteFavoriteByShortcutId(shortcut.id);
      } else {
        await FavoriteQRService.addFavorite(
          shortcutId: shortcut.id,
          note: shortcut.description.isNotEmpty 
              ? shortcut.description 
              : null,
        );
      }
      
    } catch (e) {
      if (mounted) {
        SnackbarService.showMessage('Lỗi: ${e.toString()}', context, isError: true);
      }
    }
  }

  void openAddFavoriteQR({VoidCallback? onEdited}) {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(  
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: AppTheme.darkest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            spacing: 16,
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  spacing: 16,
                  children: shortcuts.map((qr) {
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
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            Text(
                              qr.type!.getName(context),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white60
                              ),
                            )
                          ],
                        ),
                
                        InkWell(
                          onTap: () async {  
                            await _toggleFavorite(isFavorite, qr);
                            setModalState(() {}); 
                            onEdited?.call(); 
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: isFavorite ? Colors.amber : Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList()
                ),
              )
            ]
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    // Empty state - khích lệ tạo QR đầu tiên
    if (shortcuts.isEmpty) {
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
                        MaterialPageRoute(
                          builder: (context) => AddQRScreen(),
                        ),
                      );
                      _loadShortcuts();
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        inherit: true,
                      ),
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

    return Scaffold(
      // backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(),
              const SizedBox(height: 24),

              ValueListenableBuilder(
                valueListenable: Hive.box<ShortcutItem>('shortcutsBox').listenable(),
                builder: (context, shortcutsBox, _) {
                  return ValueListenableBuilder(
                    valueListenable: Hive.box<FavoriteQR>('favoriteQRBox').listenable(),
                    builder: (context, favoriteBox, _) {
                      final favoriteQRList = FavoriteQRService.getFavoriteShortcuts();
                      return FavoriteQrList(
                        shortcuts: favoriteQRList,
                        onAddTap: openAddFavoriteQR,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
              // Main content - scrollable
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<ShortcutItem>('shortcutsBox').listenable(),
                  builder: (context, Box<ShortcutItem> box, _) {
                    final _shortcuts = box.values.toList();
                    shortcuts = _shortcuts;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: TypeService.getDefaultTypes().map((type) {
                          final typeShortcuts = _shortcuts
                              .where((s) => s.typeId == type.id)
                              .toList();

                          if (typeShortcuts.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(
                                title: type.getName(context),
                                icon: Icons.payment,
                                color: const Color(0xFF10B981),
                              ),
                              const SizedBox(height: 12),
                              ShortcutGrid(
                                shortcuts: typeShortcuts,
                                onShortcutTap: _handleShortcutTap,
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          final navigator = Navigator.of(context); // Lưu trước
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddQRScreen(),
              ),
            );
            
            // ✅ Dùng navigator đã lưu
            if (result != null) {
              navigator.pop(result);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xff3782FD),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Color(0xff006FFF), width: 1)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                // const Icon(
                //   Icons.edit,
                //   // color: Colors.white,
                //   size: 24,
                // ),
                Text(
                  "Tạo QR mới",
                  style: TextStyle(
                    // color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        // Container(
        //   padding: const EdgeInsets.all(8),
        //   decoration: BoxDecoration(
        //     color: color.withOpacity(0.2),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Icon(
        //     icon,
        //     color: color,
        //     size: 20,
        //   ),
        // ),
        // const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _handleShortcutTap(ShortcutItem shortcut) async {
    showQRActionSheet(
      context: context,
      shortcut: shortcut,
      onDeleted: () async {
        // Xóa shortcut
        await StorageService.removeShortcut(shortcut.id);
        // Refresh list
        setState(() {
          // reload shortcuts
        });
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
}