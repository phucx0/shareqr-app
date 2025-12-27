import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_app/l10n/l10n.dart';
import 'package:quick_app/providers/locale_provider.dart';
import 'package:quick_app/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  // final List<ShortcutItem> shortcuts;
  const SettingsPage({
    super.key,
    // required this.shortcuts,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = true;
  bool isBiometricLock = false;
  

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      // backgroundColor: AppTheme.lightTheme,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
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
                        // color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.settingTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GENERAL Section
                    Text(
                      l10n.settingGeneral,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF60A5FA),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _buildToggleItem(
                            icon: Icons.nightlight_round,
                            title: l10n.settingDarkMode,
                            subtitle: l10n.settingDarkModeSubtitle,
                            value: themeProvider.isDarkMode,
                            onChanged: (_) => themeProvider.toggleTheme(),
                          ),
                          Divider(
                            color: const Color(0xFF334155),
                            height: 1,
                            indent: 72,
                          ),
                          // _buildToggleItem(
                          //   icon: Icons.fingerprint,
                          //   title: l10n.biometricLock,
                          //   subtitle: l10n.biometricLockSubtitle,
                          //   value: isBiometricLock,
                          //   onChanged: (val) => setState(() => isBiometricLock = val),
                          // ),
                          // Divider(
                          //   color: const Color(0xFF334155),
                          //   height: 1,
                          //   indent: 72,
                          // ),
                          _buildLanguageItem(
                            icon: Icons.language,
                            title: l10n.settingSelectLanguage,
                            subtitle: context.watch<LocaleProvider>().locale.languageCode == 'vi'
                                ? 'Tiếng Việt'
                                : 'English',
                            context: context,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF3B82F6),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF475569),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () => _showLanguageDialog(context),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white70,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLocale = context.read<LocaleProvider>().locale.languageCode;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Text(
            l10n.settingSelectLanguage,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context: context,
                dialogContext: dialogContext,
                languageCode: 'vi',
                languageName: 'Tiếng Việt',
                flag: '🇻🇳',
                isSelected: currentLocale == 'vi',
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context: context,
                dialogContext: dialogContext,
                languageCode: 'en',
                languageName: 'English',
                flag: '🇬🇧',
                isSelected: currentLocale == 'en',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required BuildContext dialogContext,
    required String languageCode,
    required String languageName,
    required String flag,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        context.read<LocaleProvider>().setLocaleFromCode(languageCode);
        Navigator.pop(dialogContext);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6).withOpacity(0.2) : const Color(0xFF334155),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  // Widget _buildNavigationItem({
  //   required IconData icon,
  //   required Color iconColor,
  //   required String title,
  //   required String subtitle,
  //   required VoidCallback onTap,
  //   bool showDivider = false,
  // }) {
  //   return Column(
  //     children: [
  //       InkWell(
  //         onTap: onTap,
  //         borderRadius: BorderRadius.circular(20),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: iconColor.withOpacity(0.15),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Icon(
  //                   icon,
  //                   color: iconColor,
  //                   size: 24,
  //                 ),
  //               ),
  //               const SizedBox(width: 16),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       title,
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 2),
  //                     Text(
  //                       subtitle,
  //                       style: TextStyle(
  //                         fontSize: 13,
  //                         color: Colors.white.withOpacity(0.5),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Icon(
  //                 Icons.chevron_right,
  //                 color: Colors.white.withOpacity(0.3),
  //                 size: 24,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       if (showDivider)
  //         Divider(
  //           color: const Color(0xFF334155),
  //           height: 1,
  //           indent: 72,
  //         ),
  //     ],
  //   );
  // }
}