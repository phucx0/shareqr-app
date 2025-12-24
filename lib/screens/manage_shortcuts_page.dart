import 'package:flutter/material.dart';
import 'package:quick_app/l10n/app_localizations.dart';
import 'package:quick_app/services/storage_service.dart';
import 'package:quick_app/widgets/shortcuts_list.dart';
import '../models/shortcut_item.dart';
import '../models/qr_type.dart';

class ManageShortcutsPage extends StatefulWidget {
  // final List<ShortcutItem> shortcuts;

  const ManageShortcutsPage({
    super.key, 
    // required this.shortcuts
  });

  @override
  State<ManageShortcutsPage> createState() => _ManageShortcutsPageState();
}

class _ManageShortcutsPageState extends State<ManageShortcutsPage> {
  late List<ShortcutItem> _shortcuts;
  QRType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    // _shortcuts = widget.shortcuts.map((s) => s.copyWith()).toList()
    //   ..sort((a, b) => a.position.compareTo(b.position));

    _shortcuts = StorageService.getAllShortcuts();
  }

  void _reorderVisibleShortcuts(int oldIndex, int newIndex) {
    setState(() {
      // Lấy danh sách filtered tạm để tìm item
      final visible = _shortcuts.where((s) => s.isVisible).toList();
      
      if (newIndex > oldIndex) newIndex -= 1;
      final item = visible[oldIndex];
      
      // Tìm index thực trong _shortcuts
      final oldGlobalIndex = _shortcuts.indexOf(item);
      
      _shortcuts.removeAt(oldGlobalIndex);

      // Xác định vị trí chèn trong _shortcuts gốc
      final visibleAfterRemove = _shortcuts.where((s) => s.isVisible).toList();
      int insertIndex;
      if (newIndex >= visibleAfterRemove.length) {
        insertIndex = _shortcuts.length;
      } else {
        insertIndex = _shortcuts.indexOf(visibleAfterRemove[newIndex]);
      }

      _shortcuts.insert(insertIndex, item);

      // Cập nhật position
      for (int i = 0; i < _shortcuts.length; i++) {
        _shortcuts[i] = _shortcuts[i].copyWith(position: i);
      }
    });

    // StorageService.saveShortcuts(_shortcuts);
  }


  void _reorderHiddenShortcuts(int oldIndex, int newIndex) {
    setState(() {
      final hidden = _shortcuts.where((s) => !s.isVisible).toList();
      if (newIndex > oldIndex) newIndex -= 1;
      final item = hidden[oldIndex];
      final oldGlobalIndex = _shortcuts.indexOf(item);
      _shortcuts.removeAt(oldGlobalIndex);

      final hiddenAfterRemove = _shortcuts.where((s) => !s.isVisible).toList();
      int insertIndex;
      if (newIndex >= hiddenAfterRemove.length) {
        insertIndex = _shortcuts.length;
      } else {
        insertIndex = _shortcuts.indexOf(hiddenAfterRemove[newIndex]);
      }

      _shortcuts.insert(insertIndex, item);

      for (int i = 0; i < _shortcuts.length; i++) {
        _shortcuts[i] = _shortcuts[i].copyWith(position: i);
      }
    });

    // StorageService.saveShortcuts(_shortcuts);
  }



  Future<void> _toggleVisibility(int index) async {
    setState(() {
      _shortcuts[index] = _shortcuts[index].copyWith(
        isVisible: !_shortcuts[index].isVisible,
      );
    });
    
    // Lưu vào storage
    // await StorageService.saveShortcuts(_shortcuts);
  }

  List<ShortcutItem> get _filteredShortcuts {
    var list = _shortcuts.where((s) => s.isVisible);
    if (_selectedFilter != null) {
      // list = list.where((s) => s.type == _selectedFilter);
    }

    return list.toList();
  }


  List<ShortcutItem> get _filteredHiddenShortcuts {
    final hidden = _shortcuts.where((s) => !s.isVisible);
    if (_selectedFilter != null) {
      // return hidden.where((s) => s.type == _selectedFilter).toList();
      return hidden.toList();
    }
    return hidden.toList();
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  Text(
                    l10n.shortcutTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, _shortcuts);
                    },
                    child: Text(
                      l10n.commonSave,
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  // Info card
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white70, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.shortcutInstruction,
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Filter chips
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(l10n.commonAll, null),
                        const SizedBox(width: 8),
                        _buildFilterChip(l10n.filterSocial, QRType.social),
                        const SizedBox(width: 8),
                        _buildFilterChip(l10n.filterPayment, QRType.payment),
                        const SizedBox(width: 8),
                        _buildFilterChip(l10n.filterLink, QRType.link),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                
                  // Shortcuts list
                  ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredShortcuts.length,
                    onReorder: _reorderVisibleShortcuts,
                    itemBuilder: (context, index) {
                      final shortcut = _filteredShortcuts[index];
                      final globalIndex = _shortcuts.indexOf(shortcut);

                      return ShortcutListItem(
                        key: ValueKey(shortcut.id),
                        shortcut: shortcut,
                        onToggleVisibility: () => _toggleVisibility(globalIndex),
                      );
                    },
                  ),

                  // Chỉ hiển thị phần này nếu có hidden shortcuts
                  if (_filteredHiddenShortcuts.isNotEmpty) ...[
                    // const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.shortcutHiddenTitle,
                          style: TextStyle(
                            color: Colors.white70, 
                            fontSize: 16
                          ),
                        ),
                      ),
                    ),
                    ReorderableListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredHiddenShortcuts.length,
                      onReorder: _reorderHiddenShortcuts,
                      itemBuilder: (context, index) {
                        final shortcut = _filteredHiddenShortcuts[index];
                        final globalIndex = _shortcuts.indexOf(shortcut);

                        return ShortcutListItem(
                          key: ValueKey(shortcut.id),
                          shortcut: shortcut,
                          onToggleVisibility: () => _toggleVisibility(globalIndex),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ]
      )
      )
    );
  }

  Widget _buildFilterChip(String label, QRType? type) {
    final isSelected = _selectedFilter == type;
    final color = type != null 
        ? _getTypeColor(type)
        : const Color(0xFF3B82F6);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? type : null;
        });
      },
      backgroundColor: const Color(0xFF1E293B),
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.white70,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? color.withOpacity(0.5) : Colors.transparent,
      ),
    );
  }

  Color _getTypeColor(QRType type) {
    switch (type) {
      case QRType.social:
        return const Color(0xFF3B82F6);
      case QRType.payment:
        return const Color(0xFF10B981);
      case QRType.link:
        return const Color(0xFF8B5CF6);
    }
  }
}
