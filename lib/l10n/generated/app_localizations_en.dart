// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CryptoTosentai';

  @override
  String get tabHome => 'Home';

  @override
  String get tabPortfolio => 'Portfolio';

  @override
  String get tabProfile => 'Profile';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to track your crypto';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Start your portfolio in seconds';

  @override
  String get forgotTitle => 'Reset password';

  @override
  String get forgotSubtitle => 'We will send you a reset link';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get name => 'Name';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create account';

  @override
  String get backToLogin => 'Back to sign in';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationEmail => 'Enter a valid email';

  @override
  String validationMinChars(int n) {
    return 'Min $n characters';
  }

  @override
  String get validationMatch => 'Passwords don\'t match';

  @override
  String get resetSent => 'Reset link sent to your email';

  @override
  String get homeTitle => 'Markets';

  @override
  String get search => 'Search coin or symbol';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortMarketCap => 'Market cap';

  @override
  String get sortPrice => 'Price';

  @override
  String get sortChange => '24h change';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get marketCap => 'Market cap';

  @override
  String get price => 'Price';

  @override
  String get change24h => '24h';

  @override
  String get detailsAddToPortfolio => 'Add to Portfolio';

  @override
  String get detailsAth => 'ATH';

  @override
  String get detailsAtl => 'ATL';

  @override
  String get detailsVolume => 'Volume';

  @override
  String get detailsCircSupply => 'Circulating supply';

  @override
  String get detailsChart7d => '7-Day Chart';

  @override
  String get portfolioTitle => 'Portfolio';

  @override
  String get portfolioEmpty => 'Your portfolio is empty';

  @override
  String get portfolioEmptyHint => 'Add your first asset from the Markets tab';

  @override
  String get totalBalance => 'Total balance';

  @override
  String get totalPnl => 'Total PnL';

  @override
  String get amount => 'Amount';

  @override
  String get buyPrice => 'Buy price';

  @override
  String get notes => 'Notes';

  @override
  String get addAsset => 'Add asset';

  @override
  String get editAsset => 'Edit asset';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get currentValue => 'Current value';

  @override
  String get invested => 'Invested';

  @override
  String get pnl => 'PnL';

  @override
  String get profileTitle => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get displayName => 'Display name';

  @override
  String get changeAvatar => 'Change avatar';

  @override
  String get fromCamera => 'From camera';

  @override
  String get fromGallery => 'From gallery';

  @override
  String get removeAvatar => 'Remove avatar';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get errorNetwork => 'Network error. Check connection';

  @override
  String get errorAuthInvalid => 'Invalid email or password';

  @override
  String get errorAuthExists => 'Account already exists';

  @override
  String get errorAuthWeakPwd => 'Password is too weak';

  @override
  String get errorAuthNotFound => 'User not found';

  @override
  String get privacy => 'Privacy';

  @override
  String get hideBalances => 'Hide balances';

  @override
  String get hideBalancesHint => 'Mask amounts on Portfolio and Summary';

  @override
  String get security => 'Security';

  @override
  String get changePassword => 'Change password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get passwordChanged => 'Password updated';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountConfirm => 'Delete account?';

  @override
  String get deleteAccountDescription =>
      'This permanently removes your portfolio and settings. Cannot be undone.';

  @override
  String get confirmDelete => 'Delete forever';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get viewLicenses => 'Open-source licenses';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get sourceCode => 'Source code';

  @override
  String get edit => 'Edit';

  @override
  String get ok => 'OK';
}
