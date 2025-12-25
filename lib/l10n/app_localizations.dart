import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'Lightning fast, every second counts'**
  String get appSlogan;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get commonFavorite;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get commonPreview;

  /// No description provided for @commonVisible.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get commonVisible;

  /// No description provided for @commonHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get commonHidden;

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get commonSaveChanges;

  /// No description provided for @commonQuickAction.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get commonQuickAction;

  /// No description provided for @commonHello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get commonHello;

  /// No description provided for @contentQR.
  ///
  /// In en, this message translates to:
  /// **'QR Content'**
  String get contentQR;

  /// No description provided for @nameQR.
  ///
  /// In en, this message translates to:
  /// **'QR Name'**
  String get nameQR;

  /// No description provided for @enterQRName.
  ///
  /// In en, this message translates to:
  /// **'Enter QR name'**
  String get enterQRName;

  /// No description provided for @pasteOrLink.
  ///
  /// In en, this message translates to:
  /// **'Paste QR content or link'**
  String get pasteOrLink;

  /// No description provided for @warningContentQR.
  ///
  /// In en, this message translates to:
  /// **'For payments, please scan from QR image'**
  String get warningContentQR;

  /// No description provided for @addNewQR.
  ///
  /// In en, this message translates to:
  /// **'Add new QR'**
  String get addNewQR;

  /// No description provided for @noFavoriteQR.
  ///
  /// In en, this message translates to:
  /// **'No favorite QR codes saved'**
  String get noFavoriteQR;

  /// No description provided for @clipboardPasted.
  ///
  /// In en, this message translates to:
  /// **'Pasted from clipboard'**
  String get clipboardPasted;

  /// No description provided for @pleaseEnterQRName.
  ///
  /// In en, this message translates to:
  /// **'Please enter QR name'**
  String get pleaseEnterQRName;

  /// No description provided for @pleaseEnterQRContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter QR content'**
  String get pleaseEnterQRContent;

  /// No description provided for @pleaseSelectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Please select platform'**
  String get pleaseSelectPlatform;

  /// No description provided for @autoDetect.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get autoDetect;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @fromImage.
  ///
  /// In en, this message translates to:
  /// **'From image'**
  String get fromImage;

  /// No description provided for @filterBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get filterBank;

  /// No description provided for @filterSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get filterSocial;

  /// No description provided for @filterPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get filterPayment;

  /// No description provided for @filterCrypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get filterCrypto;

  /// No description provided for @filterPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get filterPhone;

  /// No description provided for @filterLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get filterLink;

  /// No description provided for @filterMessenger.
  ///
  /// In en, this message translates to:
  /// **'Messenger'**
  String get filterMessenger;

  /// No description provided for @shortcutTitle.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get shortcutTitle;

  /// No description provided for @shortcutEditReorder.
  ///
  /// In en, this message translates to:
  /// **'Edit & Reorder'**
  String get shortcutEditReorder;

  /// No description provided for @shortcutInstruction.
  ///
  /// In en, this message translates to:
  /// **'Long press to reorder. Tap the eye icon to hide/show.'**
  String get shortcutInstruction;

  /// No description provided for @shortcutHiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'Hidden shortcuts'**
  String get shortcutHiddenTitle;

  /// No description provided for @shortcutSocialDescription.
  ///
  /// In en, this message translates to:
  /// **'Social media & contacts'**
  String get shortcutSocialDescription;

  /// No description provided for @shortcutPaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'Payment & financial services'**
  String get shortcutPaymentDescription;

  /// No description provided for @shortcutLinkDescription.
  ///
  /// In en, this message translates to:
  /// **'Website links & URLs'**
  String get shortcutLinkDescription;

  /// No description provided for @settingTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingTitle;

  /// No description provided for @settingGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingGeneral;

  /// No description provided for @settingContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get settingContent;

  /// No description provided for @settingData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingData;

  /// No description provided for @settingDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingDarkMode;

  /// No description provided for @settingDarkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce eye strain'**
  String get settingDarkModeSubtitle;

  /// No description provided for @settingBiometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Lock'**
  String get settingBiometricLock;

  /// No description provided for @settingBiometricLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secure app access'**
  String get settingBiometricLockSubtitle;

  /// No description provided for @settingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguage;

  /// No description provided for @selectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Select Platform'**
  String get selectPlatform;

  /// Label for selecting app language
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settingSelectLanguage;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to my app'**
  String get welcomeMessage;

  /// Greeting message shown to user
  ///
  /// In en, this message translates to:
  /// **'Hello {name}!'**
  String greetingMessage(String name);

  /// No description provided for @scanImageError.
  ///
  /// In en, this message translates to:
  /// **'Error scanning image'**
  String get scanImageError;

  /// No description provided for @scanSuccess.
  ///
  /// In en, this message translates to:
  /// **'Scan successful'**
  String get scanSuccess;

  /// No description provided for @cannotReadQRData.
  ///
  /// In en, this message translates to:
  /// **'Unable to read QR data'**
  String get cannotReadQRData;

  /// No description provided for @noQRFoundInImage.
  ///
  /// In en, this message translates to:
  /// **'No QR code found in the image'**
  String get noQRFoundInImage;

  /// No description provided for @imageGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo library'**
  String get imageGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @qrDeletePermanent.
  ///
  /// In en, this message translates to:
  /// **'This QR will be permanently deleted.\nAre you sure?'**
  String get qrDeletePermanent;

  /// No description provided for @deleteQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete QR Code?'**
  String get deleteQrTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
