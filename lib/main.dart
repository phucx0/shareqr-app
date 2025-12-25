import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quick_app/core/navigation/navigation_key.dart';
import 'package:quick_app/core/theme/app_theme.dart';
// import 'package:quick_app/l10n/app_localizations.dart';
import 'package:quick_app/models/favorite_qr.dart';
import 'package:quick_app/models/shortcut_item.dart';
import 'package:quick_app/models/shortcut_type.dart';
import 'package:quick_app/services/type_service.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart'; // Import ThemeProvider
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Đăng ký adapter
  Hive.registerAdapter(ShortcutItemAdapter());
  Hive.registerAdapter(ShortcutTypeAdapter()); 
  Hive.registerAdapter(FavoriteQRAdapter());
  
  await Hive.openBox('settings');
  // Mở box
  await Hive.openBox<ShortcutItem>('shortcutsBox');
  final typeBox = await Hive.openBox<ShortcutType>('shortcutTypesBox');
  await Hive.openBox<FavoriteQR>('favoriteQRBox');
  if (typeBox.isEmpty) {  
    TypeService.initType();
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Thêm ThemeProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const AppContent();
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      builder: (context, localeProvider, themeProvider, child) {
        // Hiển thị loading khi đang load locale hoặc theme
        if (localeProvider.isLoading || themeProvider.isLoading) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: AppTheme.darkest,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }

        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode, // Dùng themeMode từ provider
          debugShowCheckedModeBanner: false,
          title: 'ShareQR',
          locale: localeProvider.locale,
          navigatorKey: navigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // localizationsDelegates: const [
          //   AppLocalizations.delegate,
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          // supportedLocales: const [
          //   Locale('vi'),
          //   Locale('en'),
          // ],
          home: const HomePage(),
        );
      },
    );
  }
}