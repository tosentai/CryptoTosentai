// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'CryptoTosentai';

  @override
  String get tabHome => 'Strona główna';

  @override
  String get tabPortfolio => 'Portfel';

  @override
  String get tabProfile => 'Profil';

  @override
  String get loginTitle => 'Witaj ponownie';

  @override
  String get loginSubtitle => 'Zaloguj się, aby śledzić krypto';

  @override
  String get registerTitle => 'Utwórz konto';

  @override
  String get registerSubtitle => 'Zacznij swój portfel w sekundy';

  @override
  String get forgotTitle => 'Zresetuj hasło';

  @override
  String get forgotSubtitle => 'Wyślemy link do resetu';

  @override
  String get email => 'Email';

  @override
  String get password => 'Hasło';

  @override
  String get confirmPassword => 'Potwierdź hasło';

  @override
  String get name => 'Imię';

  @override
  String get signIn => 'Zaloguj';

  @override
  String get signUp => 'Zarejestruj';

  @override
  String get signOut => 'Wyloguj';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get sendResetLink => 'Wyślij link';

  @override
  String get noAccount => 'Nie masz konta?';

  @override
  String get haveAccount => 'Masz już konto?';

  @override
  String get createAccount => 'Utwórz konto';

  @override
  String get backToLogin => 'Powrót do logowania';

  @override
  String get validationRequired => 'Wymagane';

  @override
  String get validationEmail => 'Podaj prawidłowy email';

  @override
  String validationMinChars(int n) {
    return 'Minimum $n znaków';
  }

  @override
  String get validationMatch => 'Hasła nie są takie same';

  @override
  String get resetSent => 'Link wysłany na email';

  @override
  String get homeTitle => 'Rynki';

  @override
  String get search => 'Szukaj monety lub symbolu';

  @override
  String get sortBy => 'Sortuj';

  @override
  String get sortMarketCap => 'Kapitalizacja';

  @override
  String get sortPrice => 'Cena';

  @override
  String get sortChange => 'Zmiana 24h';

  @override
  String get pullToRefresh => 'Pociągnij, aby odświeżyć';

  @override
  String get marketCap => 'Kapitalizacja';

  @override
  String get price => 'Cena';

  @override
  String get change24h => '24h';

  @override
  String get detailsAddToPortfolio => 'Dodaj do portfela';

  @override
  String get detailsAth => 'ATH';

  @override
  String get detailsAtl => 'ATL';

  @override
  String get detailsVolume => 'Wolumen';

  @override
  String get detailsCircSupply => 'W obiegu';

  @override
  String get detailsChart7d => 'Wykres 7 dni';

  @override
  String get portfolioTitle => 'Portfel';

  @override
  String get portfolioEmpty => 'Twój portfel jest pusty';

  @override
  String get portfolioEmptyHint => 'Dodaj pierwszy aktyw z zakładki Rynki';

  @override
  String get totalBalance => 'Saldo całkowite';

  @override
  String get totalPnl => 'Łączny PnL';

  @override
  String get amount => 'Ilość';

  @override
  String get buyPrice => 'Cena zakupu';

  @override
  String get notes => 'Notatki';

  @override
  String get addAsset => 'Dodaj aktyw';

  @override
  String get editAsset => 'Edytuj aktyw';

  @override
  String get delete => 'Usuń';

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get currentValue => 'Bieżąca wartość';

  @override
  String get invested => 'Zainwestowano';

  @override
  String get pnl => 'PnL';

  @override
  String get profileTitle => 'Profil';

  @override
  String get settings => 'Ustawienia';

  @override
  String get appearance => 'Wygląd';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get language => 'Język';

  @override
  String get currency => 'Waluta';

  @override
  String get displayName => 'Nazwa profilu';

  @override
  String get changeAvatar => 'Zmień awatar';

  @override
  String get fromCamera => 'Z aparatu';

  @override
  String get fromGallery => 'Z galerii';

  @override
  String get removeAvatar => 'Usuń awatar';

  @override
  String get errorGeneric => 'Coś poszło nie tak';

  @override
  String get errorNetwork => 'Błąd sieci. Sprawdź połączenie';

  @override
  String get errorAuthInvalid => 'Nieprawidłowy email lub hasło';

  @override
  String get errorAuthExists => 'Konto już istnieje';

  @override
  String get errorAuthWeakPwd => 'Hasło jest zbyt słabe';

  @override
  String get errorAuthNotFound => 'Użytkownika nie znaleziono';

  @override
  String get privacy => 'Prywatność';

  @override
  String get hideBalances => 'Ukryj salda';

  @override
  String get hideBalancesHint => 'Maskuj kwoty w Portfelu i Podsumowaniu';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get changePassword => 'Zmień hasło';

  @override
  String get currentPassword => 'Bieżące hasło';

  @override
  String get newPassword => 'Nowe hasło';

  @override
  String get passwordChanged => 'Hasło zaktualizowane';

  @override
  String get deleteAccount => 'Usuń konto';

  @override
  String get deleteAccountConfirm => 'Usunąć konto?';

  @override
  String get deleteAccountDescription =>
      'To trwale usuwa Twój portfel i ustawienia. Nie można cofnąć.';

  @override
  String get confirmDelete => 'Usuń na zawsze';

  @override
  String get about => 'O aplikacji';

  @override
  String get version => 'Wersja';

  @override
  String get viewLicenses => 'Licencje open-source';

  @override
  String get termsOfUse => 'Warunki użytkowania';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get sourceCode => 'Kod źródłowy';

  @override
  String get edit => 'Edytuj';

  @override
  String get ok => 'OK';
}
