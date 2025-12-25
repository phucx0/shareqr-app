import 'package:quick_app/l10n/app_localizations.dart';
import '../core/navigation/navigation_key.dart';

AppLocalizations get l10n {
  final context = navigatorKey.currentContext;
  assert(context != null, 'Navigator context is null');
  return AppLocalizations.of(context!)!;
}
