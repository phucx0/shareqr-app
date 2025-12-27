import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quick_app/core/navigation/navigation_key.dart';
import 'package:quick_app/core/theme/app_theme.dart';
import 'package:quick_app/models/favorite_qr.dart';
import 'package:quick_app/models/qr_enum.dart';
import 'package:quick_app/models/qr_item.dart';
import 'package:quick_app/models/qr_type.dart';
import 'package:quick_app/services/type_service.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Khởi tạo APP!");
  await Hive.initFlutter();

  // Đăng ký adapter
  Hive.registerAdapter(QrTypeModelAdapter());
  Hive.registerAdapter(QrTypeAdapter());
  Hive.registerAdapter(QRItemAdapter()); 
  Hive.registerAdapter(FavoriteQRAdapter());
  
  await Hive.openBox('settings');
  // Mở box
  await Hive.openBox<QRItem>('QRsBox');
  final typeBox = await Hive.openBox<QrTypeModel>('QRTypesBox');
  await Hive.openBox<FavoriteQR>('favoriteQRBox');
  
  if (typeBox.isEmpty || typeBox.length != TypeService.getDefaultTypes().length) {  
    TypeService.initType();
    print('Khởi tạo types');
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
          home: const HomePage(),
        );
      },
    );
  }
}