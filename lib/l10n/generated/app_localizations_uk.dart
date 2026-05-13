// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'CryptoTosentai';

  @override
  String get tabHome => 'Головна';

  @override
  String get tabPortfolio => 'Портфель';

  @override
  String get tabProfile => 'Профіль';

  @override
  String get loginTitle => 'З поверненням';

  @override
  String get loginSubtitle => 'Увійдіть, щоб слідкувати за крипто';

  @override
  String get registerTitle => 'Створити акаунт';

  @override
  String get registerSubtitle => 'Ваш портфель за кілька секунд';

  @override
  String get forgotTitle => 'Скинути пароль';

  @override
  String get forgotSubtitle => 'Ми надішлемо посилання для скидання';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Підтвердження пароля';

  @override
  String get name => 'Ім\'я';

  @override
  String get signIn => 'Увійти';

  @override
  String get signUp => 'Зареєструватись';

  @override
  String get signOut => 'Вийти';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get sendResetLink => 'Надіслати посилання';

  @override
  String get noAccount => 'Ще немає акаунту?';

  @override
  String get haveAccount => 'Вже маєте акаунт?';

  @override
  String get createAccount => 'Створити акаунт';

  @override
  String get backToLogin => 'Назад до входу';

  @override
  String get validationRequired => 'Обов\'язкове поле';

  @override
  String get validationEmail => 'Введіть коректний email';

  @override
  String validationMinChars(int n) {
    return 'Мінімум $n символів';
  }

  @override
  String get validationMatch => 'Паролі не збігаються';

  @override
  String get resetSent => 'Посилання надіслано на email';

  @override
  String get homeTitle => 'Ринки';

  @override
  String get search => 'Пошук монети або символу';

  @override
  String get sortBy => 'Сортувати';

  @override
  String get sortMarketCap => 'Капіталізація';

  @override
  String get sortPrice => 'Ціна';

  @override
  String get sortChange => 'Зміна 24г';

  @override
  String get pullToRefresh => 'Потягніть, щоб оновити';

  @override
  String get marketCap => 'Капіталізація';

  @override
  String get price => 'Ціна';

  @override
  String get change24h => '24г';

  @override
  String get detailsAddToPortfolio => 'Додати в портфель';

  @override
  String get detailsAth => 'Макс.';

  @override
  String get detailsAtl => 'Мін.';

  @override
  String get detailsVolume => 'Об\'єм';

  @override
  String get detailsCircSupply => 'В обігу';

  @override
  String get detailsChart7d => 'Графік за 7 днів';

  @override
  String get portfolioTitle => 'Портфель';

  @override
  String get portfolioEmpty => 'Ваш портфель порожній';

  @override
  String get portfolioEmptyHint => 'Додайте перший актив з вкладки Ринки';

  @override
  String get totalBalance => 'Загальний баланс';

  @override
  String get totalPnl => 'Загальний PnL';

  @override
  String get amount => 'Кількість';

  @override
  String get buyPrice => 'Ціна покупки';

  @override
  String get notes => 'Нотатки';

  @override
  String get addAsset => 'Додати актив';

  @override
  String get editAsset => 'Редагувати актив';

  @override
  String get delete => 'Видалити';

  @override
  String get save => 'Зберегти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get currentValue => 'Поточна вартість';

  @override
  String get invested => 'Інвестовано';

  @override
  String get pnl => 'PnL';

  @override
  String get profileTitle => 'Профіль';

  @override
  String get settings => 'Налаштування';

  @override
  String get appearance => 'Оформлення';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeSystem => 'Системна';

  @override
  String get language => 'Мова';

  @override
  String get currency => 'Валюта';

  @override
  String get displayName => 'Ім\'я профілю';

  @override
  String get changeAvatar => 'Змінити аватар';

  @override
  String get fromCamera => 'З камери';

  @override
  String get fromGallery => 'З галереї';

  @override
  String get removeAvatar => 'Видалити аватар';

  @override
  String get errorGeneric => 'Щось пішло не так';

  @override
  String get errorNetwork => 'Помилка мережі. Перевірте з\'єднання';

  @override
  String get errorAuthInvalid => 'Невірний email або пароль';

  @override
  String get errorAuthExists => 'Акаунт вже існує';

  @override
  String get errorAuthWeakPwd => 'Пароль занадто слабкий';

  @override
  String get errorAuthNotFound => 'Користувача не знайдено';

  @override
  String get privacy => 'Приватність';

  @override
  String get hideBalances => 'Режим інкогніто';

  @override
  String get hideBalancesHint => 'Маскувати суми у портфелі та сумарі';

  @override
  String get security => 'Безпека';

  @override
  String get changePassword => 'Змінити пароль';

  @override
  String get currentPassword => 'Поточний пароль';

  @override
  String get newPassword => 'Новий пароль';

  @override
  String get passwordChanged => 'Пароль оновлено';

  @override
  String get deleteAccount => 'Видалити акаунт';

  @override
  String get deleteAccountConfirm => 'Видалити акаунт?';

  @override
  String get deleteAccountDescription =>
      'Це остаточно видалить ваш портфель і налаштування. Дію неможливо скасувати.';

  @override
  String get confirmDelete => 'Видалити назавжди';

  @override
  String get about => 'Про додаток';

  @override
  String get version => 'Версія';

  @override
  String get viewLicenses => 'Open-source ліцензії';

  @override
  String get termsOfUse => 'Умови використання';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get sourceCode => 'Вихідний код';

  @override
  String get edit => 'Редагувати';

  @override
  String get ok => 'OK';
}
