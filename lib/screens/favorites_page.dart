// screens/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_app/core/theme/app_theme.dart';
import 'package:quick_app/models/favorite_qr.dart';
import 'package:quick_app/models/shortcut_item.dart';
import 'package:quick_app/services/favorite_qr_service.dart';
import 'package:quick_app/services/snackbar_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<FavoriteQR> favorites = [];
  List<FavoriteQR> filteredFavorites = [];
  String selectedFilter = 'all'; // all, url, text, phone, email, wifi
  String searchQuery = '';
  bool isSelectionMode = false;
  Set<String> selectedIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      // Load all favorites with shortcuts
      final allWithShortcuts = FavoriteQRService.getAllFavoritesWithShortcuts();
      favorites = allWithShortcuts.map((item) => item['favorite'] as FavoriteQR).toList();
      _applyFilters();
    });
  }

  void _applyFilters() {
    // Get favorites with shortcuts
    final allWithShortcuts = FavoriteQRService.getAllFavoritesWithShortcuts();
    
    // Filter
    final filtered = allWithShortcuts.where((item) {
      final fav = item['favorite'] as FavoriteQR;
      final shortcut = item['shortcut'] as ShortcutItem;
      
      // Filter by type
      if (selectedFilter != 'all' && shortcut.typeName.toLowerCase() != selectedFilter) {
        return false;
      }
      
      // Filter by search query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return shortcut.title.toLowerCase().contains(query) ||
               shortcut.qrData.toLowerCase().contains(query) ||
               shortcut.description.toLowerCase().contains(query) ||
               (fav.note?.toLowerCase().contains(query) ?? false);
      }
      
      return true;
    }).toList();

    // Sort by most recent
    filtered.sort((a, b) {
      final favA = a['favorite'] as FavoriteQR;
      final favB = b['favorite'] as FavoriteQR;
      final aDate = favA.lastUsedAt ?? favA.createdAt;
      final bDate = favB.lastUsedAt ?? favB.createdAt;
      return bDate.compareTo(aDate);
    });
    
    setState(() {
      filteredFavorites = filtered.map((item) => item['favorite'] as FavoriteQR).toList();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
      
      if (selectedIds.isEmpty) {
        isSelectionMode = false;
      }
    });
  }

  void _deleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa ${selectedIds.length} mục đã chọn?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FavoriteQRService.deleteFavorites(selectedIds.toList());
      setState(() {
        selectedIds.clear();
        isSelectionMode = false;
      });
      _loadFavorites();
      
      if (mounted) {
        SnackbarService.showMessage('Đã xóa thành công', context);
      }
    }
  }

  void _showQRDetail(FavoriteQR fav, ShortcutItem shortcut) {
    // Increment usage count
    FavoriteQRService.incrementUsage(shortcut.id);
    _loadFavorites();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _QRDetailSheet(
        favorite: fav,
        shortcut: shortcut,
        onDelete: () {
          Navigator.pop(context);
          _deleteSingle(fav.id);
        },
        onEdit: () {
          Navigator.pop(context);
          _showEditDialog(fav, shortcut);
        },
      ),
    );
  }

  void _deleteSingle(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa mục này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FavoriteQRService.deleteFavorite(id);
      _loadFavorites();
      
      if (mounted) {
        SnackbarService.showMessage('Đã xóa thành công', context);
      }
    }
  }

  void _showEditDialog(FavoriteQR fav, ShortcutItem shortcut) {
    final noteController = TextEditingController(text: fav.note ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa ghi chú'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shortcut.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FavoriteQRService.updateNote(
                id: fav.id,
                note: noteController.text.isEmpty ? null : noteController.text,
              );
              _loadFavorites();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSelectionMode 
            ? Text('Đã chọn ${selectedIds.length}')
            : const Text('Yêu thích'),
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isSelectionMode = false;
                    selectedIds.clear();
                  });
                },
              )
            : null,
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // showSearch(
                //   context: context,
                //   delegate: _FavoriteSearchDelegate(
                //     favorites: favorites,
                //     onSelected: _showQRDetail,
                //   ),
                // );
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'select') {
                  setState(() {
                    isSelectionMode = true;
                  });
                } else if (value == 'deleteAll') {
                  _deleteAll();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'select',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline),
                      SizedBox(width: 8),
                      Text('Chọn nhiều'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'deleteAll',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          _buildFilterTabs(),
          
          // Content
          Expanded(
            child: filteredFavorites.isEmpty
                ? _buildEmptyState()
                : _buildFavoritesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      {'id': 'all', 'label': 'Tất cả', 'icon': Icons.apps},
      {'id': 'url', 'label': 'URL', 'icon': Icons.link},
      {'id': 'text', 'label': 'Text', 'icon': Icons.text_fields},
      {'id': 'phone', 'label': 'Phone', 'icon': Icons.phone},
      {'id': 'email', 'label': 'Email', 'icon': Icons.email},
      {'id': 'wifi', 'label': 'WiFi', 'icon': Icons.wifi},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['id'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 18,
                    color: isSelected ? AppTheme.primaryBlue : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(filter['label'] as String),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter['id'] as String;
                  _applyFilters();
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredFavorites.length,
      itemBuilder: (context, index) {
        final fav = filteredFavorites[index];
        final shortcut = fav.getShortcut();
        
        // Skip if shortcut was deleted
        if (shortcut == null) return const SizedBox.shrink();
        
        final isSelected = selectedIds.contains(fav.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : AppTheme.dark,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                if (isSelectionMode) {
                  _toggleSelection(fav.id);
                } else {
                  _showQRDetail(fav, shortcut);
                }
              },
              onLongPress: () {
                if (!isSelectionMode) {
                  setState(() {
                    isSelectionMode = true;
                    selectedIds.add(fav.id);
                  });
                  HapticFeedback.mediumImpact();
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryBlue : AppTheme.medium,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    if (isSelectionMode)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          isSelected 
                              ? Icons.check_circle 
                              : Icons.circle_outlined,
                          color: isSelected ? AppTheme.primaryBlue : Colors.grey,
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.medium,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.qr_code,
                        color: Color(shortcut.colorValue),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shortcut.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shortcut.qrData,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (shortcut.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              shortcut.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.4),
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatDate(fav.lastUsedAt ?? fav.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        if (fav.usageCount > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                                size: 12,
                                color: Colors.white.withOpacity(0.4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${fav.usageCount}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có mục yêu thích',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedFilter != 'all'
                ? 'Không có ${selectedFilter.toUpperCase()} nào'
                : 'Thêm QR code yêu thích để dễ truy cập',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _deleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả'),
        content: const Text('Bạn có chắc muốn xóa tất cả mục yêu thích?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FavoriteQRService.deleteAllFavorites();
      _loadFavorites();
      
      if (mounted) {
        SnackbarService.showMessage('Đã xóa tất cả', context);
      }
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'url':
        return Icons.link;
      case 'text':
        return Icons.text_fields;
      case 'phone':
        return Icons.phone;
      case 'email':
        return Icons.email;
      case 'wifi':
        return Icons.wifi;
      default:
        return Icons.qr_code;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}p trước';
      }
      return '${diff.inHours}h trước';
    } else if (diff.inDays == 1) {
      return 'Hôm qua';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// QR Detail Bottom Sheet
class _QRDetailSheet extends StatelessWidget {
  final FavoriteQR favorite;
  final ShortcutItem shortcut;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _QRDetailSheet({
    required this.favorite,
    required this.shortcut,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.dark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortcut.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.medium,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    shortcut.typeName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(shortcut.colorValue),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.darkest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    shortcut.qrData,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (shortcut.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Mô tả',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shortcut.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
                if (favorite.note != null && favorite.note!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Ghi chú riêng',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    favorite.note!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildStatItem(
                      Icons.remove_red_eye,
                      '${favorite.usageCount}',
                      'Lần dùng',
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      Icons.calendar_today,
                      _formatDate(favorite.createdAt),
                      'Tạo lúc',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: shortcut.qrData));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã sao chép')),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: const Text('Sao chép'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit),
                        label: const Text('Sửa ghi chú'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text('Xóa'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white.withOpacity(0.5),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Search Delegate
class _FavoriteSearchDelegate extends SearchDelegate<FavoriteQR?> {
  final List<FavoriteQR> favorites;
  final Function(FavoriteQR) onSelected;

  _FavoriteSearchDelegate({
    required this.favorites,
    required this.onSelected,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = FavoriteQRService.searchFavorites(query);

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final qr = results[index];
        return ListTile(
          leading: Icon(
            _getIconForType(qr['type']),
            color: AppTheme.primaryBlue,
          ),
          title: Text(qr['title']),
          subtitle: Text(
            qr['content'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            close(context, qr as FavoriteQR?);
            onSelected(qr as FavoriteQR);
          },
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'url':
        return Icons.link;
      case 'text':
        return Icons.text_fields;
      case 'phone':
        return Icons.phone;
      case 'email':
        return Icons.email;
      case 'wifi':
        return Icons.wifi;
      default:
        return Icons.qr_code;
    }
  }
}