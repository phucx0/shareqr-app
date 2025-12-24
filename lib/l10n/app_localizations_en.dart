// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appSlogan => 'Lightning fast, every second counts';

  @override
  String get commonAll => 'All';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonFavorite => 'Favorites';

  @override
  String get commonShare => 'Share';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSave => 'Save';

  @override
  String get commonPreview => 'Preview';

  @override
  String get commonVisible => 'Visible';

  @override
  String get commonHidden => 'Hidden';

  @override
  String get commonSaveChanges => 'Save Changes';

  @override
  String get filterBank => 'Bank';

  @override
  String get filterSocial => 'Social';

  @override
  String get filterPayment => 'Payment';

  @override
  String get filterCrypto => 'Crypto';

  @override
  String get filterPhone => 'Phone';

  @override
  String get filterLink => 'Link';

  @override
  String get filterMessenger => 'Messenger';

  @override
  String get shortcutTitle => 'Shortcuts';

  @override
  String get shortcutEditReorder => 'Edit & Reorder';

  @override
  String get shortcutInstruction =>
      'Long press to reorder. Tap the eye icon to hide/show.';

  @override
  String get shortcutHiddenTitle => 'Hidden shortcuts';

  @override
  String get shortcutSocialDescription => 'Social media profiles & contacts';

  @override
  String get shortcutPaymentDescription => 'Payment & financial services';

  @override
  String get shortcutLinkDescription => 'Website links & URLs';

  @override
  String get settingTitle => 'Settings';

  @override
  String get settingGeneral => 'General';

  @override
  String get settingContent => 'Content';

  @override
  String get settingData => 'Data';

  @override
  String get settingDarkMode => 'Dark Mode';

  @override
  String get settingDarkModeSubtitle => 'Reduce eye strain';

  @override
  String get settingBiometricLock => 'Biometric Lock';

  @override
  String get settingBiometricLockSubtitle => 'Secure app access';

  @override
  String get settingLanguage => 'Language';

  @override
  String get settingSelectLanguage => 'Select Language';

  @override
  String get welcomeMessage => 'Welcome to my app';

  @override
  String greetingMessage(String name) {
    return 'Hello $name!';
  }
}
