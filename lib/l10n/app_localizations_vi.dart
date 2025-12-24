// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appSlogan => 'Nhanh như chớp, tiện lợi từng giây';

  @override
  String get commonAll => 'Tất cả';

  @override
  String get commonCopy => 'Sao chép';

  @override
  String get commonFavorite => 'Yêu thích';

  @override
  String get commonShare => 'Chia sẻ';

  @override
  String get commonEdit => 'Chỉnh sửa';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonPreview => 'Xem trước';

  @override
  String get commonVisible => 'Hiện';

  @override
  String get commonHidden => 'Ẩn';

  @override
  String get commonSaveChanges => 'Lưu thay đổi';

  @override
  String get filterBank => 'Ngân hàng';

  @override
  String get filterSocial => 'Mạng xã hội';

  @override
  String get filterPayment => 'Thanh toán';

  @override
  String get filterCrypto => 'Tiền mã hóa';

  @override
  String get filterPhone => 'Điện thoại';

  @override
  String get filterLink => 'Liên kết';

  @override
  String get filterMessenger => 'Tin nhắn';

  @override
  String get shortcutTitle => 'Phím tắt';

  @override
  String get shortcutEditReorder => 'Sửa & sắp xếp';

  @override
  String get shortcutInstruction =>
      'Nhấn giữ để sắp xếp. Nhấn vào biểu tượng mắt để ẩn/hiện.';

  @override
  String get shortcutHiddenTitle => 'Phím tắt đã ẩn';

  @override
  String get shortcutSocialDescription => 'Mạng xã hội & liên hệ';

  @override
  String get shortcutPaymentDescription => 'Thanh toán & dịch vụ tài chính';

  @override
  String get shortcutLinkDescription => 'Liên kết website & URL';

  @override
  String get settingTitle => 'Cài đặt';

  @override
  String get settingGeneral => 'Cài đặt chung';

  @override
  String get settingContent => 'Nội dung';

  @override
  String get settingData => 'Dữ liệu';

  @override
  String get settingDarkMode => 'Giao diện tối';

  @override
  String get settingDarkModeSubtitle => 'Giúp giảm mỏi mắt';

  @override
  String get settingBiometricLock => 'Khóa sinh trắc học';

  @override
  String get settingBiometricLockSubtitle => 'Bảo mật ứng dụng';

  @override
  String get settingLanguage => 'Ngôn ngữ';

  @override
  String get settingSelectLanguage => 'Chọn ngôn ngữ';

  @override
  String get welcomeMessage => 'Chào mừng đến với ứng dụng của tôi';

  @override
  String greetingMessage(String name) {
    return 'Xin chào $name!';
  }
}
