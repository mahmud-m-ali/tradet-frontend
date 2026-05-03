import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('am'),
    Locale('ti'),
    Locale('om'),
    Locale('so'),
    Locale('gur'),
  ];

  /// Language display names (native script)
  static const Map<String, String> languageNames = {
    'en': 'English',
    'am': 'አማርኛ',
    'ti': 'ትግርኛ',
    'om': 'Afaan Oromoo',
    'so': 'Soomaali',
    'gur': 'ጉራጊኛ',
  };

  /// Short labels for the compact selector
  static const Map<String, String> languageShort = {
    'en': 'EN',
    'am': 'አማ',
    'ti': 'ትግ',
    'om': 'OM',
    'so': 'SO',
    'gur': 'ጉራ',
  };

  String get langCode => locale.languageCode;

  // ─── Common ──────────────────────────────────────
  String get appName => _t({'en': 'TradEt', 'am': 'ትሬድኢት', 'ti': 'ትሬድኢት', 'om': 'TradEt', 'so': 'TradEt', 'gur': 'ትሬድኢት'});
  String get retry => _t({'en': 'Retry', 'am': 'እንደገና ሞክር', 'ti': 'ደጊምካ ፈትን', 'om': "Irra deebi'i", 'so': 'Ku celi', 'gur': 'ዳግም ሞክር'});
  String get cancel => _t({'en': 'Cancel', 'am': 'ሰርዝ', 'ti': 'ሰርዝ', 'om': 'Haqi', 'so': 'Jooji', 'gur': 'ተው'});
  String get save => _t({'en': 'Save', 'am': 'አስቀምጥ', 'ti': 'ዓቅብ', 'om': "Olkaa'i", 'so': 'Kaydi', 'gur': 'አኖር'});
  String get submit => _t({'en': 'Submit', 'am': 'አስገባ', 'ti': 'ኣእቱ', 'om': 'Galchi', 'so': 'Gudbi', 'gur': 'አግባ'});
  String get loading => _t({'en': 'Loading...', 'am': 'በመጫን ላይ...', 'ti': 'ይጽዕን ኣሎ...', 'om': "Fe'aa jira...", 'so': 'Soo dejinayaa...', 'gur': 'ይጫናል...'});
  String get noData => _t({'en': 'No data available', 'am': 'ምንም ውሂብ የለም', 'ti': 'ዳታ የለን', 'om': 'Daataan hin argamne', 'so': 'Xog la heli maayo', 'gur': 'ምንም ሓበሬታ የለም'});
  String get etb => 'ETB';

  // ─── Auth ────────────────────────────────────────
  String get welcomeBack => _t({'en': 'Welcome back', 'am': 'እንኳን ደህና መጡ', 'ti': 'እንኳዕ ብደሓን መጻእካ', 'om': 'Baga nagaan dhufte', 'so': 'Ku soo dhawoow', 'gur': 'ደህና መጣህ'});
  String get fullName => _t({'en': 'Full Name', 'am': 'ሙሉ ስም', 'ti': 'ምሉእ ስም', 'om': 'Maqaa guutuu', 'so': 'Magaca oo dhan', 'gur': 'ሙሉ ስም'});
  String get phone => _t({'en': 'Phone', 'am': 'ስልክ', 'ti': 'ስልኪ', 'om': 'Bilbila', 'so': 'Telefoon', 'gur': 'ስልክ'});
  String get createAccount => _t({'en': 'Create Account', 'am': 'መለያ ፍጠር', 'ti': 'ኣካውንት ፍጠር', 'om': "Herrega uumi", 'so': 'Samee Akoon', 'gur': 'መለያ ፍጠር'});
  String get signInToContinue => _t({'en': 'Sign in to continue', 'am': 'ለመቀጠል ይግቡ', 'ti': 'ንምቕጻል እቶ', 'om': 'Itti fufuuf seeni', 'so': 'Si aad u sii waddo gal', 'gur': 'ለመቀጠር ግባ'});
  String get email => _t({'en': 'Email', 'am': 'ኢሜይል', 'ti': 'ኢመይል', 'om': 'Imeelii', 'so': 'Iimeel', 'gur': 'ኢሜይል'});
  String get emailRequired => _t({'en': 'Email is required', 'am': 'ኢሜይል ያስፈልጋል', 'ti': 'ኢመይል የድሊ', 'om': 'Imeeliin barbaachisaadha', 'so': 'Iimeel waa loo baahan yahay', 'gur': 'ኢሜይል ያስፈጋል'});
  String get password => _t({'en': 'Password', 'am': 'የይለፍ ቃል', 'ti': 'ቃል ምስጢር', 'om': 'Jecha darbii', 'so': 'Furaha sirta', 'gur': 'የምስጢር ቃል'});
  String get confirmPassword => _t({'en': 'Confirm Password', 'am': 'የይለፍ ቃል አረጋግጥ', 'ti': 'ቃል ምስጢር ኣረጋግጽ', 'om': 'Jecha darbii mirkaneessi', 'so': 'Xaqiiji furaha sirta', 'gur': 'የምስጢር ቃል አረጋግጥ'});
  String get passwordsDoNotMatch => _t({'en': 'Passwords do not match', 'am': 'የይለፍ ቃሎቹ አይዛመዱም', 'ti': 'ቃላት ምስጢር ኣይቃዶን', 'om': 'Jechoonni darbii wal hin fakkaatan', 'so': 'Furayaashu kuma mid ahayn', 'gur': 'የምስጢር ቃሎቹ አይዛመዱም'});
  String get passwordRequired => _t({'en': 'Password is required', 'am': 'የይለፍ ቃል ያስፈልጋል', 'ti': 'ቃል ምስጢር የድሊ', 'om': 'Jecha darbii barbaachisaadha', 'so': 'Furaha sirta waa loo baahan yahay', 'gur': 'የምስጢር ቃል ያስፈጋል'});
  String get signIn => _t({'en': 'Sign In', 'am': 'ግባ', 'ti': 'እቶ', 'om': 'Seeni', 'so': 'Gal', 'gur': 'ግባ'});
  String get register => _t({'en': 'Register', 'am': 'ይመዝገቡ', 'ti': 'ተመዝገብ', 'om': "Galmaa'i", 'so': 'Isdiiwaangeli', 'gur': 'ተመዝገብ'});
  String get dontHaveAccount => _t({'en': "Don't have an account?", 'am': 'መለያ የለዎትም?', 'ti': 'ኣካውንት የብልካን?', 'om': 'Herrega hin qabduu?', 'so': 'Akoon ma lihid?', 'gur': 'መለያ የብህም?'});
  String get logout => _t({'en': 'Logout', 'am': 'ውጣ', 'ti': 'ውጻእ', 'om': "Ba'i", 'so': 'Ka bax', 'gur': 'ውጣ'});
  String get serverSettings => _t({'en': 'Server Settings', 'am': 'የሰርቨር ቅንብሮች', 'ti': 'ቅጥዒ ሰርቨር', 'om': "Qindaa'ina sarvaraa", 'so': 'Dejinta server-ka', 'gur': 'የሰርቨር ማስተካከያ'});

  // ─── Dashboard ───────────────────────────────────
  String get assalamuAlaikum => _t({'en': 'Hello', 'am': 'ሰላም', 'ti': 'ሰላም', 'om': 'Akkam', 'so': 'Salaan', 'gur': 'ሰላም'});
  String get totalPortfolioValue => _t({'en': 'Total Portfolio Value', 'am': 'ጠቅላላ የፖርትፎሊዮ ዋጋ', 'ti': 'ጠቕላላ ዋጋ ፖርትፎሊዮ', 'om': 'Gatii waliigalaa poortfooliyoo', 'so': 'Qiimaha guud ee portfolio-ga', 'gur': 'ጠቅላላ የፖርትፎሊዮ ዋጋ'});
  String get halal => _t({'en': 'Halal', 'am': 'ሐላል', 'ti': 'ሐላል', 'om': 'Halaal', 'so': 'Xalaal', 'gur': 'ሐላል'});
  String get cashBalance => _t({'en': 'Cash Balance', 'am': 'ጥሬ ገንዘብ', 'ti': 'ቀሪ ገንዘብ', 'om': 'Haftee maallaqaa', 'so': 'Haraagaha lacagta', 'gur': 'ጥሬ ገንዘብ ቀሪ'});
  String get openOrders => _t({'en': 'Open Orders', 'am': 'ክፍት ትዕዛዞች', 'ti': 'ክፉት ትእዛዛት', 'om': 'Ajaja banaa', 'so': 'Dalabyo furan', 'gur': 'ክፍት ትእዛዛት'});
  String get holdings => _t({'en': 'Holdings', 'am': 'ይዞታዎች', 'ti': 'ዘለካ', 'om': 'Qabeenya', 'so': 'Hantida', 'gur': 'ንብረቶች'});
  String get kycStatus => _t({'en': 'KYC Status', 'am': 'KYC ሁኔታ', 'ti': 'KYC ኩነታ', 'om': 'Haala KYC', 'so': 'Xaalada KYC', 'gur': 'KYC ሁኔታ'});
  String get topMovers => _t({'en': 'Top Movers', 'am': 'ምርጥ ተንቀሳቃሾች', 'ti': 'ዝለዓሉ ተንቀሳቀስቲ', 'om': "Socho'ota guguufoo", 'so': 'Kuwa ugu dhaqaaqay', 'gur': 'ከፍ ያሉ ሸቀጦች'});
  String get topGainers => _t({'en': 'Top Gainers', 'am': 'ምርጥ ጨራሾች', 'ti': 'ዝለዓሉ ሃሳቢ', 'om': "Socho'ota olaanaa", 'so': 'Kuwa ugu sarreeya', 'gur': 'ከፍ ያሉ ጨራሾች'});
  String get topLosers => _t({'en': 'Top Losers', 'am': 'ከፍተኛ ቅናሾች', 'ti': 'ዝለዓሉ ተሸናፍቲ', 'om': "Mo'atota olaanaa", 'so': 'Kuwa ugu liita', 'gur': 'ከፍ ያሉ ወራጆች'});
  String get yourHoldings => _t({'en': 'Your Holdings', 'am': 'የእርስዎ ንብረቶች', 'ti': 'ናትካ ንብረት', 'om': 'Qabeenya kee', 'so': 'Hantidaada', 'gur': 'ያንተ ንብረቶች'});
  String get noHoldingsYet => _t({'en': 'No holdings yet', 'am': 'ገና ይዞታ የለም', 'ti': 'ገና ንብረት የለን', 'om': 'Hanga ammaatti qabeenya hin jiru', 'so': 'Wali hanti ma jirto', 'gur': 'ገና ንብረት የለም'});
  String get recentOrders => _t({'en': 'Recent Orders', 'am': 'የቅርብ ጊዜ ትዕዛዞች', 'ti': 'ናይ ቀረባ ትእዛዛት', 'om': 'Ajaja dhihoo', 'so': 'Dalabyadii ugu dambeeyay', 'gur': 'የቅርብ ጊዜ ትእዛዛት'});
  String get noOrdersYet => _t({'en': 'No orders yet', 'am': 'ገና ትዕዛዝ የለም', 'ti': 'ገና ትእዛዝ የለን', 'om': 'Hanga ammaatti ajajni hin jiru', 'so': 'Wali dalabyo ma jiraan', 'gur': 'ገና ትእዛዝ የለም'});
  String get quickAccess => _t({'en': 'Quick Access', 'am': 'ፈጣን መዳረሻ', 'ti': 'ቅልጡፍ ኣገባብ', 'om': 'Karaa saffisaa', 'so': 'Gal degdeg ah', 'gur': 'ፈጣን መንገድ'});
  String get exchangeRates => _t({'en': 'Exchange\nRates', 'am': 'የምንዛሬ\nተመን', 'ti': 'ናይ ምንዛሬ\nምጣነ', 'om': 'Gatii\njijjiirraa', 'so': 'Sicirka\nsarrifka', 'gur': 'የምንዛሬ\nዋጋ'});
  String get zakatCalculator => _t({'en': 'Zakat\nCalculator', 'am': 'የዘካት\nማስሊያ', 'ti': 'ናይ ዘካት\nቆጸራ', 'om': 'Herrega\nZakaataa', 'so': 'Xisaabinta\nSakada', 'gur': 'የዘካት\nቆጣሪ'});
  String get newsFeed => _t({'en': 'News\nFeed', 'am': 'ዜና\nምንጭ', 'ti': 'ዜና\nምንጪ', 'om': 'Oduu\nOdeeffannoo', 'so': 'Wararka\nCusub', 'gur': 'ዜና\nምንጭ'});
  String get priceAlerts => _t({'en': 'Price\nAlerts', 'am': 'የዋጋ\nማንቂያ', 'ti': 'ናይ ዋጋ\nመጠንቀቕታ', 'om': 'Beeksisa\nGatii', 'so': 'Digniin\nQiimo', 'gur': 'የዋጋ\nማስጠንቀቂያ'});
  String get refreshAllData => _t({'en': 'Refresh all data', 'am': 'ሁሉንም ውሂብ አድስ', 'ti': 'ኩሉ ዳታ ኣሐድስ', 'om': 'Daataa hunda haaromsi', 'so': 'Cusbooneysii xogta oo dhan', 'gur': 'ሁሉንም ሓበሬታ አድስ'});
  String get watchlist => _t({'en': 'Watchlist', 'am': 'ክትትል ዝርዝር', 'ti': 'ክትትል ዝርዝር', 'om': 'Hordofaa', 'so': 'Liiska Ilaalinta', 'gur': 'ክትትል ዝርዝር'});
  String get watchlistEmpty => _t({'en': 'Your watchlist is empty', 'am': 'የክትትል ዝርዝርዎ ባዶ ነው', 'ti': 'ዝርዝር ክትትልካ ባዶ እዩ', 'om': 'Liistii hordoffii kee duwwaa dha', 'so': 'Liistaha cilaayntaadu waa madhan', 'gur': 'የክትትል ዝርዝርህ ባዶ ነው'});
  String get tapStarToAdd => _t({'en': 'Tap ★ on any asset to add it here', 'am': 'ማንኛውም ንብረት ★ ን ነኩ ለማከል', 'ti': '★ ናይ ዝኾነ ትካል ተንኩ ክትወስኑ', 'om': 'Qabeenyaa kamiyyuu ★ tuqi as itti dabaluuf', 'so': 'Tabo ★ xoolaha kasta si aad halkan ugu darto', 'gur': 'ማንኛውም ንብረት ★ ን ርኩ ለመጨመር'});
  String get assetsTracked => _t({'en': 'assets tracked', 'am': 'ንብረቶች ይከታተላሉ', 'ti': 'ትካላት ይስዓቡ', 'om': 'qabeenya hordofame', 'so': 'hantiwadaag la socdo', 'gur': 'ንብረቶች ይከታተላሉ'});
  String get capitalAtRisk => _t({'en': 'Capital at Risk', 'am': 'ተጋላጭ ካፒታል', 'ti': 'ኣብ ሓደጋ ዘሎ ካፒታል', 'om': 'Kaappitaala Gaaga Jiru', 'so': 'Maalgelin Khatar', 'gur': 'ተጋላጭ ካፒታል'});
  String get transactions => _t({'en': 'Transactions', 'am': 'ግብይቶች', 'ti': 'ምትሕልላፍ', 'om': 'Hojii Mallaqa', 'so': 'Macaamilaadaha', 'gur': 'ግብይቶች'});
  String get viewHistory => _t({'en': 'View history', 'am': 'ታሪክ ይመልከቱ', 'ti': 'ታሪኽ ርአ', 'om': 'Seenaa ilaalee', 'so': 'Taariikhda eeg', 'gur': 'ታሪክ ይመልከቱ'});
  String get tradeNow => _t({'en': 'Trade', 'am': 'ይነግዱ', 'ti': 'ነግድ', 'om': 'Gurguri', 'so': 'Ganacsasho', 'gur': 'ይነግዱ'});
  String get addMoney => _t({'en': 'Add Money', 'am': 'ገንዘብ ጨምር', 'ti': 'ገንዘብ ወስኽ', 'om': 'Maallaqa Dabalii', 'so': 'Ku dar lacag', 'gur': 'ገንዘብ ጨምር'});
  String get followedMarkets => _t({'en': 'Followed Markets', 'am': 'የሚከታተሏቸው ገበያዎች', 'ti': 'ዝስዓብካዮም ዕዳጋታት', 'om': 'Gabaalee Hordofaman', 'so': 'Suuqyada la raacayo', 'gur': 'የሚከታተሏቸው ገቢያዎች'});
  String get wallet => _t({'en': 'Wallet', 'am': 'ቦርሳ', 'ti': 'ቦርሳ', 'om': 'Beesii', 'so': 'Boorsada', 'gur': 'ቦርሳ'});
  String get totalFund => _t({'en': 'Total Fund', 'am': 'ጠቅላላ ፈንድ', 'ti': 'ጠቕላሊ ፈንድ', 'om': 'Waligaa Maallaqa', 'so': 'Wadarta Dhaqaalaha', 'gur': 'ጠቅላላ ፈንድ'});
  String get exchange => _t({'en': 'Exchange', 'am': 'ምንዛሬ', 'ti': 'ምቅይያር', 'om': 'Jijjiiri', 'so': 'Beddel', 'gur': 'ምንዛሬ'});
  String get investments => _t({'en': 'Investments', 'am': 'ኢንቨስትመንቶች', 'ti': 'ምዋዓለ-ሃብቲ', 'om': 'Maallaqni Buusame', 'so': 'Maalgashiga', 'gur': 'ኢንቨስትሜንት'});
  String get addToWatchlist => _t({'en': 'Add to watchlist', 'am': 'ወደ ዝርዝር ጨምር', 'ti': 'ናብ ዝርዝር ወስኽ', 'om': 'Galmee hordoffii irratti dabali', 'so': 'U kudar liiska', 'gur': 'ወደ ዝርዝር ጨምር'});
  String get brokerageAccount => _t({'en': 'Brokerage account', 'am': 'የደላላ ሒሳብ', 'ti': 'ናይ ደላሊ ሕሳብ', 'om': 'Herrega Daldalaa', 'so': 'Xisaabta Dalaggaha', 'gur': 'የደላላ ሒሳብ'});
  String get shariaCompliantStocks => _t({'en': 'Sharia compliant stocks', 'am': 'ሸሪዓ ተገዢ አክሲዮኖች', 'ti': 'ሸሪዓ ዝኽተሉ ኣክስዮናት', 'om': "Aksiyoonii Shari'aa hordofu", 'so': 'Sahamaha ku habboon Shariicada', 'gur': 'ሸሪዓ ተስማሚ አክሲዮን'});
  String get investedIn => _t({'en': 'Invested in', 'am': 'ኢንቨስት ተደርጓል', 'ti': 'ኢንቨስት ተገይሩ', 'om': 'Keessa buufame', 'so': 'Lagu maalgeliyey', 'gur': 'ኢንቨስት ተደርጓል'});

  // ─── Market ──────────────────────────────────────
  String get market => _t({'en': 'Market', 'am': 'ገበያ', 'ti': 'ዕዳጋ', 'om': 'Gabaa', 'so': 'Suuqa', 'gur': 'ገቢያ'});
  String get searchStocks => _t({'en': 'Search stocks, commodities, sukuk...', 'am': 'አክሲዮኖች፣ ሸቀጦች፣ ሱኩክ ይፈልጉ...', 'ti': 'ኣክስዮን፣ ሸቐጥ፣ ሱኩክ ድለ...', 'om': 'Aksiyoonii, meeshaalee, sukuk barbaadi...', 'so': 'Raadi sahaamaha, badeecada, sukuk...', 'gur': 'አክሲዮን፣ ሸቀጥ፣ ሱኩክ ፈልግ...'});
  String get all => _t({'en': 'All', 'am': 'ሁሉም', 'ti': 'ኩሉ', 'om': 'Hundaa', 'so': 'Dhammaan', 'gur': 'ኩሉ'});
  String get commodities => _t({'en': 'Commodities', 'am': 'ሸቀጦች', 'ti': 'ሸቐጣት', 'om': 'Meeshaalee', 'so': 'Badeecooyin', 'gur': 'ሸቀጦች'});
  String get sukuk => _t({'en': 'Sukuk', 'am': 'ሱኩክ', 'ti': 'ሱኩክ', 'om': 'Sukuk', 'so': 'Sukuuk', 'gur': 'ሱኩክ'});
  String get equities => _t({'en': 'Equities', 'am': 'አክሲዮኖች', 'ti': 'ኣክስዮናት', 'om': 'Aksiyoonota', 'so': 'Sahaamaha', 'gur': 'አክሲዮናት'});
  String get halalOnly => _t({'en': 'Halal Only', 'am': 'ሐላል ብቻ', 'ti': 'ሐላል ጥራይ', 'om': 'Halaal qofa', 'so': 'Xalaal kaliya', 'gur': 'ሐላል ብቻ'});
  String get ecxCommodities => _t({'en': 'ECX Commodities', 'am': 'ECX ሸቀጦች', 'ti': 'ECX ሸቐጣት', 'om': 'Meeshaalee ECX', 'so': 'Badeecada ECX', 'gur': 'ECX ሸቀጦች'});
  String get sukukBonds => _t({'en': 'Sukuk Bonds', 'am': 'ሱኩክ ቦንዶች', 'ti': 'ሱኩክ ቦንዶች', 'om': 'Boondii Sukuk', 'so': 'Sukuuk Bondhka', 'gur': 'ሱኩክ ቦንድ'});
  String get halalEquities => _t({'en': 'Halal Equities', 'am': 'ሐላል አክሲዮኖች', 'ti': 'ሐላል ኣክስዮናት', 'om': 'Aksiyoonota Halaal', 'so': 'Sahaamaha Xalaal', 'gur': 'ሐላል አክሲዮናት'});
  String get asset => _t({'en': 'Asset', 'am': 'ንብረት', 'ti': 'ንብረት', 'om': 'Qabeenyaa', 'so': 'Hanti', 'gur': 'ንብረት'});
  String get category => _t({'en': 'Category', 'am': 'ምድብ', 'ti': 'ክፍሊ', 'om': 'Gosa', 'so': 'Qayb', 'gur': 'ክፍል'});
  String get bid => _t({'en': 'Bid', 'am': 'ጨረታ', 'ti': 'ጨረታ', 'om': 'Dhiheessii', 'so': 'Dalac', 'gur': 'ጨረታ'});
  String get ask => _t({'en': 'Ask', 'am': 'ጥያቄ', 'ti': 'ሕቶ', 'om': 'Gaafii', 'so': 'Weydii', 'gur': 'ጥያቄ'});
  String get chart => _t({'en': 'Chart', 'am': 'ቻርት', 'ti': 'ቻርት', 'om': 'Chaartii', 'so': 'Jaantuska', 'gur': 'ሰንጠረዥ'});
  String get price => _t({'en': 'Price', 'am': 'ዋጋ', 'ti': 'ዋጋ', 'om': 'Gatii', 'so': 'Qiimo', 'gur': 'ዋጋ'});
  String get change24h => _t({'en': '24h Change', 'am': '24ሰ ለውጥ', 'ti': '24ሰ ለውጢ', 'om': "Jijjiirama sa'a 24", 'so': 'Isbeddelka 24-ka saac', 'gur': '24 ሰዓት ለውጥ'});
  String get compliance => _t({'en': 'Compliance', 'am': 'ተገዢነት', 'ti': 'ተኣዛዝነት', 'om': 'Hordoffii', 'so': 'U hoggaansamid', 'gur': 'ተስማሚነት'});
  String get noAssetsFound => _t({'en': 'No assets found', 'am': 'ምንም ንብረት አልተገኘም', 'ti': 'ንብረት ኣይተረኸበን', 'om': 'Qabeenyi hin argamne', 'so': 'Hanti la heli maayo', 'gur': 'ምንም ንብረት አልተገኘም'});

  // ─── Orders ──────────────────────────────────────
  String get orders => _t({'en': 'Orders', 'am': 'ትዕዛዞች', 'ti': 'ትእዛዛት', 'om': 'Ajajota', 'so': 'Dalabyo', 'gur': 'ትእዛዛት'});
  String get tradeHistory => _t({'en': 'Trade history', 'am': 'የንግድ ታሪክ', 'ti': 'ታሪኽ ንግዲ', 'om': 'Seenaa daldala', 'so': 'Taariikhda ganacsiga', 'gur': 'የንግድ ታሪክ'});
  String get type => _t({'en': 'Type', 'am': 'ዓይነት', 'ti': 'ዓይነት', 'om': 'Gosa', 'so': 'Nooca', 'gur': 'ዓይነት'});
  String get quantity => _t({'en': 'Quantity', 'am': 'ብዛት', 'ti': 'ብዝሒ', 'om': "Baay'ina", 'so': 'Tirada', 'gur': 'ብዛት'});
  String get total => _t({'en': 'Total', 'am': 'ጠቅላላ', 'ti': 'ጠቕላላ', 'om': 'Waliigala', 'so': 'Wadarta', 'gur': 'ድምር'});
  String get fee => _t({'en': 'Fee', 'am': 'ክፍያ', 'ti': 'ክፍሊት', 'om': 'Kaffaltii', 'so': 'Khidmad', 'gur': 'ክፍያ'});
  String get status => _t({'en': 'Status', 'am': 'ሁኔታ', 'ti': 'ኩነታ', 'om': 'Haala', 'so': 'Xaalada', 'gur': 'ሁኔታ'});
  String get date => _t({'en': 'Date', 'am': 'ቀን', 'ti': 'ዕለት', 'om': 'Guyyaa', 'so': 'Taariikhda', 'gur': 'ቀን'});
  String get buy => _t({'en': 'BUY', 'am': 'ግዛ', 'ti': 'ግዛእ', 'om': 'BITI', 'so': 'IIBSO', 'gur': 'ግዛ'});
  String get sell => _t({'en': 'SELL', 'am': 'ሽጥ', 'ti': 'ሸይጥ', 'om': 'GURGURI', 'so': 'IIB', 'gur': 'ሽጥ'});

  // ─── Portfolio ───────────────────────────────────
  String get portfolio => _t({'en': 'Portfolio', 'am': 'ፖርትፎሊዮ', 'ti': 'ፖርትፎሊዮ', 'om': 'Poortfooliyoo', 'so': 'Portfolio', 'gur': 'ፖርትፎሊዮ'});
  String get totalValue => _t({'en': 'Total Value', 'am': 'ጠቅላላ ዋጋ', 'ti': 'ጠቕላላ ዋጋ', 'om': 'Gatii waliigalaa', 'so': 'Qiimaha guud', 'gur': 'ድምር ዋጋ'});
  String get cash => _t({'en': 'Cash', 'am': 'ጥሬ ገንዘብ', 'ti': 'ጥረ ገንዘብ', 'om': 'Maallaqa', 'so': 'Lacag', 'gur': 'ጥሬ ገንዘብ'});
  String get pnl => _t({'en': 'P&L', 'am': 'ትርፍ/ኪሳራ', 'ti': 'ትርፊ/ክሳራ', 'om': "Bu'aa/Kasaaraa", 'so': "Faa'iido/Khasaare", 'gur': 'ትርፍ/ኪሳራ'});
  String get quickStats => _t({'en': 'Quick Stats', 'am': 'ፈጣን ስታቲስቲክ', 'ti': 'ቅልጡፍ ስታቲስቲክ', 'om': 'Istaatistiksii saffisaa', 'so': 'Tirakoob degdeg ah', 'gur': 'ፈጣን ስታቲስቲክ'});
  String get totalInvested => _t({'en': 'Total Invested', 'am': 'ጠቅላላ ኢንቨስትመንት', 'ti': 'ጠቕላላ ኢንቨስትመንት', 'om': 'Waliigala invastimantii', 'so': 'Wadarta maalgelinta', 'gur': 'ድምር ኢንቨስትመንት'});
  String get holdingsValue => _t({'en': 'Holdings Value', 'am': 'የይዞታ ዋጋ', 'ti': 'ዋጋ ዝሒዝካ', 'om': 'Gatii qabeenyaa', 'so': 'Qiimaha hantida', 'gur': 'የንብረት ዋጋ'});
  String get returnLabel => _t({'en': 'Return', 'am': 'ትርፍ', 'ti': 'ትርፊ', 'om': "Bu'aa", 'so': "Faa'iido", 'gur': 'ትርፍ'});
  String get avgPrice => _t({'en': 'Avg Price', 'am': 'አማካይ ዋጋ', 'ti': 'ማእከላይ ዋጋ', 'om': 'Gatii giddugaleessa', 'so': 'Qiimaha celceliska', 'gur': 'አማካይ ዋጋ'});
  String get current => _t({'en': 'Current', 'am': 'ወቅታዊ', 'ti': 'ህሉው', 'om': 'Ammaa', 'so': 'Hadda', 'gur': 'ያሁኑ'});
  String get value => _t({'en': 'Value', 'am': 'ዋጋ', 'ti': 'ዋጋ', 'om': 'Gatii', 'so': 'Qiimo', 'gur': 'ዋጋ'});
  String get startTrading => _t({'en': 'Start trading to build your portfolio', 'am': 'ፖርትፎሊዮዎን ለመገንባት ንግድ ይጀምሩ', 'ti': 'ፖርትፎሊዮኻ ንምህናጽ ንግዲ ጀምር', 'om': 'Poortfooliyoo kee ijaaruuf daldaluu jalqabi', 'so': 'Bilow ganacsiga si aad u dhisto portfolio-gaaga', 'gur': 'ፖርትፎሊዮህን ለመስራት ንግድ ጀምር'});
  String get depositEtb => _t({'en': 'Deposit ETB', 'am': 'ገንዘብ አስገባ', 'ti': 'ገንዘብ ኣእቱ', 'om': 'ETB galchi', 'so': 'Dhig ETB', 'gur': 'ገንዘብ አግባ'});
  String get deposit => _t({'en': 'Deposit', 'am': 'አስገባ', 'ti': 'ኣእቱ', 'om': 'Galchi', 'so': 'Dhig', 'gur': 'አግባ'});
  String get withdrawEtb => _t({'en': 'Withdraw ETB', 'am': 'ገንዘብ አውጣ', 'ti': 'ገንዘብ ኣውጽእ', 'om': 'ETB baasi', 'so': 'Ka saar ETB', 'gur': 'ገንዘብ አውጣ'});
  String get withdraw => _t({'en': 'Withdraw', 'am': 'አውጣ', 'ti': 'ኣውጽእ', 'om': 'Baasi', 'so': 'Ka saar', 'gur': 'አውጣ'});
  String get selectBank => _t({'en': 'Select Bank', 'am': 'ባንክ ይምረጡ', 'ti': 'ባንክ ምረጽ', 'om': 'Baankii filadhu', 'so': 'Dooro bangiga', 'gur': 'ባንክ ምረጥ'});
  String get accountNumber => _t({'en': 'Account Number', 'am': 'የሒሳብ ቁጥር', 'ti': 'ቁጽሪ ኣካውንት', 'om': 'Lakkoofsa herregaa', 'so': 'Lambarka akoonka', 'gur': 'የሒሳብ ቁጥር'});
  String get bankRequired => _t({'en': 'Please select a bank', 'am': 'እባክዎ ባንክ ይምረጡ', 'ti': 'በጃኻ ባንክ ምረጽ', 'om': 'Maaloo baankii filadhaa', 'so': 'Fadlan dooro bangiga', 'gur': 'እባክህ ባንክ ምረጥ'});
  String get marketOrder => _t({'en': 'Market', 'am': 'ገበያ', 'ti': 'ዕዳጋ', 'om': 'Gabaa', 'so': 'Suuqa', 'gur': 'ገቢያ'});
  String get limitOrder => _t({'en': 'Limit', 'am': 'ሊሚት', 'ti': 'ሊሚት', 'om': 'Daangaa', 'so': 'Xad', 'gur': 'ገደብ'});
  String get limitPrice => _t({'en': 'Limit Price', 'am': 'የሊሚት ዋጋ', 'ti': 'ናይ ሊሚት ዋጋ', 'om': 'Gatii daangaa', 'so': 'Qiimaha xadka', 'gur': 'የገደብ ዋጋ'});
  String get confirmBuy => _t({'en': 'Confirm Buy', 'am': 'ግዢ አረጋግጥ', 'ti': 'ምዕዳግ ኣረጋግጽ', 'om': 'Bituu mirkaneessi', 'so': 'Xaqiiji Iibsashada', 'gur': 'ግዢ አረጋግጥ'});
  String get confirmSell => _t({'en': 'Confirm Sell', 'am': 'ሽያጭ አረጋግጥ', 'ti': 'ሽያጥ ኣረጋግጽ', 'om': 'Gurguruuf mirkaneessi', 'so': 'Xaqiiji Iibishada', 'gur': 'ሽያጭ አረጋግጥ'});
  String get placeOrder => _t({'en': 'Place Order', 'am': 'ትዕዛዝ ያስገቡ', 'ti': 'ትእዛዝ ኣቐምጥ', 'om': 'Ajaja kaa\'i', 'so': 'Dhig Dalabka', 'gur': 'ትዕዛዝ አኑር'});
  String get placeBuyOrder => _t({'en': 'Place Buy Order', 'am': 'የግዢ ትዕዛዝ ያስገቡ', 'ti': 'ትእዛዝ ምዕዳግ ኣቐምጥ', 'om': "Ajaja bituuf kaa'i", 'so': 'Dhig Dalabka Iibsashada', 'gur': 'የግዢ ትዕዛዝ አኑር'});
  String get placeSellOrder => _t({'en': 'Place Sell Order', 'am': 'የሽያጭ ትዕዛዝ ያስገቡ', 'ti': 'ትእዛዝ ሽያጥ ኣቐምጥ', 'om': "Ajaja gurguruuf kaa'i", 'so': 'Dhig Dalabka Iibinta', 'gur': 'የሽያጭ ትዕዛዝ አኑር'});
  String get insufficientBalance => _t({'en': 'Insufficient balance', 'am': 'በቂ ቀሪ ሂሳብ የለም', 'ti': 'ዝተረፈ ናይ ሒሳብ ኣይፈቅድን', 'om': 'Balansin ga\'a dha', 'so': 'Dhaqaale ku filan ma jiro', 'gur': 'ብቁ ሒሳብ የለም'});
  String get noHoldingsToSell => _t({'en': 'No holdings to sell', 'am': 'ለሽያጭ ይዞታ የለም', 'ti': 'ንሽያጥ ዘለካ ንብረት የለን', 'om': 'Gurguruu kan qabdu qabeenya hin jiru', 'so': 'Hanti iibin ah ma jirto', 'gur': 'ለሽያጭ ንብረት የለም'});
  String get exceedsHoldings => _t({'en': 'Exceeds holdings', 'am': 'ይዞታን ያልፋል', 'ti': 'ካብ ንብረትካ ይበዝሕ', 'om': 'Qabeenya darbee', 'so': 'Ka badan hantida', 'gur': 'ንብረቱን ይበልጣል'});

  // ─── Profile ─────────────────────────────────────
  String get profile => _t({'en': 'Profile', 'am': 'መገለጫ', 'ti': 'ፕሮፋይል', 'om': 'Piroofaayilii', 'so': 'Bogga shaqsiga', 'gur': 'መገለጫ'});
  String get accountSettings => _t({'en': 'Account settings', 'am': 'የመለያ ቅንብሮች', 'ti': 'ቅጥዒ ኣካውንት', 'om': "Qindaa'ina herregaa", 'so': 'Dejinta akoonka', 'gur': 'የመለያ ማስተካከያ'});
  String get kycVerificationRequired => _t({'en': 'KYC Verification Required', 'am': 'KYC ማረጋገጫ ያስፈልጋል', 'ti': 'KYC ምርግጋጽ የድሊ', 'om': 'Mirkaneessa KYC barbaachisa', 'so': 'Xaqiijinta KYC ayaa loo baahan yahay', 'gur': 'KYC ማረጋገጫ ያስፈጋል'});
  String get completeKyc => _t({'en': 'Complete KYC', 'am': 'ማንነት ያረጋግጡ', 'ti': 'KYC ዛዝም', 'om': 'KYC guuti', 'so': 'Dhammaystir KYC', 'gur': 'ማንነት አረጋግጥ'});
  String get shariaCompliant => _t({'en': 'Sharia Compliant (AAOIFI)', 'am': 'ሸሪዓ ተገዢ (AAOIFI)', 'ti': 'ሸሪዓ ተኣዛዛይ (AAOIFI)', 'om': "Shari'aa wajjin walsimatu (AAOIFI)", 'so': 'Ku habboon Shariicada (AAOIFI)', 'gur': 'ሸሪዓ ተስማሚ (AAOIFI)'});
  String get ecxRegulated => _t({'en': 'ECX Regulated', 'am': 'ECX ቁጥጥር', 'ti': 'ECX ቁጽጽር', 'om': "ECX to'annoo", 'so': 'ECX xakamaynta', 'gur': 'ECX ቁጥጥር'});
  String get nbeSupervised => _t({'en': 'NBE Supervised', 'am': 'NBE ቁጥጥር', 'ti': 'NBE ቁጽጽር', 'om': "NBE to'annoo", 'so': 'NBE kormeerka', 'gur': 'NBE ቁጥጥር'});
  String get noInterest => _t({'en': 'No Interest (Riba-Free)', 'am': 'ወለድ የለም (ሪባ-ነጻ)', 'ti': 'ወለድ የለን (ሪባ-ነጻ)', 'om': 'Dhala hin qabu (Ribaa-bilisa)', 'so': "Ribada la'aan (Riba-Free)", 'gur': 'ወለድ የለም (ሪባ ነጻ)'});
  String get noShortSelling => _t({'en': 'No Short Selling', 'am': 'ሾርት ሴሊንግ የለም', 'ti': 'ሾርት ሴሊንግ የለን', 'om': 'Short selling hin jiru', 'so': "Iibinta gaaban la'aan", 'gur': 'አጭር ሽያጭ የለም'});
  String get theme => _t({'en': 'Theme', 'am': 'ገጽታ', 'ti': 'ገጽታ', 'om': "Akkaataa mul'ataa", 'so': 'Muuqaalka', 'gur': 'ገጽታ'});
  String get darkMode => _t({'en': 'Dark mode', 'am': 'ጨለማ ገጽታ', 'ti': 'ጸሊም ገጽታ', 'om': 'Haala dukkana', 'so': 'Habka mugdiga', 'gur': 'ጨለማ ገጽታ'});
  String get lightMode => _t({'en': 'Light mode', 'am': 'ብሩህ ገጽታ', 'ti': 'ብሩህ ገጽታ', 'om': 'Haala ifaa', 'so': 'Habka iftiinka', 'gur': 'ብሩህ ገጽታ'});
  String get language => _t({'en': 'Language', 'am': 'ቋንቋ', 'ti': 'ቋንቋ', 'om': 'Afaan', 'so': 'Luuqada', 'gur': 'ቋንቋ'});
  String get notifications => _t({'en': 'Notifications', 'am': 'ማሳወቂያ', 'ti': 'ሓበሬታ', 'om': 'Beeksisa', 'so': 'Ogeysiis', 'gur': 'ማስታወቂያ'});
  String get security => _t({'en': 'Security', 'am': 'ደህንነት', 'ti': 'ድሕንነት', 'om': 'Nageenyummaa', 'so': 'Amniga', 'gur': 'ደህንነት'});
  String get help => _t({'en': 'Help', 'am': 'እርዳታ', 'ti': 'ሓገዝ', 'om': 'Gargaarsa', 'so': 'Caawin', 'gur': 'እርዳታ'});

  // ─── News ────────────────────────────────────────
  String get ethiopia => _t({'en': 'Ethiopia', 'am': 'ኢትዮጵያ', 'ti': 'ኢትዮጵያ', 'om': 'Itoophiyaa', 'so': 'Itoobiya', 'gur': 'ኢትዮጵያ'});
  String get islamicFinance => _t({'en': 'Islamic Finance', 'am': 'እስላማዊ ፋይናንስ', 'ti': 'ኢስላማዊ ፋይናንስ', 'om': 'Faayinaansii Islaamaa', 'so': 'Maaliyadda Islaamiga', 'gur': 'ኢስላማዊ ፋይናንስ'});
  String get global => _t({'en': 'Global', 'am': 'ዓለም አቀፍ', 'ti': 'ዓለምለኻዊ', 'om': 'Addunyaa', 'so': 'Caalamiga', 'gur': 'ዓለም አቀፍ'});
  // ─── Zakat ───────────────────────────────────────
  String get zakatCalculatorTitle => _t({'en': 'Zakat Calculator', 'am': 'የዘካት ማስሊያ', 'ti': 'ናይ ዘካት ቆጸራ', 'om': 'Herrega Zakaataa', 'so': 'Xisaabinta Sakada', 'gur': 'የዘካት ቆጣሪ'});
  String get additionalWealth => _t({'en': 'Additional Wealth', 'am': 'ተጨማሪ ሀብት', 'ti': 'ተወሳኺ ሃብቲ', 'om': 'Qabeenya dabalataa', 'so': 'Maal dheeraad ah', 'gur': 'ተጨማሪ ሀብት'});
  String get otherSavings => _t({'en': 'Other Savings (ETB)', 'am': 'ሌላ ቁጠባ (ETB)', 'ti': 'ካልእ ዕቃባ (ETB)', 'om': 'Qusannoo biroo (ETB)', 'so': 'Kaydka kale (ETB)', 'gur': 'ሌላ ቁጠባ (ETB)'});
  String get goldValue => _t({'en': 'Gold Value (ETB)', 'am': 'የወርቅ ዋጋ (ETB)', 'ti': 'ዋጋ ወርቂ (ETB)', 'om': 'Gatii warqee (ETB)', 'so': 'Qiimaha dahabka (ETB)', 'gur': 'የወርቅ ዋጋ (ETB)'});
  String get silverValue => _t({'en': 'Silver Value (ETB)', 'am': 'የብር ዋጋ (ETB)', 'ti': 'ዋጋ ብሩር (ETB)', 'om': 'Gatii meetii (ETB)', 'so': 'Qiimaha lacagta (ETB)', 'gur': 'የብር ዋጋ (ETB)'});
  String get deductions => _t({'en': 'Deductions', 'am': 'ቅነሳዎች', 'ti': 'ምጕዳል', 'om': "Hir'isuu", 'so': 'Jaridaadka', 'gur': 'ቅናሾች'});
  String get outstandingDebts => _t({'en': 'Outstanding Debts (ETB)', 'am': 'ያልተከፈለ ዕዳ (ETB)', 'ti': 'ዘይተኸፍለ ዕዳ (ETB)', 'om': 'Liqaa hafee (ETB)', 'so': 'Deymaha aan la bixin (ETB)', 'gur': 'ያልተከፈለ ዕዳ (ETB)'});
  String get essentialExpenses => _t({'en': 'Essential Expenses (ETB)', 'am': 'አስፈላጊ ወጪዎች (ETB)', 'ti': 'ኣገደስቲ ወጻኢታት (ETB)', 'om': 'Baasii barbaachisaa (ETB)', 'so': 'Kharashka lagama maarmaanka (ETB)', 'gur': 'አስፈላጊ ወጪዎች (ETB)'});
  String get nisabMethod => _t({'en': 'Nisab Method', 'am': 'የኒሳብ ዘዴ', 'ti': 'ኣገባብ ኒሳብ', 'om': 'Mala Nisaabii', 'so': 'Habka Nisaabka', 'gur': 'የኒሳብ ዘዴ'});
  String get calculateZakat => _t({'en': 'Calculate Zakat', 'am': 'ዘካት ያስሉ', 'ti': 'ዘካት ቆጽር', 'om': 'Zakaata herreegi', 'so': 'Xisaabi Sakada', 'gur': 'ዘካት ቁጠር'});
  String get zakatObligatory => _t({'en': 'Zakat is Obligatory', 'am': 'ዘካት ይከፈላል', 'ti': 'ዘካት ግዴታ እዩ', 'om': 'Zakaanni dirqama', 'so': 'Sakadu waa waajib', 'gur': 'ዘካት ግዴታ ነው'});
  String get zakatNotDue => _t({'en': 'Zakat Not Due', 'am': 'ዘካት አይከፈልም', 'ti': 'ዘካት ኣየድልን', 'om': 'Zakaanni hin barbaachisu', 'so': 'Sakadu lagama rabto', 'gur': 'ዘካት አያስፈልግም'});
  String get totalWealth => _t({'en': 'Total Wealth', 'am': 'ጠቅላላ ሀብት', 'ti': 'ጠቕላላ ሃብቲ', 'om': 'Qabeenya waliigalaa', 'so': 'Maalka guud', 'gur': 'ድምር ሀብት'});
  String get netWealth => _t({'en': 'Net Wealth', 'am': 'ተጣሪ ሀብት', 'ti': 'ተጣሪ ሃብቲ', 'om': 'Qabeenya qulqulluu', 'so': 'Maalka saafiga', 'gur': 'ንጹህ ሀብት'});
  String get nisab => _t({'en': 'Nisab', 'am': 'ኒሳብ', 'ti': 'ኒሳብ', 'om': 'Nisaabii', 'so': 'Nisaab', 'gur': 'ኒሳብ'});
  String get breakdown => _t({'en': 'Breakdown', 'am': 'ዝርዝር', 'ti': 'ዝርዝር', 'om': 'Caqasa', 'so': 'Faahfaahin', 'gur': 'ዝርዝር'});

  // ─── Navigation ──────────────────────────────────
  String get dashboard => _t({'en': 'Dashboard', 'am': 'ዳሽቦርድ', 'ti': 'ዳሽቦርድ', 'om': 'Daashboordii', 'so': 'Dashboard', 'gur': 'ዳሽቦርድ'});
  String get home => _t({'en': 'Home', 'am': 'መነሻ', 'ti': 'ገዛ', 'om': 'Mana', 'so': 'Bogga hore', 'gur': 'ቤት'});
  String get more => _t({'en': 'More', 'am': 'ተጨማሪ', 'ti': 'ተወሳኺ', 'om': 'Dabalata', 'so': 'Wax badan', 'gur': 'ተጨማሪ'});
  String get moreFeatures => _t({'en': 'More Features', 'am': 'ተጨማሪ ባህሪያት', 'ti': 'ተወሳኺ ባህሪታት', 'om': 'Amaloota dabalataa', 'so': 'Sifo badan', 'gur': 'ተጨማሪ ባህሪያት'});
  String get analytics => _t({'en': 'Analytics', 'am': 'ትንተና', 'ti': 'ትንተና', 'om': 'Xiinxala', 'so': 'Falanqaynta', 'gur': 'ትንተና'});

  // ─── KYC ─────────────────────────────────────────
  String get kycVerification => _t({'en': 'KYC Verification', 'am': 'ማንነት ማረጋገጫ', 'ti': 'ምርግጋጽ KYC', 'om': 'Mirkaneessa KYC', 'so': 'Xaqiijinta KYC', 'gur': 'ማንነት ማረጋገጫ'});
  String get idType => _t({'en': 'ID Type', 'am': 'የመታወቂያ አይነት', 'ti': 'ዓይነት መንነት', 'om': 'Gosa eenyummaa', 'so': 'Nooca aqoonsiga', 'gur': 'የመታወቂያ ዓይነት'});
  String get nationalId => _t({'en': 'National ID', 'am': 'ብሔራዊ መታወቂያ', 'ti': 'ሃገራዊ መንነት', 'om': 'Eenyummaa biyyaalessaa', 'so': 'Aqoonsiga qaranka', 'gur': 'ሀገራዊ መታወቂያ'});
  String get passport => _t({'en': 'Passport', 'am': 'ፓስፖርት', 'ti': 'ፓስፖርት', 'om': 'Paaspoortii', 'so': 'Baasaboor', 'gur': 'ፓስፖርት'});
  String get driversLicense => _t({'en': "Driver's License", 'am': 'መንጃ ፈቃድ', 'ti': 'ፍቓድ መዘወር', 'om': 'Hayyama konkolaachisummaa', 'so': 'Shatiga darawalnimada', 'gur': 'መንጃ ፈቃድ'});
  String get kebeleId => _t({'en': 'Kebele ID', 'am': 'የቀበሌ መታወቂያ', 'ti': 'መንነት ቀበሌ', 'om': 'Eenyummaa gandaa', 'so': 'Aqoonsiga kebele', 'gur': 'የቀበሌ መታወቂያ'});
  String get idNumber => _t({'en': 'ID Number', 'am': 'መታወቂያ ቁጥር', 'ti': 'ቁጽሪ መንነት', 'om': 'Lakkoofsa eenyummaa', 'so': 'Lambarka aqoonsiga', 'gur': 'መታወቂያ ቁጥር'});
  String get kycVerified => _t({'en': 'KYC Verified', 'am': 'KYC ተረጋግጧል', 'ti': 'KYC ተረጋጊጹ', 'om': "KYC mirkanaa'eera", 'so': 'KYC waa la xaqiijiyay', 'gur': 'KYC ተረጋግጧል'});
  String get kycPending => _t({'en': 'KYC Pending', 'am': 'KYC በመጠባበቅ ላይ', 'ti': 'KYC ይጽበ ኣሎ', 'om': 'KYC eegamaa jira', 'so': 'KYC waa sugitaan', 'gur': 'KYC ይጠብቃል'});

  // ─── Security / Compliance (Phase 8) ─────────────
  String get securityLog => _t({'en': 'Security Log', 'am': 'የደህንነት ምዝግብ', 'ti': 'ናይ ድሕንነት ምዝገባ', 'om': 'Galmee nageenyaa', 'so': 'Diiwaanka amniga', 'gur': 'የደህንነት ምዝግብ'});
  String get exportSecurityReport => _t({'en': 'Export Security Report', 'am': 'የደህንነት ሪፖርት ላክ', 'ti': 'ሪፖርት ድሕንነት ስደድ', 'om': 'Gabaasa nageenyaa ergii', 'so': 'Dhoofso warbixinta amniga', 'gur': 'የደህንነት ሪፖርት ላክ'});
  String get shariaComplianceScore => _t({'en': 'Sharia Compliance Score', 'am': 'የሸሪዓ ተከታይ ውጤት', 'ti': 'ነጥቢ ምትሕሓዝ ሸሪዓ', 'om': 'Qabxii hordoffii Shari\'aa', 'so': 'Dhibcaha u hoggaansamida Sharciga', 'gur': 'የሸሪዓ ተከታዩ ነጥብ'});
  String get appLock => _t({'en': 'App Lock', 'am': 'የመተግበሪያ ቀንዲል', 'ti': 'ቀጽሪ ኣፕ', 'om': 'Cufaa Appii', 'so': 'Kilida App-ka', 'gur': 'የመተግበሪያ ቀጸላ'});
  String get sessionExpired => _t({'en': 'Session expired. Please sign in again.', 'am': 'ክፍለ ጊዜ አልቋል። እንደገና ይግቡ።', 'ti': 'ክፍለ-ጊዜ ጠቅሊሉ። ደጊምካ እቶ።', 'om': "Seeshiniin dhumate. Irra deebi'ii seeni.", 'so': 'Waqtigii session-ku dhacay. Mar kale gal.', 'gur': 'ክፍለ ጊዜ አልቋል። ደጊም ግባ።'});
  String get wealthProtection => _t({'en': 'Wealth Protection', 'am': 'የሀብት ጥበቃ', 'ti': 'ሓለዋ ሃብቲ', 'om': 'Eegumsa qabeenyaa', 'so': 'Ilaalinta hantida', 'gur': 'የሀብት ጥበቃ'});
  String get authRequired => _t({'en': 'Authentication Required', 'am': 'ማረጋገጫ ያስፈልጋል', 'ti': 'ምርግጋጽ የድሊ', 'om': 'Mirkaneessuu barbaachisaa dha', 'so': 'Xaqiijinta ayaa loo baahan yahay', 'gur': 'ማረጋገጫ ያስፈልጋል'});
  String get authFailed => _t({'en': 'Authentication failed. Action cancelled.', 'am': 'ማረጋገጫ አልተሳካም። ተሰርዟል።', 'ti': 'ምርግጋጽ ኣይተዓወተን። ተሰሪዙ።', 'om': 'Mirkaneessuu hin milkoofne. Hojiin haqame.', 'so': 'Xaqiijintu way fashilantay. Howshu waa la joojiyay.', 'gur': 'ማረጋገጫ ሳይሳካ። ሰርዟል።'});
  String get authRequiredPayment => _t({'en': 'Authentication required to add a payment method.', 'am': 'የክፍያ ዘዴ ለማከል ማረጋገጫ ያስፈልጋል።', 'ti': 'ንምውሳኽ ኣገባብ ክፍሊት ምርግጋጽ የድሊ።', 'om': 'Mala kaffaltii dabaluu mirkaneessuu barbaachisa.', 'so': 'Si aad u darto habka lacag bixinta, xaqiijin ayaa loo baahan yahay.', 'gur': 'ክፍያ ዘዴ ለመጨመር ማረጋገጫ ያስፈልጋል።'});
  String get authRequiredOrder => _t({'en': 'Authentication required to place order.', 'am': 'ትዕዛዝ ለመስጠት ማረጋገጫ ያስፈልጋል።', 'ti': 'ትዕዛዝ ንምምሃዝ ምርግጋጽ የድሊ።', 'om': 'Ajaja kennuu mirkaneessuu barbaachisa.', 'so': 'Si aad u gasho amarku, xaqiijin ayaa loo baahan yahay.', 'gur': 'ትዕዛዝ ለመስጠት ማረጋገጫ ያስፈልጋል།'});
  String get authRequiredWithdraw => _t({'en': 'Authentication required for withdrawals over 5,000 ETB.', 'am': 'ከ5,000 ብር በላይ ለሚሆን ወጪ ማረጋገጫ ያስፈልጋል።', 'ti': 'ካብ 5,000 ብር ንላዕሊ ንዝኾነ ምውጻእ ምርግጋጽ የድሊ።', 'om': 'Ka baasuu 5,000 ETBn ol ta\'eef mirkaneessuu barbaachisa.', 'so': 'Lacag-bixinta ka badan 5,000 ETB, xaqiijin ayaa loo baahan yahay.', 'gur': 'ከ5,000 ብር በላይ ለሚሆን ክፍያ ማረጋገጫ ያስፈልጋል።'});

  // ─── Profile menu / sub-pages ────────────────────
  String get account => _t({'en': 'Account', 'am': 'መለያ', 'ti': 'ኣካውንት', 'om': 'Herrega', 'so': 'Akoon', 'gur': 'መለያ'});
  String get complianceDocuments => _t({'en': 'Compliance & Documents', 'am': 'ተገዢነት እና ሰነዶች', 'ti': 'ተኣዛዝነት ሰነዳት', 'om': 'Hordoffii fi Sanadota', 'so': 'U hoggaansamid & Dukumiintiyada', 'gur': 'ተስማሚነት እና ሰነዶች'});
  String get learn => _t({'en': 'Learn', 'am': 'ተማር', 'ti': 'ተማሃር', 'om': 'Baradhu', 'so': 'Baraddo', 'gur': 'ተማር'});
  String get inbox => _t({'en': 'Inbox', 'am': 'መልዕክት ሳጥን', 'ti': 'ናይ ወሃቢ ሳጹን', 'om': 'Saanduqa dhuftuu', 'so': 'Sanduuqa gelitaanka', 'gur': 'መልዕክት ሣጥን'});
  String get privacy => _t({'en': 'Privacy', 'am': 'ግላዊነት', 'ti': 'ውልቃዊነት', 'om': 'Dhuunfaa', 'so': 'Xurmada', 'gur': 'ግላዊነት'});
  String get appearance => _t({'en': 'Appearance', 'am': 'መልክ', 'ti': 'ትርኢት', 'om': 'Mul\'ata', 'so': 'Muuqaalka', 'gur': 'ምስሌ'});
  String get notificationSetting => _t({'en': 'Notification setting', 'am': 'የማሳወቂያ ቅንብር', 'ti': 'ቅጥዒ ሓበሬታ', 'om': "Qindaa'ina beeksisaa", 'so': 'Dejinta ogeysiisyada', 'gur': 'የማስታወቂያ ቅንብር'});
  String get aboutUs => _t({'en': 'About us', 'am': 'ስለ እኛ', 'ti': 'ብዛዕባና', 'om': 'Waa\'ee keenya', 'so': 'Naga ku saabsan', 'gur': 'ስለ ኛን'});
  String get inviteFriends => _t({'en': 'Invite friends', 'am': 'ጓደኞን ጋብዝ', 'ti': 'ኣዕሩኽ ዕደም', 'om': 'Hiriyoota affeeri', 'so': 'Asxaabtaada casuumid', 'gur': 'ጓደኞን ጋብዝ'});
  String get inviteEarn => _t({'en': 'Earn 500 ETB or more', 'am': '500 ብር ወይ ከዚያ በላይ ካሸኙ', 'ti': '500 ብር ወይ ዝያዳ ኣስተምህሮ', 'om': 'Qarshii 500 ykn ol argate', 'so': 'Hel 500 ETB ama ka badan', 'gur': '500 ብር ወይ ከዚህ በለጠ ኩብ'});
  String get verificationTier => _t({'en': 'Verification', 'am': 'ማረጋገጫ', 'ti': 'ምርግጋጽ', 'om': 'Mirkaneessa', 'so': 'Xaqiijinta', 'gur': 'ማረጋገጫ'});
  String get tier1 => _t({'en': 'Tier 1', 'am': 'ደረጃ 1', 'ti': 'ደርቢ 1', 'om': 'Sadarkaa 1', 'so': 'Heerka 1', 'gur': 'ደረጃ 1'});
  String get loginSecurity => _t({'en': 'Login Security', 'am': 'የመግቢያ ደህንነት', 'ti': 'ደህንነት ምእታው', 'om': 'Nageenyummaa seensaa', 'so': 'Amniga galitaanka', 'gur': 'የማስገቢያ ደህንነት'});
  String get privacyControls => _t({'en': 'Privacy Controls', 'am': 'የምስጢር ቁጥጥር', 'ti': 'ቁጽጽር ምስጢር', 'om': "To'annoo dhuunfaa", 'so': 'Xukumaha xurmada', 'gur': 'የምስጢር ቁጥጥር'});
  String get marketAlerts => _t({'en': 'Market Alerts', 'am': 'የገበያ ማስጠንቀቂያ', 'ti': 'ናይ ዕዳጋ ምጠንቀቕታ', 'om': 'Beeksisa gabaa', 'so': 'Digniinta suuqa', 'gur': 'የቢያ ማስጠንቀቂያ'});
  String get systemMarketing => _t({'en': 'System & Marketing', 'am': 'ስርዓት እና ማሳወቂያ', 'ti': 'ስርዓት ወ ምልክት', 'om': 'Sirna fi beeksisa', 'so': 'Nidaamka & Xayaysiiska', 'gur': 'ስርዓት እና ማስታወቂያ'});
  String get supportCenter => _t({'en': 'Support Center', 'am': 'የድጋፍ ማዕከል', 'ti': 'ማእከል ደገፍ', 'om': 'Giddugala gargaarsaa', 'so': 'Xarunta taageerada', 'gur': 'የድጋፍ ማዕከል'});
  String get contactUs => _t({'en': 'Contact Us', 'am': 'ያነጋግሩን', 'ti': 'ተወከሉና', 'om': 'Nu qunnamaa', 'so': 'Nala xiriir', 'gur': 'ያነጋጋሩን'});
  String get legalDocs => _t({'en': 'Legal & Regulatory Documents', 'am': 'ህጋዊ ሰነዶች', 'ti': 'ሕጋዊ ሰነዳት', 'om': 'Sanadota seeraa', 'so': 'Dukumiintiyada sharciiga', 'gur': 'ሕጋዊ ሰነዶች'});
  String get regulatoryStatus => _t({'en': 'Regulatory Status', 'am': 'የቁጥጥር ሁኔታ', 'ti': 'ኩነታ ቁጽጽር', 'om': 'Haala to\'annoo', 'so': 'Xaalada taxanaha', 'gur': 'የቁጥጥር ሁኔታ'});
  String get halalCompliance => _t({'en': 'Halal Compliance & Audit', 'am': 'ሐላል ተኳዳጅነት', 'ti': 'ሐላል ምሉእ ምርግጋጽ', 'om': 'Walsimatiinsa Halaal', 'so': 'Xalaal-raacidda', 'gur': 'ሐላል ተስማሚነት'});
  String get taxStatements => _t({'en': 'Tax Statements & Reporting', 'am': 'የታክስ ዘርዝር', 'ti': 'ሓሳብ ቀረጽ', 'om': 'Ibsa gibiraa', 'so': 'Warbixinada canaasiibta', 'gur': 'የቀረጥ ዘርዝር'});
  String get feesAndLimits => _t({'en': 'Fees & Trading Limits', 'am': 'ክፍያ እና ወሰን', 'ti': 'ክፍሊት ወ ገደብ', 'om': 'Kaffaltii fi daangaa', 'so': 'Kharashyada & Xadduudka', 'gur': 'ክፍያ እና ወሰን'});
  String get verificationStatus => _t({'en': 'Verification Status', 'am': 'ሁኔታ ማረጋገጫ', 'ti': 'ኩነታ ምርግጋጽ', 'om': 'Haala mirkaneessaa', 'so': 'Xaalada xaqiijinta', 'gur': 'ሁኔታ ማረጋገጫ'});
  String get profileInformation => _t({'en': 'Profile Information', 'am': 'መገለጫ መረጃ', 'ti': 'ሓበሬታ ፕሮፋይል', 'om': 'Odeeffannoo piroofaayilii', 'so': 'Macluumaadka Bogga', 'gur': 'መገለጫ ሓበሬታ'});
  String get paymentMethod => _t({'en': 'Payment Method', 'am': 'የክፍያ ዘዴ', 'ti': 'ኣገባብ ክፍሊት', 'om': 'Mala kaffaltii', 'so': 'Habka Lacag-bixinta', 'gur': 'የክፍያ ዓይነት'});
  String get securityAndPrivacy => _t({'en': 'Security & Privacy', 'am': 'ደህንነት እና ምስጢር', 'ti': 'ድሕንነት ወ ምስጢር', 'om': 'Nageenyaa fi dhuunfaa', 'so': 'Amniga & Xurmada', 'gur': 'ደህንነት እና ምስጢር'});
  String get helpAndSupport => _t({'en': 'Help & Support', 'am': 'እርዳታ እና ድጋፍ', 'ti': 'ሓገዝ ወ ደገፍ', 'om': 'Gargaarsa fi deggersaa', 'so': 'Caawimaad & Taageero', 'gur': 'ሓገዝ እና ድጋፍ'});
  String get basicInfo => _t({'en': 'Basic information', 'am': 'መሠረታዊ መረጃ', 'ti': 'መሰረታዊ ሓበሬታ', 'om': 'Odeeffannoo bu\'uraa', 'so': 'Macluumaadka aasaasiga', 'gur': 'መሠረታዊ ሓበሬታ'});
  String get nationality => _t({'en': 'Nationality', 'am': 'ዜግነት', 'ti': 'ዜጋነት', 'om': 'Lammummaa', 'so': 'Jinsiyadda', 'gur': 'ዜጋነት'});
  String get residentialAddress => _t({'en': 'Residential address', 'am': 'መኖሪያ አድራሻ', 'ti': 'ናይ ቤት ኣድራሻ', 'om': 'Teessoo jireenyaa', 'so': 'Cinwaanka deganaanshaha', 'gur': 'ቤት አድራሻ'});
  String get emailAddress => _t({'en': 'Email address', 'am': 'ኢሜይል አድራሻ', 'ti': 'ኢመይል ኣድራሻ', 'om': 'Teessoo imeelii', 'so': 'Ciwaanka iimeelka', 'gur': 'ኢሜይል አድራሻ'});
  String get purposeOfAccount => _t({'en': 'Purpose of account', 'am': 'የመለያ ዓላማ', 'ti': 'ዕላማ ኣካውንት', 'om': 'Kaayyoo herregaa', 'so': 'Ujeedada akoonka', 'gur': 'የመለያ ዓላማ'});
  String get taxResidency => _t({'en': 'Tax residency', 'am': 'የቀረጥ መኖሪያ', 'ti': 'ናይ ቀረጽ ተቐምጦ', 'om': 'Teessoo gibiraa', 'so': 'Deganaanshaha canaasiibta', 'gur': 'የቀረጥ ቦታ'});
  String get riskAssessment => _t({'en': 'Risk assessment', 'am': 'የስጋት ግምት', 'ti': 'ፈተና ሓደጋ', 'om': 'Tilmaama gaagaa', 'so': 'Qiimaynta halista', 'gur': 'የስጋት ግምት'});
  String get occupation => _t({'en': 'Occupation', 'am': 'ሙያ', 'ti': 'ሞያ', 'om': 'Ogummaa', 'so': 'Shaqada', 'gur': 'ሙያ'});
  String get sourceOfWealth => _t({'en': 'Source of wealth', 'am': 'የሀብት ምንጭ', 'ti': 'ምንጪ ሃብቲ', 'om': 'Madda qabeenyaa', 'so': 'Xididka hantida', 'gur': 'የሀብት ምንጭ'});
  String get sourceOfFund => _t({'en': 'Source of fund', 'am': 'የፈንድ ምንጭ', 'ti': 'ምንጪ ፈንድ', 'om': 'Madda maallaqaa', 'so': 'Xididka tamwiiliga', 'gur': 'የፈንድ ምንጭ'});
  String get netWorth => _t({'en': 'Net worth', 'am': 'ተጣሪ ዋጋ', 'ti': 'ተጣሪ ሃብቲ', 'om': 'Gatii qulqulluu', 'so': 'Qiimaha saafiga', 'gur': 'ተጣሪ ዋጋ'});
  String get purposeOfTrading => _t({'en': 'Purpose of trading account', 'am': 'የንግድ ዓላማ', 'ti': 'ዕላማ ናይ ንግዲ', 'om': 'Kaayyoo daldalaa', 'so': 'Ujeedada ganacsiga', 'gur': 'የንግድ ዓላማ'});
  String get personalSection => _t({'en': 'Personal', 'am': 'ግላዊ', 'ti': 'ውልቃዊ', 'om': 'Dhuunfaa', 'so': 'Shaqsiga', 'gur': 'ግላዊ'});
  String get wealthSection => _t({'en': 'Wealth', 'am': 'ሀብት', 'ti': 'ሃብቲ', 'om': 'Qabeenya', 'so': 'Hanti', 'gur': 'ሀብት'});
  String get yourProfile => _t({'en': 'Your profile', 'am': 'የእርስዎ መገለጫ', 'ti': 'ናትካ ፕሮፋይል', 'om': 'Piroofaayiilii kee', 'so': 'Bogaagaaga', 'gur': 'ያንተ መገለጫ'});
  String get editField => _t({'en': 'Edit', 'am': 'አርትዕ', 'ti': 'ኣርትዕ', 'om': 'Gulaali', 'so': 'Wax ka beddel', 'gur': 'ኣርትዕ'});
  String get lastLogin => _t({'en': 'Last login', 'am': 'መጨረሻ ግቤት', 'ti': 'መጨረሻ ምእታው', 'om': 'Seensaa dhumaa', 'so': 'Galitaankii ugu dambeeyay', 'gur': 'መጨረሻ ማስገቢያ'});

  // ─── Analytics ───────────────────────────────────
  String get performance => _t({'en': 'Performance', 'am': 'አፈጻጸም', 'ti': 'ኣፈጻጽማ', 'om': 'Raawwii', 'so': 'Waxqabadka', 'gur': 'አፈጻጸም'});
  String get noPortfolioData => _t({'en': 'No portfolio data', 'am': 'የፖርትፎሊዮ ውሂብ የለም', 'ti': 'ዳታ ፖርትፎሊዮ የለን', 'om': 'Daataa poortfooliyoo hin jiru', 'so': 'Xog portfolio ma jirto', 'gur': 'የፖርትፎሊዮ ሓበሬታ የለም'});
  String get unrealised => _t({'en': 'Unrealised', 'am': 'ያልተሳካ', 'ti': 'ዘይተጸልአ', 'om': 'Hojirra ooluu dha', 'so': 'Aan la gaarin', 'gur': 'ያልተሳካ'});
  String get realised => _t({'en': 'Realised', 'am': 'የተሳካ', 'ti': 'ዝተጸልአ', 'om': 'Hojirra oolee', 'so': 'La garay', 'gur': 'የተሳካ'});
  String get allocation => _t({'en': 'Allocation', 'am': 'ክፍፍል', 'ti': 'ምምቃል', 'om': 'Ramadiinsa', 'so': 'Qeybsiga', 'gur': 'ክፍፍል'});
  String get largestHolding => _t({'en': 'Largest Holding', 'am': 'ትልቁ ይዞታ', 'ti': 'ዝዓቢ ንብረት', 'om': 'Qabeenya guddaa', 'so': 'Hantida ugu weyn', 'gur': 'ትልቁ ንብረት'});
  String get totalReturn => _t({'en': 'Total return on invested capital', 'am': 'ጠቅላላ ትርፍ', 'ti': 'ጠቕላላ ትርፊ', 'om': "Waliigala bu'aa", 'so': "Waxsoosaarka guud", 'gur': 'ድምር ትርፍ'});
  String get pnlBreakdown => _t({'en': 'P&L Breakdown', 'am': 'ትርፍ/ኪሳራ ዝርዝር', 'ti': 'ዝርዝር ትርፊ/ክሳራ', 'om': "Bu'aa/Kasaaraa caqasa", 'so': "Faahfaahin Faa'iido/Khasaare", 'gur': 'ትርፍ/ኪሳራ ዝርዝር'});

  // ─── Transactions ────────────────────────────────
  String get allTransactions => _t({'en': 'All Transactions', 'am': 'ሁሉም ግብይቶች', 'ti': 'ኩሉ ምትሕልላፍ', 'om': 'Hojii Mallaqa hunda', 'so': 'Dhammaan macaamilaadaha', 'gur': 'ሁሉም ግብይቶች'});
  String get noTransactionsYet => _t({'en': 'No transactions yet', 'am': 'ገና ግብይት የለም', 'ti': 'ገና ምትሕልላፍ የለን', 'om': 'Hanga ammaatti hojiin mallaqa hin jiru', 'so': 'Wali macaamiil ma jiraan', 'gur': 'ገና ግብይት የለም'});

  // ─── Demo / login ────────────────────────────────
  String get tryDemo => _t({'en': 'Try Demo', 'am': 'ዴሞ ሞክር', 'ti': 'ዴሞ ፈትን', 'om': 'Demoo yaali', 'so': 'Tijaabi Muuqaalka', 'gur': 'ዴሞ ሞክር'});
  String get demoModeShort => _t({'en': 'DEMO MODE — Data is simulated for presentation', 'am': 'DEMO — ውሂቡ ለማቅረቢያ ብቻ ነው', 'ti': 'DEMO — ዳታ ንምርኣይ ጥራይ እዩ', 'om': 'DEMO — Daataan agarsiisuuf qofa', 'so': 'DEMO — Xogtu muuqaalka kaliya', 'gur': 'DEMO — ሓበሬታ ለቀርቢ ብቻ ነው'});
  String get demoModeFull => _t({'en': 'DEMO MODE — All data is simulated for presentation purposes', 'am': 'DEMO — ሁሉም ውሂብ ለማቅረቢያ ዓላማ ብቻ ነው', 'ti': 'DEMO — ኩሉ ዳታ ንምርኣይ ዓላማ ጥራይ እዩ', 'om': 'DEMO — Daataan hundi agarsiisuuf qofa', 'so': 'DEMO — Xog walbaa muuqaalka kaliya', 'gur': 'DEMO — ሁሉ ሓበሬታ ለቀርቢ ዓላማ ብቻ ነው'});
  String get exitDemo => _t({'en': 'Exit', 'am': 'ውጣ', 'ti': 'ውጻእ', 'om': "Ba'i", 'so': 'Ka bax', 'gur': 'ውጣ'});
  String get exitDemoArrow => _t({'en': 'Exit Demo →', 'am': 'ዴሞ ይውጡ →', 'ti': 'ዴሞ ውጻእ →', 'om': "Demoo irraa ba'i →", 'so': 'Ka bax Muuqaalka →', 'gur': 'ዴሞ ውጣ →'});
  String get emailHint => _t({'en': 'you@example.com', 'am': 'you@example.com', 'ti': 'you@example.com', 'om': 'you@example.com', 'so': 'you@example.com', 'gur': 'you@example.com'});
  String accountLocked(int min, int sec) => _t({
    'en': 'Account locked. Too many failed attempts.\nTry again in ${min}m ${sec}s',
    'am': 'መለያ ተቆልፏል። ብዙ ያልተሳካ ሙከራ።\n${min}ደ ${sec}ሰ ኋላ ይሞክሩ',
    'ti': 'ኣካውንት ተዓጺዩ። ብዙ ዘይተዓወቱ ፈተነታት።\nኣብ ${min}ደ ${sec}ሰ ደጊምካ ፈትን',
    'om': 'Herregni cufame. Yaalii hin milkoofne baay\'ee.\nDaqiiqaa ${min} sekoondii ${sec} booda yaali',
    'so': 'Akoonku waa la xidhay. Isku day fashilaya badan.\nKu celi ${min}d ${sec}s',
    'gur': 'መለያ ተቆልፏል።\n${min}ደ ${sec}ሰ ኋላ ይሞክሩ',
  });
  String attemptsRemaining(int count) => _t({
    'en': '$count attempt(s) remaining before lockout',
    'am': 'ከመቆለፊ በፊት $count ሙከራ ይቀራል',
    'ti': '$count ፈተነ ቅድሚ ምዕጻው ይትረፍ',
    'om': 'Cufamuuf duras yaalii $count hafteetti',
    'so': '$count isku day ayaa haray kahor xidlidda',
    'gur': 'ከቆለፋ ቀደም $count ሙከራ ይቀራል',
  });

  // ─── Sharia / Compliance ─────────────────────────
  String get shariaCertified => _t({'en': 'Sharia Certified', 'am': 'ሸሪዓ ተረጋግጧል', 'ti': 'ሸሪዓ ተረጋጊጹ', 'om': "Shari'aan mirkanaa'e", 'so': 'Shariicada waa la xaqiijiyay', 'gur': 'ሸሪዓ ተረጋግጧል'});
  String get shariaScore => _t({'en': 'Sharia Score', 'am': 'የሸሪዓ ነጥብ', 'ti': 'ነጥቢ ሸሪዓ', 'om': "Qabxii Shari'aa", 'so': 'Dhibcaha Sharciga', 'gur': 'የሸሪዓ ነጥብ'});
  String get aaaoifiCompliant => _t({'en': 'AAOIFI Compliant', 'am': 'AAOIFI ተሟልቷል', 'ti': 'AAOIFI ተኣዛዚ', 'om': 'AAOIFI wajjin walsimatu', 'so': 'AAOIFI ku habboon', 'gur': 'AAOIFI ተሟልቷል'});
  String get mostlyCompliant => _t({'en': 'Mostly Compliant', 'am': 'አብዛኛው ተሟልቷል', 'ti': 'ብዙሑ ተኣዛዚ', 'om': 'Heddu wajjin walsimatu', 'so': 'Badanaa ku habboon', 'gur': 'አብዛኛው ተሟልቷል'});
  String get reviewRequired => _t({'en': 'Review Required', 'am': 'ምርመራ ያስፈልጋል', 'ti': 'ምርኣይ የድሊ', 'om': 'Ilaaluu barbaachisa', 'so': 'Dib u eegis ayaa loo baahan yahay', 'gur': 'ምርምራ ያስፈልጋል'});
  String get ofPortfolioValue => _t({'en': 'of portfolio value', 'am': 'ከፖርትፎሊዮ ዋጋ', 'ti': 'ካብ ዋጋ ፖርትፎሊዮ', 'om': 'gatii poortfooliyoo', 'so': 'qiimaha portfolio-ga', 'gur': 'ከፖርትፎሊዮ ዋጋ'});
  String get aaaoifiStandardNo21 => _t({'en': 'AAOIFI Standard No. 21', 'am': 'AAOIFI ደረጃ ቁ. 21', 'ti': 'AAOIFI ሕጊ ቁ. 21', 'om': 'AAOIFI Lakk. 21', 'so': 'AAOIFI Heerka Lak. 21', 'gur': 'AAOIFI ደረጃ ቁ. 21'});

  // ─── Market screen ───────────────────────────────
  String get allCategories => _t({'en': 'All Categories', 'am': 'ሁሉም ምድቦች', 'ti': 'ኩሉ ክፍልታት', 'om': 'Gosota hunda', 'so': 'Dhammaan qaybaha', 'gur': 'ሁሉ ምድቦች'});
  String get islamicBanks => _t({'en': 'Islamic Banks', 'am': 'እስላማዊ ባንኮች', 'ti': 'ኢስላማዊ ባንክታት', 'om': 'Baankiiwwan Islaamaa', 'so': 'Bangiyada Islaamiga', 'gur': 'እስላማዊ ባንኮች'});
  String get ethiopianEquities => _t({'en': 'Ethiopian Equities', 'am': 'ኢትዮጵያዊ አክሲዮኖች', 'ti': 'ኢትዮጵያዊ ኣክስዮናት', 'om': 'Aksiyoonota Itoophiyaa', 'so': 'Sahaamaha Itoobiya', 'gur': 'ኢትዮጵያዊ አክሲዮናት'});
  String get takafullInsurance => _t({'en': 'Takaful & Insurance', 'am': 'ታካፉልና ኢንሹራንስ', 'ti': 'ታካፉልን ኢንሹራንስን', 'om': 'Takaafulii fi Inshuraansii', 'so': 'Takaful & Caymiska', 'gur': 'ታካፉልና ኢንሹራንስ'});
  String get halalAssets => _t({'en': 'Halal Assets', 'am': 'ሐላል ንብረቶች', 'ti': 'ሐላል ንብረታት', 'om': 'Qabeenyaa Halaal', 'so': 'Hantida Xalaal', 'gur': 'ሐላል ንብረቶች'});
  String get seeAllArrow => _t({'en': 'See all →', 'am': 'ሁሉን ይመልከቱ →', 'ti': 'ኩሉ ርአ →', 'om': 'Hundaa ilaalee →', 'so': 'Arki dhammaan →', 'gur': 'ሁሉ ይመልከቱ →'});
  String get assetsCount => _t({'en': 'assets', 'am': 'ንብረቶች', 'ti': 'ንብረታት', 'om': 'qabeenyaa', 'so': 'hanti', 'gur': 'ንብረቶች'});
  String get createAlert => _t({'en': 'Create Alert', 'am': 'ማንቂያ ፍጠር', 'ti': 'መጠንቀቕታ ፍጠር', 'om': 'Beeksisa uumi', 'so': 'Samee Digniin', 'gur': 'ማስጠንቀቂያ ፍጠር'});
  String get alertFor => _t({'en': 'Alert', 'am': 'ማንቂያ', 'ti': 'መጠንቀቕታ', 'om': 'Beeksisa', 'so': 'Digniin', 'gur': 'ማስጠንቀቂያ'});
  String get alerts => _t({'en': 'Alerts', 'am': 'ማስጠንቀቂያዎች', 'ti': 'መጠንቀቕታታት', 'om': 'Beeksisota', 'so': 'Digniinaha', 'gur': 'ማስጠንቀቂያዎች'});
  String get currentPriceLabel => _t({'en': 'Current', 'am': 'አሁኑ ዋጋ', 'ti': 'ሕጂ ዘሎ ዋጋ', 'om': 'Ammaa', 'so': 'Qiimaha hadda', 'gur': 'አሁን ዋጋ'});

  // ─── Stat cards / Dashboard ──────────────────────
  String get calculator => _t({'en': 'Calculator', 'am': 'ማስሊያ', 'ti': 'ቆጸራ', 'om': 'Herreega', 'so': 'Xisaabiye', 'gur': 'ቆጣሪ'});
  String get latestNews => _t({'en': 'Latest news', 'am': 'ዘመናዊ ዜና', 'ti': 'ዘምዘም ዜና', 'om': 'Oduu haaraa', 'so': 'Wararka ugu dambeeyay', 'gur': 'ዘምዘም ዜና'});
  String get reserved => _t({'en': 'reserved', 'am': 'ተይዟል', 'ti': 'ተሓዚ', 'om': 'qabame', 'so': 'kaydiyay', 'gur': 'ተይዟል'});
  String get filledStatus => _t({'en': 'Filled', 'am': 'ተሞልቷል', 'ti': 'ተሞሊኡ', 'om': 'Guutameera', 'so': 'Waa la buuxiyay', 'gur': 'ተሞልቷል'});
  String get openStatus => _t({'en': 'Open', 'am': 'ክፍት', 'ti': 'ክፉት', 'om': 'Banaa', 'so': 'Furan', 'gur': 'ክፍት'});

  // ─── Dashboard widgets ───────────────────────────
  String get topOpportunities => _t({'en': 'Top Opportunities', 'am': 'ምርጥ እድሎች', 'ti': 'ዝበለጹ ዕድላት', 'om': 'Carraalee olaanaa', 'so': 'Fursadaha ugu sarreeya', 'gur': 'ምርጥ ዕድሎች'});
  String get seeAll => _t({'en': 'See all', 'am': 'ሁሉን ይመልከቱ', 'ti': 'ኩሉ ርአ', 'om': 'Hundaa ilaalee', 'so': 'Arki dhammaan', 'gur': 'ሁሉ ይመልከቱ'});
  String get browseMarket => _t({'en': 'Browse Market', 'am': 'ገበያ ይፈልጉ', 'ti': 'ዕዳጋ ርአ', 'om': 'Gabaa ilaalee', 'so': 'Baadhi Suuqa', 'gur': 'ገቢያ ፈልግ'});
  String get browseMarketArrow => _t({'en': 'Browse Market →', 'am': 'ገበያ ይፈልጉ →', 'ti': 'ዕዳጋ ርአ →', 'om': 'Gabaa ilaalee →', 'so': 'Baadhi Suuqa →', 'gur': 'ገቢያ ፈልግ →'});
  String get activity => _t({'en': 'Activity', 'am': 'እንቅስቃሴ', 'ti': 'ንጥፈት', 'om': 'Hojii', 'so': 'Hawlaha', 'gur': 'እንቅስቃሴ'});
  String get corporateEvents => _t({'en': 'Corporate Events', 'am': 'የድርጅት ዝግጅቶች', 'ti': 'ናይ ትካል ፍጻሜታት', 'om': 'Dhaabbilee Gochaalee', 'so': 'Dhacdooyinka Shirkadda', 'gur': 'የድርጅት ዝግጅቶች'});
  String get noUpcomingEvents => _t({'en': 'No upcoming events', 'am': 'የሚመጣ ዝግጅት የለም', 'ti': 'ዝመጽእ ፍጻሜ የለን', 'om': 'Gocha dhufaa hin jiru', 'so': 'Dhacdoyin soo socda ma jiraan', 'gur': 'የሚመጣ ዝግጅት የለም'});
  String get availableCash => _t({'en': 'Available Cash', 'am': 'ያለ ጥሬ ገንዘብ', 'ti': 'ዘሎ ጥረ ገንዘብ', 'om': 'Maallaqa jiru', 'so': 'Lacagta la heli karo', 'gur': 'ያለ ጥሬ ገንዘብ'});
  String get reservedForOrders => _t({'en': 'Reserved for Orders', 'am': 'ለትዕዛዝ የተይዘ', 'ti': 'ንትእዛዛት ዝተሓዘ', 'om': 'Ajajotaaf qabame', 'so': 'Kaydiyey Dalab', 'gur': 'ለትዕዛዝ የተያዘ'});
  String get portfolioEmpty => _t({'en': 'Your portfolio is empty', 'am': 'ፖርትፎሊዮዎ ባዶ ነው', 'ti': 'ፖርትፎሊዮኻ ባዶ እዩ', 'om': 'Poortfooliyoon kee duwwaa dha', 'so': 'Portfolio-gaagu waa madhan', 'gur': 'ፖርትፎሊዮህ ባዶ ነው'});
  String get firstTradePrompt => _t({'en': 'Make your first trade to get started', 'am': 'ለጅምር የመጀመሪያ ንግድ ያካሂዱ', 'ti': 'ንምጅማር ፈላማይ ንግዲ ግበር', 'om': 'Jalqabuuf daldala jalqabaa raawwadhu', 'so': 'Ganacsiga koowaad ku samee si aad u bilaabato', 'gur': 'ለጅምር የመጀመሪያ ንግድ አካሂድ'});
  String get noWatchlistItems => _t({'en': 'No watchlist items', 'am': 'ምንም ክትትል ዝርዝር የለም', 'ti': 'ዝርዝር ክትትል የለን', 'om': 'Wantoonni hordoffii hin jiran', 'so': 'Liiska cilaaynta ma jiro', 'gur': 'ምንም ክትትል ዝርዝር የለም'});
  String get topVolume => _t({'en': 'Top Volume', 'am': 'ከፍተኛ ዓለም', 'ti': 'ዝለዓለ ዓቐን', 'om': 'Guddaa hammata', 'so': 'Tirada ugu sareysa', 'gur': 'ከፍተኛ ዓቀን'});
  String get held => _t({'en': 'Held', 'am': 'ተይዟል', 'ti': 'ሒዝካ', 'om': 'Qabame', 'so': 'La haysto', 'gur': 'ተይዟል'});
  String get trending => _t({'en': 'Trending', 'am': 'ትሬንዲንግ', 'ti': 'ትሬንዲንግ', 'om': 'Foddaa jiru', 'so': 'Caanka ah', 'gur': 'ተወዳጅ'});
  String get viewAllHoldings => _t({'en': 'View all holdings', 'am': 'ሁሉም ይዞታ ይመልከቱ', 'ti': 'ኩሉ ዘለካ ርአ', 'om': 'Qabeenya hunda ilaalee', 'so': 'Arki hantida oo dhan', 'gur': 'ሁሉ ንብረቶች ይመልከቱ'});
  String get viewAllOrders => _t({'en': 'View all orders', 'am': 'ሁሉም ትዕዛዞች ይመልከቱ', 'ti': 'ኩሉ ትእዛዛት ርአ', 'om': 'Ajajota hunda ilaalee', 'so': 'Arki dalabyadda oo dhan', 'gur': 'ሁሉ ትዕዛዛት ይመልከቱ'});
  String get noRecentOrders => _t({'en': 'No recent orders', 'am': 'የቅርብ ጊዜ ትዕዛዝ የለም', 'ti': 'ናይ ቀረባ ትእዛዝ የለን', 'om': 'Ajajni dhihoo hin jiru', 'so': 'Dalabyo dhowaan ma jiraan', 'gur': 'የቅርብ ትዕዛዝ የለም'});
  String get yourHoldingsLabel => _t({'en': 'Your Holdings', 'am': 'ይዞታዎችዎ', 'ti': 'ናትካ ንብረት', 'om': 'Qabeenya kee', 'so': 'Hantidaada', 'gur': 'ያንተ ንብረቶች'});
  String get recentOrdersLabel => _t({'en': 'Recent Orders', 'am': 'የቅርብ ጊዜ ትዕዛዞች', 'ti': 'ናይ ቀረባ ትእዛዛት', 'om': 'Ajajni dhihoo', 'so': 'Dalabyadii dhowaa', 'gur': 'የቅርብ ጊዜ ትዕዛዛት'});

  // ─── Portfolio export ────────────────────────────
  String get symbol => _t({'en': 'Symbol', 'am': 'ምልክት', 'ti': 'ምልክት', 'om': 'Amalaa', 'so': 'Summadda', 'gur': 'ምልክት'});
  String get unitLabel => _t({'en': 'Unit', 'am': 'ክፍል', 'ti': 'ፍርቂ', 'om': 'Wanta', 'so': 'Unug', 'gur': 'ክፍል'});
  String get avgBuyPrice => _t({'en': 'Avg Buy (ETB)', 'am': 'አማካይ ግዥ (ETB)', 'ti': 'ማእከላይ ዕድጊ (ETB)', 'om': 'Gatii bituuf giddugaleessa (ETB)', 'so': 'Celceliska iib (ETB)', 'gur': 'አማካይ ግዥ (ETB)'});
  String get currentEtb => _t({'en': 'Current (ETB)', 'am': 'ወቅታዊ (ETB)', 'ti': 'ህሉው (ETB)', 'om': 'Ammaa (ETB)', 'so': 'Hadda (ETB)', 'gur': 'ያሁኑ (ETB)'});
  String get valueEtb => _t({'en': 'Value (ETB)', 'am': 'ዋጋ (ETB)', 'ti': 'ዋጋ (ETB)', 'om': 'Gatii (ETB)', 'so': 'Qiimo (ETB)', 'gur': 'ዋጋ (ETB)'});
  String get pnlEtb => _t({'en': 'P&L (ETB)', 'am': 'ትርፍ/ኪሳራ (ETB)', 'ti': 'ትርፊ/ክሳራ (ETB)', 'om': "Bu'aa/Kasaaraa (ETB)", 'so': "Faa'iido/Khasaare (ETB)", 'gur': 'ትርፍ/ኪሳራ (ETB)'});
  String get pnlPct => _t({'en': 'P&L %', 'am': 'ትርፍ/ኪሳራ %', 'ti': 'ትርፊ/ክሳራ %', 'om': "Bu'aa/Kasaaraa %", 'so': "Faa'iido/Khasaare %", 'gur': 'ትርፍ/ኪሳራ %'});
  String get portfolioHoldingsStatement => _t({'en': 'Portfolio Holdings Statement', 'am': 'የፖርትፎሊዮ ይዞታ ሪፖርት', 'ti': 'ጸብጻብ ፖርትፎሊዮ', 'om': 'Ibsa qabeenyaa poortfooliyoo', 'so': 'Warbixinta hantida portfolio', 'gur': 'የፖርትፎሊዮ ንብረት ሪፖርት'});
  String holdingsCount(int n) => _t({'en': '$n holdings', 'am': '$n ይዞታዎች', 'ti': '$n ዘለካ', 'om': '$n qabeenya', 'so': '$n hanti', 'gur': '$n ንብረቶች'});
  String get yes => _t({'en': 'Yes', 'am': 'አዎ', 'ti': 'እወ', 'om': 'Eeyyee', 'so': 'Haa', 'gur': 'አዎ'});
  String get no => _t({'en': 'No', 'am': 'አይ', 'ti': 'ኣይፋሉን', 'om': 'Lakki', 'so': 'Maya', 'gur': 'አይ'});
  String get portfolioStats => _t({'en': 'Portfolio Stats', 'am': 'የፖርትፎሊዮ ስታቲስቲክ', 'ti': 'ስታቲስቲክ ፖርትፎሊዮ', 'om': 'Istaatistiksi poortfooliyoo', 'so': 'Tirakoobka portfolio', 'gur': 'የፖርትፎሊዮ ስታቲስቲክ'});
  String get returnRate => _t({'en': 'Return Rate', 'am': 'የትርፍ ደረጃ', 'ti': 'ደረጃ ትርፊ', 'om': "Sadarkaa bu'aa", 'so': "Heerka faa'iidada", 'gur': 'የትርፍ ደረጃ'});
  String get invested => _t({'en': 'Invested', 'am': 'ኢንቨስት', 'ti': 'ኢንቨስት', 'om': 'Invastimantii', 'so': 'La maaalgaliyey', 'gur': 'ኢንቨስት'});
  String get noHoldingsSharia => _t({'en': 'No holdings — AAOIFI screening will apply when you invest', 'am': 'ይዞታ የለም — ሲኢንቨስቱ AAOIFI ስክሪኒንግ ይሠራል', 'ti': 'ንብረት የለን — ምስ ኢንቨስት ዝጅምሩ AAOIFI ስክሪኒንግ ይሰርሕ', 'om': 'Qabeenya hin jiru — erga invaastii taasistaniin AAOIFI fooyya\'a', 'so': 'Hanti la\'aanta — Marka aad maalgasho AAOIFI ayaa shaqaynaysa', 'gur': 'ንብረት የለም — ሲኢንቨስቱ AAOIFI ስክሪኒንግ ይሠራል'});
  String shariaHoldingsText(int compliant, int total, String pct) => _t({'en': '$compliant of $total holdings are AAOIFI-compliant — ${pct}% of portfolio value', 'am': '$compliant ከ$total ይዞታዎች AAOIFI ተወካይ — ${pct}% የፖርትፎሊዮ ዋጋ', 'ti': '$compliant ካብ $total ዘለካ AAOIFI ተከታዪ — ${pct}% ዋጋ ፖርትፎሊዮ', 'om': '$compliant kan $total qabeenyaa AAOIFI wajjin walsiman — ${pct}% gatii poortfooliyoo', 'so': '$compliant ka mid ah $total hanti waa AAOIFI-u hoggaansan — ${pct}% qiimaha portfolio', 'gur': '$compliant ከ$total ንብረቶች AAOIFI ተወካይ — ${pct}% የፖርትፎሊዮ ዋጋ'});
  String get portfolioSplit => _t({'en': 'Portfolio Split', 'am': 'የፖርትፎሊዮ ክፍፍል', 'ti': 'ምምቃል ፖርትፎሊዮ', 'om': 'Qoodinsa poortfooliyoo', 'so': 'Qeybsiga portfolio', 'gur': 'የፖርትፎሊዮ ክፍፍል'});
  String get depositSubtitle => _t({'en': 'Funds via secure channel (no interest)', 'am': 'ገንዘብ ያስገቡ • ወለድ የለም', 'ti': 'ገንዘብ ብውሑስ መስመር (ወለድ የለን)', 'om': 'Maallaqa gara karaa nageenya (dhala hin qabu)', 'so': 'Lacag geli (Riba-Free)', 'gur': 'ገንዘብ ያስገቡ • ወለድ የለም'});
  String get depositComplete => _t({'en': 'Deposit complete', 'am': 'ገንዘብ ተቀበለ', 'ti': 'ገንዘብ ተቀቢሉ', 'om': 'Galchaan xumurame', 'so': 'Dhigitaanku waa dhammaatay', 'gur': 'ገንዘብ ተቀብሏል'});
  String get withdrawSubtitle => _t({'en': 'Withdraw to your registered bank account', 'am': 'ወደ ተመዝጋቢ ባንክ ሒሳብ ያውጡ', 'ti': 'ናብ ዝተዘርዘረ ሒሳብ ባንክ ኣውጽእ', 'om': 'Gara herrega baankii galmaaye baasi', 'so': 'Ka saar xisaabta bangiga', 'gur': 'ወደ ተሰጥዎ ባንክ አስልኩ'});
  String get available => _t({'en': 'Available', 'am': 'ተጠቃሚ', 'ti': 'ዝርከብ', 'om': 'Argamuu danda\'u', 'so': 'La heli karo', 'gur': 'ዝርከብ'});
  String get destinationAccount => _t({'en': 'Destination Account', 'am': 'ዓላማ ሒሳብ', 'ti': 'ሒሳብ ዕላማ', 'om': 'Herrega gara deemuu', 'so': 'Xisaabta haddafka', 'gur': 'ዓላማ ሒሳብ'});
  String get primaryLabel => _t({'en': 'Primary', 'am': 'ዋና', 'ti': 'ቀዳማይ', 'om': 'Jalqabaa', 'so': 'Ugu muhiimsan', 'gur': 'ዋና'});
  String get noPaymentMethods => _t({'en': 'No payment methods saved. Add a bank account in Profile > Payment Methods first.', 'am': 'ምንም የክፍያ ዘዴ የለም። መጀመሪያ ፕሮፋይል > የክፍያ ዘዴዎች ውስጥ ባንክ ሒሳብ ያክሉ።', 'ti': 'ኣገባብ ክፍሊት ዘይብሉ። ቅድም ፕሮፋይል > ኣገባብ ክፍሊት ሒሳብ ባንክ ወስኹ።', 'om': 'Mala kaffaltii hin qabdu. Dura Poroofaayilii > Mala Kaffaltii keessatti herrega baankii ida\'i.', 'so': 'Hab lacag bixin lama kaydsan. Marka hore Profile > Habka Lacag-bixinta ugu dar xisaab bangi.', 'gur': 'ምንም ክፍያ ዘዴ የለም። ፕሮፋይል > ክፍያ ዘዴዎች ባንክ ሒሳብ ያስገቡ።'});
  String reservedInOrders(String amount) => _t({'en': 'Reserved in open orders: $amount ETB', 'am': 'ለክፍት ትዕዛዞች ተይዞ: $amount ETB', 'ti': 'ንኽፉት ትእዛዛት ዝተሓዘ: $amount ETB', 'om': 'Ajajota banamoo keessatti qabame: $amount ETB', 'so': 'Kaydiyey dalabyadda furan: $amount ETB', 'gur': 'ለክፍት ትዕዛዛት ተያዘ: $amount ETB'});
  String availableBalance(String amount) => _t({'en': 'Available: $amount ETB', 'am': 'ዝርከብ: $amount ETB', 'ti': 'ዝርከብ: $amount ETB', 'om': "Argamuu danda'u: $amount ETB", 'so': 'La heli karo: $amount ETB', 'gur': 'ዝርከብ: $amount ETB'});
  String get withdrawComplete => _t({'en': 'Withdrawal complete', 'am': 'ወጪ ተጠናቀቀ', 'ti': 'ምውጻእ ተዛዚሙ', 'om': 'Baasuun xumurame', 'so': 'Bixitaanku waa dhammaatay', 'gur': 'ወጪ ተጠናቅቋል'});
  String get withdrawalFailed => _t({'en': 'Withdrawal failed', 'am': 'ወጪ አልተሳካም', 'ti': 'ምውጻእ ኣይሰለጠን', 'om': 'Baasuun hin milkoofne', 'so': 'Bixitaanka wuu guuldareystay', 'gur': 'ወጪ አልተሳካም'});
  String insufficientBalanceMsg(String amount) => _t({'en': 'Insufficient balance. Available: $amount ETB', 'am': 'በቂ ቀሪ ሂሳብ የለም። ዝርከብ: $amount ETB', 'ti': 'ዝተረፈ ሒሳብ ኣይፈቅድን። ዝርከብ: $amount ETB', 'om': "Balansin ga'a dha. Argamuu danda'u: $amount ETB", 'so': 'Dhaqaale ku filan ma jiro. La heli karo: $amount ETB', 'gur': 'ብቁ ሒሳብ የለም። ዝርከብ: $amount ETB'});

  // ─── Corporate Events screen ─────────────────────
  String get searchEvents => _t({'en': 'Search events...', 'am': 'ዝግጅቶችን ይፈልጉ...', 'ti': 'ፍጻሜታት ድለ...', 'om': 'Gochaalee barbaadi...', 'so': 'Raadi dhacdooyinka...', 'gur': 'ዝግጅቶች ፈልግ...'});
  String get myEvents => _t({'en': 'My events', 'am': 'የእኔ ዝግጅቶች', 'ti': 'ፍጻሜታተይ', 'om': 'Gochaalee koo', 'so': 'Dhacdooyinkayga', 'gur': 'የኔ ዝግጅቶች'});
  String get allEvents => _t({'en': 'All events', 'am': 'ሁሉም ዝግጅቶች', 'ti': 'ኩሉ ፍጻሜታት', 'om': 'Gochaalee hunda', 'so': 'Dhammaan dhacdooyinka', 'gur': 'ሁሉ ዝግጅቶች'});
  String get noEventsFound => _t({'en': 'No events found', 'am': 'ምንም ዝግጅት አልተገኘም', 'ti': 'ፍጻሜ ኣይተረኸበን', 'om': 'Gocha hin argamne', 'so': 'Dhacdooyin la heli kari waayay', 'gur': 'ምንም ዝግጅት አልተገኘም'});
  String get eventsForHoldings => _t({'en': 'Events for your holdings & market', 'am': 'ለንብረቶችዎ እና ለገበያ ዝግጅቶች', 'ti': 'ፍጻሜ ንንብረትካን ዕዳጋን', 'om': 'Gochaalee qabeenyakeetiif fi gabaa', 'so': 'Dhacdooyinka hantidaada & suuqa', 'gur': 'ለንብረቶችህ እና ለገቢያ ዝግጅቶች'});
  String get adjustSearchFilter => _t({'en': 'Adjust search or filter', 'am': 'ፍለጋ ወይም ማጣሪያ ያስተካክሉ', 'ti': 'ምድላይ ወይ ማጣሪ ኣዐርቕ', 'om': 'Barbaaduu ykn mala cimsuu sirreessi', 'so': 'Hagaaji raadinta ama shaandhaynta', 'gur': 'ፍለጋ ወይም ማጣሪያ ኣስተካክሉ'});
  String get filterByType => _t({'en': 'Filter by Type', 'am': 'በዓይነት ያጣሩ', 'ti': 'ብዓይነት ኣጣሪ', 'om': 'Gosaan cimsuu', 'so': 'U shaandhayn nooca', 'gur': 'በዓይነት ፍሰሉ'});
  String get earningsReport => _t({'en': 'Earnings / Report', 'am': 'ትርፍ / ሪፖርት', 'ti': 'ትርፊ / ሪፖርት', 'om': "Bu'aa / Gabaasa", 'so': "Faa'iido / Warbixin", 'gur': 'ትርፍ / ሪፖርት'});
  String get annualMeeting => _t({'en': 'Annual Meeting', 'am': 'ዓመታዊ ስብሰባ', 'ti': 'ዓመታዊ ኣኼባ', 'om': 'Walgahii waggaa', 'so': 'Shirka Sannadlaha', 'gur': 'ዓመታዊ ስብሰባ'});
  String get profitShare => _t({'en': 'Profit Share', 'am': 'የትርፍ ክፍፍል', 'ti': 'ምምቃል ትርፊ', 'om': "Bu'aa hiruu", 'so': "Qeybsiga Faa'iidada", 'gur': 'የትርፍ ክፍፍል'});
  String get marketHolidayLabel => _t({'en': 'Market Holiday', 'am': 'የገበያ ዕረፍት', 'ti': 'ዕለት ዕረፍቲ ዕዳጋ', 'om': 'Ayyaana gabaa', 'so': 'Fasaxa suuqa', 'gur': 'የገቢያ ዕረፍት'});
  String get ecxSessionLabel => _t({'en': 'ECX Session', 'am': 'ECX ሴሽን', 'ti': 'ECX ሴሽን', 'om': 'Seeshinii ECX', 'so': 'Session-ka ECX', 'gur': 'ECX ሴሽን'});

  // ─── Security screen ─────────────────────────────
  String get protectYourAccount => _t({'en': 'Protect your account', 'am': 'መለያዎን ይጠብቁ', 'ti': 'ኣካውንትካ ሓሉ', 'om': 'Herrega kee tiksi', 'so': 'Xafidi akoonkaaga', 'gur': 'መለያህን ጠብቅ'});
  String get wealthProtectionActive => _t({'en': 'Active', 'am': 'ንቁ', 'ti': 'ንጡፍ', 'om': 'Hojii irra jira', 'so': 'Firfircoon', 'gur': 'ንቁ'});
  String get wealthProtectionInactive => _t({'en': 'Inactive', 'am': 'ንቁ ያልሆነ', 'ti': 'ዘይንጡፍ', 'om': 'Hojii irra hin jiru', 'so': 'Aan firfircoonayn', 'gur': 'ንቁ ያልሆነ'});
  String get requiresAuthFor => _t({'en': 'Requires authentication for:', 'am': 'ለሚከተሉት ማረጋገጫ ያስፈልጋል:', 'ti': 'ምርግጋጽ ናብዚ ዘድሊ:', 'om': 'Kanneen mirkaneessuu barbaachisa:', 'so': 'Xaqiijin u baahan:', 'gur': 'ለሚከተሉት ማረጋገጫ ያስፈጋል:'});
  String get buySellOrders => _t({'en': 'Buy & Sell orders', 'am': 'የግዢ እና ሽያጭ ትዕዛዞች', 'ti': 'ናይ ምዕዳጊን ሽያጢን ትእዛዛት', 'om': 'Ajajota bituufi gurguruuf', 'so': 'Dalabyadda iibsashada & iibishada', 'gur': 'ዱ ግዢ እና ሽያጭ ትዕዛዛት'});
  String get everyOrderPlacement => _t({'en': 'Every order placement', 'am': 'እያንዳንዱ ትዕዛዝ', 'ti': 'ኩሉ ምቕማጥ ትእዛዝ', 'om': 'Ajaja hundaa', 'so': 'Dhigista kasta', 'gur': 'እያንዳንዱ ትዕዛዝ'});
  String get withdrawalsOver => _t({'en': 'Withdrawals over 5,000 ETB', 'am': 'ከ5,000 ብር በላይ ወጪዎች', 'ti': 'ካብ 5,000 ብር ንዘይ ምውጻእ', 'om': '5,000 ETBn ol baasuu', 'so': 'Lacag-bixinta ka badan 5,000 ETB', 'gur': 'ከ5,000 ብር በላይ ወጪ'});
  String get largeTransfersToBank => _t({'en': 'Large transfers to bank', 'am': 'ወደ ባንክ ትልቅ ዝውውሮች', 'ti': 'ዓቢ ምስግጋር ናብ ባንክ', 'om': 'Dabarsaa guddaa gara baankii', 'so': 'Wareejinta weyn ee bangiga', 'gur': 'ወደ ባንክ ትልቅ ዝውውሮች'});
  String get addingPaymentMethods => _t({'en': 'Adding payment methods', 'am': 'ሌላ ክፍያ ዘዴ መጨመሪያ', 'ti': 'ምውሳኽ ኣገባብ ክፍሊት', 'om': 'Mala kaffaltii dabaluu', 'so': 'Ku darista habka lacag bixinta', 'gur': 'ሌላ ክፍያ ዘዴ ምጨምሪ'});
  String get linkingNewBankAccounts => _t({'en': 'Linking new bank accounts', 'am': 'አዲስ ባንክ ሒሳብ ማያያዝ', 'ti': 'ምትእስሳር ናይ ሓድሽ ኣካውንት ባንክ', 'om': 'Herrega baankii haaraa walqabsiisuu', 'so': 'Xidista akoonka bangiga cusub', 'gur': 'አዲስ ባንክ ሒሳብ ማሰር'});
  String get biometricWebNote => _t({'en': 'Biometric auth requires the mobile app. PIN-based protection works on web.', 'am': 'ባዮሜትሪክ ለሞባይል ብቻ ነው። PIN ለድር ጣቢያ ይሰራል።', 'ti': 'ባዮሜትሪክ ንሞባይል ኣፕ ጥራይ እዩ። PIN ኣብ ድሓን ይሰርሕ።', 'om': 'Biometric app mobile qofa. PIN web irratti hojjeta.', 'so': 'Biometric app-ka mobileka ku maha. PIN-ku web ku shaqeeyaa.', 'gur': 'ባዮሜትሪክ ለሞባይል ብቻ ነው። PIN ለድር ይሰራል።'});

  // ─── Alerts screen ──────────────────────────────
  String get priceAlertsTitle => _t({'en': 'Price Alerts', 'am': 'የዋጋ ማስጠንቀቂያዎች', 'ti': 'መጠንቀቕታ ዋጋ', 'om': 'Beeksisa Gatii', 'so': 'Digniinada Qiimaha', 'gur': 'የዋጋ ማስጠንቀቂያዎች'});
  String get getNotifiedOnPriceChanges => _t({'en': 'Get notified on price changes', 'am': 'ለዋጋ ለውጥ ማስጠንቀቂያ ይቀበሉ', 'ti': 'ናይ ዋጋ ለውጢ ክትሕበሩ', 'om': 'Jijjiirama gatii beeksifamaa', 'so': 'Waa lagugu ogaysiiyaa isbeddelada qiimaha', 'gur': 'ለዋጋ ለውጥ ተጠንቀቂ'});
  String get createPriceAlert => _t({'en': 'Create Price Alert', 'am': 'የዋጋ ማስጠንቀቂያ ፍጠር', 'ti': 'ናይ ዋጋ ሓደጋ ምልክት ፍጠር', 'om': 'Beeksisa gatii uumi', 'so': 'Samee digniinta qiimaha', 'gur': 'የዋጋ ማስጠንቀቂያ ፍጠር'});
  String get triggered => _t({'en': 'Triggered', 'am': 'ተነሳ', 'ti': 'ተወሊዑ', 'om': 'Kaafame', 'so': 'La kiciyay', 'gur': 'ተነሳ'});
  String get activeAlerts => _t({'en': 'Active Alerts', 'am': 'ንቁ ማስጠንቀቂያዎች', 'ti': 'ንጡፋት ሓደጋ ምልክቶ', 'om': 'Beeksisota hojii irra jiran', 'so': 'Digniinada firfircoon', 'gur': 'ንቁ ማስጠንቀቂያዎች'});
  String get noAlertsYet => _t({'en': 'No alerts yet', 'am': 'ገና ማስጠንቀቂያ የለም', 'ti': 'ገና ሓደጋ ምልክት የለን', 'om': 'Hanga ammaatti beeksisni hin jiru', 'so': 'Wali digniin ma jirto', 'gur': 'ገና ማስጠንቀቂያ የለም'});
  String get tapPlusToCreateAlert => _t({'en': 'Tap + to create a price alert', 'am': '+ ን ነኩ ለዋጋ ማስጠንቀቂያ ለመፍጠር', 'ti': '+ ተንኩ ናይ ዋጋ ሓደጋ ምልክት ክትፍጥሩ', 'om': 'Beeksisa gatii uumuuf + tuqi', 'so': 'Tabo + si aad u samayso digniinta qiimaha', 'gur': '+ ን ርኩ ለዋጋ ማስጠንቀቂያ ለማዘጋጀት'});
  String get loadMarketDataFirst => _t({'en': 'Load market data first', 'am': 'አስቀድሞ የገበያ ውሂብ ጫን', 'ti': 'ቅድም ዳታ ዕዳጋ ጸዓን', 'om': 'Dursa daataa gabaa fe\'adhu', 'so': 'Marka hore soo geli xogta suuqa', 'gur': 'አስቀድሞ የገቢያ ሓበሬታ ጫን'});
  String get above => _t({'en': 'Above', 'am': 'ከ...በላይ', 'ti': 'ልዕሊ', 'om': 'Ol', 'so': 'Ka sarreeya', 'gur': 'ከ...በላይ'});
  String get below => _t({'en': 'Below', 'am': 'ከ...በታች', 'ti': 'ትሕቲ', 'om': 'Gadi', 'so': 'Ka hooseeya', 'gur': 'ከ...በታች'});
  String get create => _t({'en': 'Create', 'am': 'ፍጠር', 'ti': 'ፍጠር', 'om': 'Uumi', 'so': 'Abuur', 'gur': 'ፍጠር'});
  String get targetPrice => _t({'en': 'Target Price (ETB)', 'am': 'ዒላማ ዋጋ (ETB)', 'ti': 'ዒላማ ዋጋ (ETB)', 'om': 'Gatii kaayyoo (ETB)', 'so': 'Qiimaha bartilmaameedka (ETB)', 'gur': 'ዒላማ ዋጋ (ETB)'});

  // ─── News screen ────────────────────────────────
  String get newsFeedTitle => _t({'en': 'News Feed', 'am': 'ዜና ምንጭ', 'ti': 'ዜና ምንጪ', 'om': 'Oduu Odeeffannoo', 'so': 'Wararka Cusub', 'gur': 'ዜና ምንጭ'});
  String get financialIslamicNews => _t({'en': 'Financial & Islamic Finance News', 'am': 'ፋይናንሻል እና ኢስላማዊ ፋይናንስ ዜናዎች', 'ti': 'ዜናታት ፋይናንሻልን ናይ ኢስላም ፋይናንስን', 'om': 'Oduu Faayinaansii fi Baankii Islaamaa', 'so': 'Wararka maaliyadda & maaliyada islaamka', 'gur': 'ፋይናንሻልና ኢስላማዊ ፋይናንስ ዜናዎች'});
  String get failedToLoadNews => _t({'en': 'Failed to load news', 'am': 'ዜናውን መጫን አልተሳካም', 'ti': 'ዜና ምጽዓን ኣይሰለጠን', 'om': "Oduu fe'uun hin milkoofne", 'so': 'Ma guulaysan in la soo gelisto wararka', 'gur': 'ዜናን መጫን አልተሳካም'});
  String get linkCopied => _t({'en': 'Link copied to clipboard', 'am': 'ሊንክ ተቀድቷል', 'ti': 'ሊንክ ተቀዲሁ', 'om': 'Liinkiin garagaltee', 'so': 'Xiriirku waa la koobiyeeyay', 'gur': 'ሊንክ ተቀደ'});
  String get noNewsAvailable => _t({'en': 'No news available', 'am': 'ምንም ዜና የለም', 'ti': 'ዜና ዘይብሉ', 'om': 'Oduu hin jiru', 'so': 'War la heli maayo', 'gur': 'ምንም ዜና የለም'});
  String get newsAll => _t({'en': 'All', 'am': 'ሁሉም', 'ti': 'ኩሉ', 'om': 'Hundaa', 'so': 'Dhammaan', 'gur': 'ኩሉ'});
  String get newsResearch => _t({'en': 'Research', 'am': 'ምርምር', 'ti': 'መጽናዕቲ', 'om': 'Qorannoo', 'so': 'Cilmi-baaris', 'gur': 'ምርምር'});
  String get newsEthiopia => _t({'en': 'Ethiopia', 'am': 'ኢትዮጵያ', 'ti': 'ኢትዮጵያ', 'om': 'Itoophiyaa', 'so': 'Itoobiya', 'gur': 'ኢትዮጵያ'});
  String get newsIslamicFinance => _t({'en': 'Islamic Finance', 'am': 'ኢስላማዊ ፋይናንስ', 'ti': 'ናይ ኢስላም ፋይናንስ', 'om': 'Faayinaansii Islaamaa', 'so': 'Maaliyada Islaamka', 'gur': 'ኢስላማዊ ፋይናንስ'});
  String get newsGlobal => _t({'en': 'Global', 'am': 'ዓለም አቀፍ', 'ti': 'ዓለምለኸ', 'om': 'Addunyaa', 'so': 'Caalamiga', 'gur': 'ዓለም አቀፍ'});

  // ─── Transactions screen ─────────────────────────
  String get transactionStatement => _t({'en': 'Transaction Statement', 'am': 'ግብይት ሪፖርት', 'ti': 'ጸብጻብ ምትሕልላፍ', 'om': 'Ibsa hojii mallaqa', 'so': 'Warbixinta macaamiladda', 'gur': 'ግብይት ሪፖርት'});
  String recordsCount(int n) => _t({'en': '$n records', 'am': '$n መዝገቦች', 'ti': '$n ሰነዳት', 'om': '$n galmeewwan', 'so': '$n diiwaan', 'gur': '$n መዝገቦች'});
  String get description => _t({'en': 'Description', 'am': 'መግለጫ', 'ti': 'ምርኣይ', 'om': 'Ibsa', 'so': 'Sharaxaad', 'gur': 'መግለጫ'});
  String get amountEtb => _t({'en': 'Amount (ETB)', 'am': 'መጠን (ETB)', 'ti': 'ዓቐን (ETB)', 'om': 'Baay\'ina (ETB)', 'so': 'Xadiga (ETB)', 'gur': 'መጠን (ETB)'});
  String get balanceAfter => _t({'en': 'Balance After', 'am': 'ቀሪ ሂሳብ በኋላ', 'ti': 'ቀሪ ሒሳብ ድሕሪ', 'om': 'Haftee booda', 'so': 'Haraagaha ka dib', 'gur': 'ቀሪ ሒሳብ ድሕሪ'});
  String get balanceAfterEtb => _t({'en': 'Balance After (ETB)', 'am': 'ቀሪ ሂሳብ (ETB)', 'ti': 'ቀሪ ሒሳብ (ETB)', 'om': 'Haftee (ETB)', 'so': 'Haraagaha (ETB)', 'gur': 'ቀሪ ሒሳብ (ETB)'});
  String get txDeposit => _t({'en': 'Deposit', 'am': 'ተቀብሎ', 'ti': 'ምቅባል ገንዘብ', 'om': 'Galchaa', 'so': 'Dhigitaanka', 'gur': 'ምቅባል'});
  String get txWithdrawal => _t({'en': 'Withdrawal', 'am': 'ወጪ', 'ti': 'ምውጻእ', 'om': 'Baasuun', 'so': 'Bixitaanka', 'gur': 'ወጪ'});
  String get txTradeBuy => _t({'en': 'Trade Buy', 'am': 'የንግድ ግዢ', 'ti': 'ምዕዳጊ ንግዲ', 'om': 'Bituun daldala', 'so': 'Ganacsiga Iibsashada', 'gur': 'የንግድ ግዢ'});
  String get txTradeSell => _t({'en': 'Trade Sell', 'am': 'የንግድ ሽያጭ', 'ti': 'ሸይጢ ንግዲ', 'om': 'Gurguruun daldala', 'so': 'Ganacsiga Iibishada', 'gur': 'የንግድ ሽያጭ'});
  String get txRefund => _t({'en': 'Refund', 'am': 'ተመላሽ', 'ti': 'ምምላስ', 'om': 'Deebi\'aa', 'so': 'Celcelin', 'gur': 'ተመላሽ'});

  // ─── Trade screen ────────────────────────────────
  String get enterValidQtyPrice => _t({'en': 'Enter valid quantity and price', 'am': 'ትክክለኛ ብዛት እና ዋጋ ያስገቡ', 'ti': 'ቅቡል ብዝሒ እና ዋጋ ኣእቱ', 'om': "Baay'ina fi gatii sirrii galchi", 'so': 'Geli tirada saxda ah iyo qiimaha', 'gur': 'ትክክለኛ ብዛት እና ዋጋ ያስገቡ'});
  String get limitOrderPlaced => _t({'en': 'Limit order placed (pending fill)', 'am': 'የሊሚት ትዕዛዝ ቀርቧል (ሊፈጸም ይጠበቃል)', 'ti': 'ናይ ሊሚት ትእዛዝ ቀሪቡ', 'om': 'Ajajni daangaa kaa\'e (guutuu eegama)', 'so': 'Dalabka xuduudda la keenay (buuxinta la sugayaa)', 'gur': 'ሊሚት ትዕዛዝ ቀርቧል'});
  String orderFilled(String fee) => _t({'en': 'Order filled! Fee: $fee ETB', 'am': 'ትዕዛዝ ተሟልቷል! ክፍያ: $fee ETB', 'ti': 'ትእዛዝ ተሟሊኡ! ክፍሊት: $fee ETB', 'om': 'Ajajni guutame! Kaffaltii: $fee ETB', 'so': 'Dalabtii waa la buuxiyay! Khidmad: $fee ETB', 'gur': 'ትዕዛዝ ተሟልቷል! ክፍያ: $fee ETB'});
  String get orderFailed => _t({'en': 'Order failed', 'am': 'ትዕዛዝ አልተሳካም', 'ti': 'ትእዛዝ ኣይሰለጠን', 'om': 'Ajajni hin milkoofne', 'so': 'Dalabtii guuldareysatay', 'gur': 'ትዕዛዝ አልተሳካም'});
  String get overview => _t({'en': 'Overview', 'am': 'አጠቃላይ እይታ', 'ti': 'ሓፈሻዊ ርእይቶ', 'om': 'Ilaalcha waliigalaa', 'so': 'Dulmarinta guud', 'gur': 'አጠቃላይ እይታ'});
  String get financials => _t({'en': 'Financials', 'am': 'ፋይናንሻል', 'ti': 'ፋይናንሻል', 'om': 'Faayinaansii', 'so': 'Maaliyadda', 'gur': 'ፋይናንሻል'});
  String get newsTab => _t({'en': 'News', 'am': 'ዜናዎች', 'ti': 'ዜናታት', 'om': 'Oduu', 'so': 'Wararka', 'gur': 'ዜናዎች'});
  String get orderBook => _t({'en': 'Order book', 'am': 'የትዕዛዝ ደብተር', 'ti': 'ደብተር ትእዛዝ', 'om': 'Kitaaba ajajaa', 'so': 'Buugga dalabta', 'gur': 'የትዕዛዝ ደብተር'});
  String get assetInformation => _t({'en': 'Asset Information', 'am': 'የንብረት መረጃ', 'ti': 'ሓበሬታ ንብረት', 'om': 'Odeeffannoo qabeenyaa', 'so': 'Macluumaadka hantida', 'gur': 'የንብረት ሓበሬታ'});
  String get nameLabel => _t({'en': 'Name', 'am': 'ስም', 'ti': 'ስም', 'om': 'Maqaa', 'so': 'Magac', 'gur': 'ስም'});
  String get amharicName => _t({'en': 'Amharic', 'am': 'አማርኛ', 'ti': 'ኣምሓርኛ', 'om': 'Amaariffaa', 'so': 'Amxaari', 'gur': 'አምሃርኛ'});
  String get minTrade => _t({'en': 'Min Trade', 'am': 'ዝቅተኛ ንግድ', 'ti': 'ዝተሓተ ንግዲ', 'om': 'Daldala xiqqaa', 'so': 'Ganacsiga ugu yar', 'gur': 'ዝቅተኛ ንግድ'});
  String get maxTrade => _t({'en': 'Max Trade', 'am': 'ከፍተኛ ንግድ', 'ti': 'ዝለዓለ ንግዲ', 'om': 'Daldala guddaa', 'so': 'Ganacsiga ugu badan', 'gur': 'ከፍተኛ ንግድ'});
  String get volume24h => _t({'en': '24h Volume', 'am': '24ሰ ዓቀን', 'ti': '24ሰ ዓቐን', 'om': "Sa'a 24 hammata", 'so': 'Xajmiga 24-ka saac', 'gur': '24 ሰዓት ዓቀን'});
  String get ecxListed => _t({'en': 'ECX Listed', 'am': 'ECX ዝርዝር', 'ti': 'ECX ዝርዝር', 'om': 'Tarree ECX', 'so': 'ECX liis', 'gur': 'ECX ዝርዝር'});
  String get compliant => _t({'en': 'Compliant', 'am': 'ተወካይ', 'ti': 'ተኣዛዛይ', 'om': 'Walsimatu', 'so': 'U hoggaansan', 'gur': 'ተወካይ'});
  String get notApplicable => _t({'en': 'N/A', 'am': 'ይለቀምም', 'ti': 'ዘይምልከቶ', 'om': "Hin dhibamne", 'so': 'Ku habboon ma aha', 'gur': 'N/A'});
  String get aaaoifiShariaScreening => _t({'en': 'AAOIFI Sharia Screening', 'am': 'AAOIFI ሸሪዓ ምርመራ', 'ti': 'AAOIFI ስክሪኒንግ ሸሪዓ', 'om': 'Qorannooo Shari\'aa AAOIFI', 'so': 'Shaandhaynta Shariicada AAOIFI', 'gur': 'AAOIFI ሸሪዓ ምርምራ'});
  String get debtToAssetsRatio => _t({'en': 'Debt-to-Assets Ratio', 'am': 'ዕዳ-ወደ-ንብረት ጥምርታ', 'ti': 'ጥምርታ ዕዳ-ናብ-ንብረት', 'om': 'Garee liqii-gara-qabeenyaa', 'so': 'Saamiga deynta-ilaa-hantida', 'gur': 'ዕዳ-ወደ-ንብረት ጥምርታ'});
  String get haramRevenueRatio => _t({'en': 'Haram Revenue Ratio', 'am': 'ሐራም ገቢ ጥምርታ', 'ti': 'ጥምርታ ናይ ሓራም እቶት', 'om': 'Garee galii Haraamaa', 'so': 'Saamiga dakhliga Xaraamka', 'gur': 'ሐራም ዝፈሰሰ ጥምርታ'});
  String get newsForAsset => _t({'en': 'Asset-specific news coming soon', 'am': 'ለዚህ ንብረት ዜናዎች በቅርቡ ይጀምራሉ', 'ti': 'ዜናታት ናይዚ ንብረት ቀልጢፉ ይጅምር', 'om': 'Oduu qabeenyaa kanaa dhufu', 'so': 'Wararka ku saabsan hantida waxay soo socdaa', 'gur': 'ለዚህ ንብረት ዜናዎች ቅርቡ ይጀምሩ'});
  String noOrdersForAsset(String symbol) => _t({'en': 'No orders for $symbol', 'am': 'ለ$symbol ምንም ትዕዛዝ የለም', 'ti': 'ናይ $symbol ትእዛዝ ዘይብሉ', 'om': 'Ajajota $symbol hin jiran', 'so': 'Dalabyo $symbol ma jiraan', 'gur': 'ለ$symbol ምንም ትዕዛዝ የለም'});
  String get yourOrdersAppearHere => _t({'en': 'Your orders for this asset appear here', 'am': 'ለዚህ ንብረት ትዕዛዞቹ ይታዩሃሉ', 'ti': 'ትእዛዛትካ ናይዚ ንብረት ኣብዚ ይርኣዩ', 'om': 'Ajajootakee qabeenyaa kanaa asitti mul\'atu', 'so': 'Dalabyadaadu hantidan kugu soo muuqdaan halkan', 'gur': 'ለዚህ ንብረት ትዕዛዞቹ ይታያሉ'});
  String get categoryLabel => _t({'en': 'Category', 'am': 'ምድብ', 'ti': 'ዓይነት', 'om': 'Gosa', 'so': 'Qaybta', 'gur': 'ምድብ'});
  String get shariaLabel => _t({'en': 'Sharia', 'am': 'ሸሪዓ', 'ti': 'ሸሪዓ', 'om': "Shari'aa", 'so': 'Shariicada', 'gur': 'ሸሪዓ'});
  String newsForSymbol(String symbol) => _t({'en': 'News for $symbol', 'am': 'ለ$symbol ዜናዎች', 'ti': 'ዜናታት ናይ $symbol', 'om': 'Oduu $symbol', 'so': 'Wararka $symbol', 'gur': 'ለ$symbol ዜናዎች'});
  String get debtToAssetsThreshold => _t({'en': '< 30% (AAOIFI)', 'am': '< 30% (AAOIFI)', 'ti': '< 30% (AAOIFI)', 'om': '< 30% (AAOIFI)', 'so': '< 30% (AAOIFI)', 'gur': '< 30% (AAOIFI)'});
  String get haramRevenueThreshold => _t({'en': '< 5% (AAOIFI)', 'am': '< 5% (AAOIFI)', 'ti': '< 5% (AAOIFI)', 'om': '< 5% (AAOIFI)', 'so': '< 5% (AAOIFI)', 'gur': '< 5% (AAOIFI)'});
  String get aaoifiScreeningNote => _t({'en': 'Screened in accordance with AAOIFI Sharia Standard No. 21 — Financial Paper (Shares and Bonds). ECX & NBE regulated.', 'am': 'ለ AAOIFI ሸሪዓ ደረጃ ቁ. 21 — ፋይናንሺያ ወረቀት (አክሲዮን እና ቦንድ) መሠረት ተምርኖ። ECX እና NBE ቁጥጥር።', 'ti': 'ብ AAOIFI ሸሪዓ ደረጃ ቁ. 21 — ሓፈሻዊ ወቕዒ ናይ ምምርማር። ECX ን NBE ቁጹር።', 'om': "AAOIFI Shari'aa Lak. 21 hordoofuun qoratame — Waraqaa Maallaqaa (Hirmaannaa fi Boondii). ECX fi NBE to'atama.", 'so': 'La shaandheeyay sida AAOIFI Shariicada Heerka Lambarka 21 — Xaashida Maaliyadda. ECX & NBE waa la nidaamiyay.', 'gur': 'AAOIFI ሸሪዓ ደረጃ ቁ. 21 — ፋይናንሺያ ወረቀት (አክሲዮን እና ቦንድ) ሰረት ተምርኖ። ECX እና NBE ቁጥጥር།'});
  String get setAlert => _t({'en': 'Set Alert', 'am': 'ማስጠንቀቂያ አዘጋጅ', 'ti': 'ሓደጋ ምልክት ኣዘጋጅ', 'om': 'Beeksisa qindeessi', 'so': 'Deji digniinta', 'gur': 'ማስጠንቀቂያ አዘጋጅ'});
  String alertSet(String symbol, String price) => _t({'en': 'Alert set for $symbol at $price ETB', 'am': 'ለ$symbol ዋጋ $price ETB ማስጠንቀቂያ ተዘጋጅቷል', 'ti': 'ናይ $symbol ዋጋ $price ETB ሓደጋ ምልክት ተዘጊቡ', 'om': 'Beeksisni $symbol gatii $price ETB qindaa\'e', 'so': 'Digniinta $symbol qiimaha $price ETB la dejiyay', 'gur': 'ለ$symbol $price ETB ማስጠንቀቂያ ተዘጋጅቷል'});

  // ─── Profile screen ──────────────────────────────
  String get memberSince => _t({'en': 'Member', 'am': 'አባል', 'ti': 'ኣባል', 'om': 'Miseensa', 'so': 'Xubin', 'gur': 'አባል'});
  String get complianceCard => _t({'en': 'Compliance', 'am': 'ተገዢነት', 'ti': 'ተኣዛዝነት', 'om': 'Hordoffii', 'so': 'U hoggaansamid', 'gur': 'ተስማሚነት'});
  String get standardsAndCertification => _t({'en': 'Standards & certification', 'am': 'ደረጃዎች እና ምስክርነቶች', 'ti': 'ደረጃታትን ምስክርነትን', 'om': "Sadarkaalee fi ragaa ba'umsaa", 'so': 'Heerarka & shahaadada', 'gur': 'ደረጃዎች እና ምስክርነቶች'});
  String get preferences => _t({'en': 'Preferences', 'am': 'ምርጫዎች', 'ti': 'ምርጫታት', 'om': 'Filannoolee', 'so': 'Doorashooyinka', 'gur': 'ምርጫዎች'});
  String get settingsAndPreferences => _t({'en': 'Settings & preferences', 'am': 'ቅንብሮች እና ምርጫዎች', 'ti': 'ቅጥዒታትን ምርጫታትን', 'om': "Qindaa'inoota fi filannoolee", 'so': 'Dejinta & doorashooyinka', 'gur': 'ቅንብሮች እና ምርጫዎች'});
  String get managePriceAlerts => _t({'en': 'Manage price & order alerts', 'am': 'የዋጋ እና ትዕዛዝ ማስጠንቀቂያዎችን ያስተዳድሩ', 'ti': 'ናይ ዋጋን ትእዛዝን ሓደጋ ምልክቶ ምምሕዳር', 'om': 'Beeksisota gatii fi ajajaa bulchi', 'so': 'Maamul digniinada qiimaha & dalabyada', 'gur': 'የዋጋ እና ትዕዛዝ ማስጠንቀቂያዎችን ያስተዳድሩ'});
  String get wealthProtectionAndPin => _t({'en': 'Wealth protection & PIN', 'am': 'የሀብት ጥበቃ እና PIN', 'ti': 'ሓለዋ ሃብቲ እን PIN', 'om': 'Tikina waaqaa fi PIN', 'so': 'Ilaalinta hantida & PIN', 'gur': 'የሃብት ጥበቃ እና PIN'});
  String get kycRequired => _t({'en': 'KYC Required', 'am': 'KYC ያስፈልጋል', 'ti': 'KYC የድሊ', 'om': 'KYC barbaachisa', 'so': 'KYC loo baahan yahay', 'gur': 'KYC ያስፈጋል'});
  String get completeKycToTrade => _t({'en': 'Complete identity verification to start trading.', 'am': 'ለመጀመር ንግድ ማንነት ማረጋገጥ ያስፈልጋል።', 'ti': 'ንምጅማር ንግዲ ናይ ህልውና ምርግጋጽ ኣካሂዱ።', 'om': 'Daldalamuuf mirkaneessaa eenyummaa raawwadhu.', 'so': 'Si aad u bilaabato ganacsiga xaqiijinta aqoonsiga dhammaystir.', 'gur': 'ለጀምር ንግድ ማንነት ማረጋገጥ ያስፈጋል።'});
  String get verifyNow => _t({'en': 'Verify Now', 'am': 'አሁን አረጋጥ', 'ti': 'ሕጂ ኣረጋግጽ', 'om': 'Amma mirkaneessi', 'so': 'Hada xaqiiji', 'gur': 'አሁን አረጋጥ'});
  String get yourInformation => _t({'en': 'Your information', 'am': 'የእርስዎ መረጃ', 'ti': 'ሓበሬታኻ', 'om': 'Odeeffannoo kee', 'so': 'Macluumaadkaaga', 'gur': 'ያንተ ሓበሬታ'});
  String get retailTrader => _t({'en': 'Retail Trader', 'am': 'ቀጥታ ነጋዴ', 'ti': 'ናይ ቀጥታ ነጋዳይ', 'om': 'Daldaltuu xiqqaa', 'so': 'Ganacsade qayb-yar', 'gur': 'ቀጥታ ነጋዴ'});
  String get noSecurityEvents => _t({'en': 'No security events recorded', 'am': 'ምንም የደህንነት ክስተቶች አልተቀረጹም', 'ti': 'ናይ ድሕንነት ፍጻሜታት ዘይምዝጋቦ', 'om': 'Raawwataalee nageenyaa hin galmaawne', 'so': 'Dhacdo amni lama duwan', 'gur': 'ምንም ደህንነት ክስተቶች አልተቀረጹም'});
  String get helpFaqComingSoon => _t({'en': 'Help & FAQ — coming soon', 'am': 'እርዳታ እና FAQ — በቅርቡ', 'ti': 'ሓገዝን FAQ — ቀልጢፉ ይጅምር', 'om': 'Gargaarsa fi FAQ — dhufu', 'so': 'Caawimaada & Su\'aalaha — waxay soo socdaa', 'gur': 'እርዳታ እና FAQ — ቅርቡ'});
  String get appLockPinSet => _t({'en': 'PIN set — tap to change or disable', 'am': 'PIN ተቀናብሯል — ለማስተካከል ወይም ለማሰናከል ነኩ', 'ti': 'PIN ቀናቢሩ — ንምቕያር ወይ ንምዕጋት ተንኩ', 'om': 'PIN qindaa\'ame — jijjiiruuf yookaan dhaabsuuf tuqi', 'so': 'PIN la dejiyay — si aad u beddesho ama u damiiso tabo', 'gur': 'PIN ተቀናብሯል — ለማስተካከል ወይም ለዝጋት ርኩ'});
  String get setAppLockPin => _t({'en': 'Set a PIN to lock the app', 'am': 'መተግበሪያ ለመቆለፍ PIN ይዘጋጅ', 'ti': 'ኣፕ ክሽጉ PIN ኣዘጋጅ', 'om': 'App cufuuf PIN qindeessi', 'so': 'PIN dejiso si aad u xiddo app-ka', 'gur': 'ኣፕ ለዝጋት PIN ኣዘጋጅ'});
  String get pinChangeRemoveDialog => _t({'en': 'Change / Remove PIN', 'am': 'PIN ቀይር / አስወግድ', 'ti': 'PIN ቀይር / ኣልዓል', 'om': 'PIN jijjiiri / haqii', 'so': 'Bedel / Ka saar PIN', 'gur': 'PIN ቀይር / አስወግድ'});
  String get setAppLockPinDialog => _t({'en': 'Set App Lock PIN', 'am': 'የኣፕ ቆልፍ PIN ዘርጋ', 'ti': 'ናይ ኣፕ ቆልፍ PIN ኣዘጋጅ', 'om': 'PIN cufaa App qindeessi', 'so': 'Dejiso PIN xididdiga app-ka', 'gur': 'የኣፕ ቆልፍ PIN ዘርጋ'});
  String get pinDialogInstructions => _t({'en': 'Enter a 4-digit PIN to lock TradEt when backgrounded for 60+ seconds.', 'am': 'TradEt 60+ ሰኮንድ ጀርባ ሲሆን ለመቆለፍ 4 ዲጂት PIN ያስገቡ።', 'ti': 'TradEt 60+ ሰኮንድ ኣቅሚ ሸፊኑ ክሽጉ 4 ዲጂት PIN ኣእቱ።', 'om': 'TradEt sekondi 60+ duuba yoo ta\'e PIN lakkoofsota 4 galchi.', 'so': 'Geli 4-nambar PIN si aad ugu xiddo TradEt marka uu gadaalsadana 60+ ilbiriqsi.', 'gur': 'TradEt 60+ ሰኮንድ ጀርባ ሲሆን ለዝጋት 4 ቁጥር PIN ያስገቡ።'});
  String get newPin4Digits => _t({'en': 'New PIN (4 digits)', 'am': 'አዲስ PIN (4 ቁጥሮች)', 'ti': 'ሓዲሽ PIN (4 ቁጽርታት)', 'om': 'PIN haaraa (lakkoofsota 4)', 'so': 'PIN cusub (4 lambar)', 'gur': 'አዲስ PIN (4 ቁጥሮች)'});
  String get confirmPin => _t({'en': 'Confirm PIN', 'am': 'PIN አረጋግጥ', 'ti': 'PIN ኣረጋግጽ', 'om': 'PIN mirkaneessi', 'so': 'Xaqiiji PIN', 'gur': 'PIN አረጋጥ'});
  String get appLockDisabled => _t({'en': 'App lock disabled', 'am': 'የኣፕ ቆልፍ ተሰናክሏል', 'ti': 'ሸፋዕ ኣፕ ተዓፊሩ', 'om': 'Cufaa app dhabamsiifame', 'so': 'Xididdiga app-ka waa la dami-siyay', 'gur': 'የኣፕ ቆልፍ ተዘጋ'});
  String get disable => _t({'en': 'Disable', 'am': 'ሰናኪ', 'ti': 'ዓጊት', 'om': 'Dhabamsiisi', 'so': 'Dami', 'gur': 'ሰናኪ'});
  String get pinMustBe4Digits => _t({'en': 'PIN must be exactly 4 digits', 'am': 'PIN ትክክለኛ 4 ቁጥሮች መሆን አለበት', 'ti': 'PIN ልክ ዝኾኑ 4 ቁጽርታት ክኾን ኣለዎ', 'om': 'PIN lakkoofsota 4 sirriitti ta\'uu qaba', 'so': 'PIN waa in ay noqotaa 4 lambar oo saxsan', 'gur': 'PIN ትክክለኛ 4 ቁጥሮች መሆን አለበት'});
  String get pinsDoNotMatch => _t({'en': 'PINs do not match', 'am': 'PIN ቁጥሮቹ አይዛመዱም', 'ti': 'PIN ቁጽርታት ኣይቃዶን', 'om': 'PINoonni wal hin fakkaatan', 'so': 'PIN-yadu kuma mid ahayn', 'gur': 'PIN ቁጥሮቹ አይዛመዱም'});
  String get appLockPinSetSuccess => _t({'en': 'App lock PIN set', 'am': 'የኣፕ ቆልፍ PIN ተዘጋጅቷል', 'ti': 'ናይ ኣፕ ቆልፍ PIN ተዘጊቡ', 'om': 'PIN cufaa App qindaa\'ame', 'so': 'PIN xididdiga app-ka la dejiyay', 'gur': 'የኣፕ ቆልፍ PIN ተዘጋጅቷል'});
  String get profilePhoto => _t({'en': 'Profile Photo', 'am': 'የፕሮፋይል ፎቶ', 'ti': 'ፎቶ ፕሮፋይል', 'om': 'Suuraa poroofaayilii', 'so': 'Sawirka profile-ka', 'gur': 'የፕሮፋይል ፎቶ'});
  String get uploadPhoto => _t({'en': 'Upload Photo', 'am': 'ፎቶ ጫን', 'ti': 'ፎቶ ጸዓን', 'om': "Suuraa ol-fe'i", 'so': 'Soo geli sawir', 'gur': 'ፎቶ ጫን'});
  String get chooseAvatarColor => _t({'en': 'Choose Avatar Color', 'am': 'የ Avatar ቀለም ምረጡ', 'ti': 'ቀለም Avatar ምረጽ', 'om': 'Halluu Avatar filadhu', 'so': 'Dooro midabka avatar-ka', 'gur': 'Avatar ቀለም ምረጥ'});
  String get removePhoto => _t({'en': 'Remove Photo', 'am': 'ፎቶ ስረዝ', 'ti': 'ፎቶ ኣልዓሎ', 'om': 'Suuraa haqii', 'so': 'Ka saar sawirka', 'gur': 'ፎቶ ስረዝ'});
  String get paymentMethods => _t({'en': 'Payment Methods', 'am': 'የክፍያ ዘዴዎች', 'ti': 'ኣገባብ ክፍሊት', 'om': 'Maloota kaffaltii', 'so': 'Habka lacag bixinta', 'gur': 'የክፍያ ዘዴዎች'});
  String get linkedAccounts => _t({'en': 'Linked accounts', 'am': 'ተያያዥ ሒሳቦች', 'ti': 'ዝተሓሓዙ ኣካውንቶ', 'om': 'Herregoota walqabatan', 'so': 'Xisaabaha la xidhay', 'gur': 'ተያያዥ ሒሳቦች'});
  String get add => _t({'en': 'Add', 'am': 'ጨምር', 'ti': 'ወስኽ', 'om': 'Ida\'i', 'so': 'Ku dar', 'gur': 'ጨምር'});
  String get noPaymentMethodsLinked => _t({'en': 'No payment methods linked yet', 'am': 'ምንም ክፍያ ዘዴ አልተያያዘም', 'ti': 'ክፍሊት ኣፍልጦ ዘይብሉ', 'om': 'Maloota kaffaltii walqabate hin jiran', 'so': 'Hab lacag bixin lama xidhay', 'gur': 'ምንም ክፍያ ዘዴ አልተያያዘም'});
  String get setAsPrimary => _t({'en': 'Set as Primary', 'am': 'እንደ ዋና ቀናብር', 'ti': 'ከም ቀዳማይ ቀናብር', 'om': 'Jalqabaa godhuu', 'so': 'Ka dhig ugu muhiimsan', 'gur': 'እንደ ዋና ቀናብር'});
  String get remove => _t({'en': 'Remove', 'am': 'አስወግድ', 'ti': 'ኣልዓሎ', 'om': 'Haqii', 'so': 'Ka saar', 'gur': 'አስወግድ'});
  String get identityVerification => _t({'en': 'Identity verification', 'am': 'ማንነት ማረጋገጫ', 'ti': 'ምርግጋጽ ህልውና', 'om': 'Mirkaneessaa eenyummaa', 'so': 'Xaqiijinta aqoonsiga', 'gur': 'ማንነት ማረጋገጫ'});
  String get accountHolderName => _t({'en': 'Account Holder Name', 'am': 'የሒሳብ ባለቤት ስም', 'ti': 'ስም ወናናይ ኣካውንት', 'om': 'Maqaa qabeessa herregaa', 'so': 'Magaca laanta akoonka', 'gur': 'የሒሳብ ባለቤት ስም'});
  String get completeKycForTrading => _t({'en': 'Complete KYC to start trading. Required by NBE and ECX regulations.', 'am': 'ለንግድ ለጀምር KYC ያጠናቅቁ። NBE እና ECX ደምብ ያስፈልጋል።', 'ti': 'ንምጅማር ንግዲ KYC ኣጠናቅቕ። ብNBE ን ECX ሕጊ ዘድሊ እዩ።', 'om': 'Daldalamuuf KYC xumuuri. Dambii NBE fi ECX barbaachisa.', 'so': 'Si aad u bilaabato ganacsiga KYC dhammaystir. Shuruucda NBE iyo ECX waa loo baahan yahay.', 'gur': 'ለጀምር ንግድ KYC ያጠናቅቁ። NBE እና ECX ሕጊ ያስፈጋል።'});
  String get submitDocuments => _t({'en': 'Submit Documents', 'am': 'ሰነዶች ያስገቡ', 'ti': 'ሰነዳት ኣቕርብ', 'om': 'Sanadoota galchi', 'so': 'Gudbi Dukumiintiyada', 'gur': 'ሰነዶች ያስገቡ'});
  String get accountType => _t({'en': 'Account Type', 'am': 'የሒሳብ አይነት', 'ti': 'ዓይነት ኣካውንት', 'om': 'Gosa herregaa', 'so': 'Nooca xisaabta', 'gur': 'የሒሳብ ዓይነት'});
  String get kycTier1Verified => _t({'en': 'KYC Tier 1 — Verified', 'am': 'KYC ደረጃ 1 — ተረጋግጧል', 'ti': 'KYC ደረጃ 1 — ተረጋጊጹ', 'om': 'KYC Lakk. 1 — mirkanaaye', 'so': 'KYC Heerka 1 — xaqiijiyay', 'gur': 'KYC ደረጃ 1 — ተረጋግጧል'});
  String get kycTier1InProgress => _t({'en': 'KYC Tier 1 — In Progress', 'am': 'KYC ደረጃ 1 — በሂደት ላይ', 'ti': 'KYC ደረጃ 1 — ሂደት ላይ', 'om': 'KYC Lakk. 1 — hojii irra jira', 'so': 'KYC Heerka 1 — socda', 'gur': 'KYC ደረጃ 1 — በሂደት'});
  String get kycStepRegistration => _t({'en': 'Registration', 'am': 'ምዝገባ', 'ti': 'ምምዝጋብ', 'om': 'Galmee', 'so': 'Diiwaan-gelinta', 'gur': 'ምዝገባ'});
  String get kycStepDocUpload => _t({'en': 'Document Upload', 'am': 'ሰነድ ጫን', 'ti': 'ሰነድ ጸዓን', 'om': "Sanadaa ol-fe'i", 'so': 'Rar Dukumiintiga', 'gur': 'ሰነድ ጫን'});
  String get kycStepTier1Verified => _t({'en': 'Tier 1 Verified', 'am': 'ደረጃ 1 ተረጋግጧል', 'ti': 'ደረጃ 1 ተረጋጊጹ', 'om': 'Lakk. 1 mirkanaaye', 'so': 'Heerka 1 xaqiijiyay', 'gur': 'ደረጃ 1 ተረጋግጧል'});
  String get active => _t({'en': 'Active', 'am': 'ንቁ', 'ti': 'ንጡፍ', 'om': 'Hojii irra jira', 'so': 'Firfircoon', 'gur': 'ንቁ'});
  String memberSinceYear(String year) => _t({'en': 'Member since $year', 'am': 'ከ$year ጀምሮ አባል', 'ti': 'ካብ $year ኣባል', 'om': '$year irraa kaasee miseensa', 'so': 'Xubin tan iyo $year', 'gur': 'ከ$year ጀምሮ አባል'});
  String get notificationComingSoon => _t({'en': 'Notification preferences — coming soon', 'am': 'የማሳወቂያ ምርጫዎች — በቅርቡ', 'ti': 'ምምዛዝ ምልክት — ቀልጢፉ', 'om': 'Filannoo beeksisaa — dhufu', 'so': 'Dooro ogeysiinta — waxay soo socdaa', 'gur': 'የማሳወቂያ ምርጫዎች — ቅርቡ'});
  String get removeAccountTitle => _t({'en': 'Remove Account', 'am': 'ሒሳብ ያስወግዱ', 'ti': 'ኣካውንት ኣልዓሎ', 'om': 'Herrega haqii', 'so': 'Ka saar xisaabta', 'gur': 'ሒሳብ ያስወግዱ'});
  String removeAccountConfirm(String bank, String num) => _t({'en': 'Remove $bank $num?', 'am': '$bank $num ያስወግዱ?', 'ti': '$bank $num ኣልዓሎ?', 'om': '$bank $num haquuf?', 'so': 'Ka saaro $bank $num?', 'gur': '$bank $num ያስወግዱ?'});
  String get kycVerifiedSuccess => _t({'en': 'KYC verified successfully!', 'am': 'KYC በሚገባ ተረጋግጧል!', 'ti': 'KYC ብዓወት ተረጋጊጹ!', 'om': 'KYC milkidhaan mirkanaaye!', 'so': 'KYC si guul leh ayaa la xaqiijiyay!', 'gur': 'KYC በሚገባ ተረጋግጧል!'});
  String get kycSubmitFailed => _t({'en': 'KYC submission failed', 'am': 'KYC ማቅረቢያ አልተሳካም', 'ti': 'KYC ምቕራብ ኣይሰለጠን', 'om': 'Dhiyeessuu KYC hin milkoofne', 'so': 'Gudbitaanka KYC wuu fashilmay', 'gur': 'KYC ማቅረቢያ አልተሳካም'});
  String get savePIN => _t({'en': 'Save PIN', 'am': 'PIN ያስቀምጡ', 'ti': 'PIN ኣቐምጥ', 'om': 'PIN kuusi', 'so': 'Kaydi PIN', 'gur': 'PIN ያስቀምጡ'});
  String get addPaymentMethodTitle => _t({'en': 'Add Payment Method', 'am': 'የክፍያ ዘዴ ጨምር', 'ti': 'ኣገባብ ክፍሊት ወስኽ', 'om': 'Mala kaffaltii ida\'i', 'so': 'Ku dar hab lacag bixin', 'gur': 'የክፍያ ዘዴ ጨምር'});
  String couldNotLoadImage(String error) => _t({'en': 'Could not load image: $error', 'am': 'ስዕሉ ለማምጣት አልተቻለም: $error', 'ti': 'ስዕሊ ምጽዓን ኣይተኻእለን: $error', 'om': 'Suuraa fe\'uu hin danda\'amne: $error', 'so': 'Sawirka lama soo qaadi karin: $error', 'gur': 'ምስሉ ለማምጣት አልተቻለም: $error'});
  String securityEventsCount(int n) => _t({'en': '$n events', 'am': '$n ክስተቶች', 'ti': '$n ፍጻሜታት', 'om': '$n raawwataalee', 'so': '$n dhacdo', 'gur': '$n ክስተቶች'});
  String get halalScreened => _t({'en': 'Halal screened', 'am': 'ሃላል ተምርኗል', 'ti': 'ሃላል ተምርኑ', 'om': 'Halaala qoratame', 'so': 'Xalaal la shaandheeyay', 'gur': 'ሃላል ተምርኗል'});
  String get ethiopianRules => _t({'en': 'Ethiopian rules', 'am': 'የኢትዮጵያ ደምብ', 'ti': 'ሕጊ ኢትዮጵያ', 'om': 'Dambii Itoophiyaa', 'so': 'Xeerarka Itoobiya', 'gur': 'የኢትዮጵያ ደምብ'});
  String get nationalBank => _t({'en': 'National Bank', 'am': 'ብሔራዊ ባንክ', 'ti': 'ሃገራዊ ባንክ', 'om': 'Baankii Biyyoolessaa', 'so': 'Baanka Qaranka', 'gur': 'ብሔራዊ ባንክ'});
  String get noInterestLabel => _t({'en': 'No interest', 'am': 'ወለድ የለም', 'ti': 'ወለድ የለን', 'om': 'Dhala hin qabu', 'so': 'Ribada la\'aan', 'gur': 'ወለድ የለም'});
  String get spotTradingOnly => _t({'en': 'Spot trading only', 'am': 'ቀጥተኛ ግብይት ብቻ', 'ti': 'ቀጥታዊ ንግዲ ጥራሕ', 'om': 'Daldalama kallattii qofa', 'so': 'Ganacsiga toosinka ah oo keliya', 'gur': 'ቀጥተኛ ንግድ ብቻ'});
  String get allAssetsScreened => _t({'en': 'All assets screened for halal compliance', 'am': 'ሁሉም ንብረቶች ለሃላል ተምርነዋል', 'ti': 'ኩሎም ንብረታት ሃላል ተምርኖም', 'om': 'Qabeenyi hundi halaalaaf qoratame', 'so': 'Dhammaan hantidu waxay shaandheyn u galeen', 'gur': 'ሁሉም ንብረቶች ሃላል ተምርነዋል'});
  String get ecxRulesSubtitle => _t({'en': 'Trading under Ethiopia Commodity Exchange rules', 'am': 'በኢትዮጵያ ምርት ልውውጥ ደምብ ስር', 'ti': 'ብሕጊ ናይ ECX ኢትዮጵያ', 'om': 'Dambii ECX Itoophiyaa jalatti', 'so': 'Ganacsiga hoosta xeerarka ECX Itoobiya', 'gur': 'የኢትዮጵያ ምርት ልውውጥ ደምብ'});
  String get nbeFrameworkSubtitle => _t({'en': 'National Bank of Ethiopia regulatory framework', 'am': 'የኢትዮጵያ ብሔራዊ ባንክ ቁጥጥር ማዕቀፍ', 'ti': 'ናይ ብሔራዊ ባንክ ኢትዮጵያ ኩርናዕ', 'om': 'Caaseffama to\'annoo NBE', 'so': 'Nidaamka Xeerarka NBE', 'gur': 'የNBE ቁጥጥር ማዕቀፍ'});
  String get flatCommissionOnly => _t({'en': 'Flat commission fees only — no interest charges', 'am': 'የተቋቋመ ኮሚሽን ክፍያ ብቻ — ወለድ የለም', 'ti': 'ክፍሊት ኮሚሽን ጥራሕ — ወለድ የለን', 'om': 'Kafaltii komishinii qofaa — dhala hin qabu', 'so': 'Khidmadda komishinada oo keliya — ribada la\'aan', 'gur': 'ጥቃቅን ኮሚሽን ብቻ — ወለድ የለም'});
  String get sellOwnAssetsOnly => _t({'en': 'Only sell assets you own — spot trading only', 'am': 'የሚኖሩ ንብረቶቼን ብቻ ሽጥ — ቀጥተኛ ግብይት', 'ti': 'ዝወነንካ ንብረታት ጥራሕ ሽጥ — ቀጥታዊ ንግዲ', 'om': 'Qabeenya qabuuf qofa gurguuri — daldalama kallattii', 'so': 'Oo keliya iib hantida aad leedahay — ganacsiga toosinka', 'gur': 'የምናጣ ንብረቶቼን ብቻ ሽጥ — ቀጥተኛ ንግድ'});
  String get shariaCompliantAaoifi => _t({'en': 'Sharia Compliant (AAOIFI)', 'am': 'ሸሪዓ ተኳካሪ (AAOIFI)', 'ti': 'ሸሪዓ ኣሳማሚ (AAOIFI)', 'om': "Shari'aa waliin kan wal-simu (AAOIFI)", 'so': "Ku habboon Shariicada (AAOIFI)", 'gur': 'ሸሪዓ ተኳካሪ (AAOIFI)'});
  String get noInterestRibaFree => _t({'en': 'No Interest (Riba-Free)', 'am': 'ወለድ የለም (ሪባ-ነጻ)', 'ti': 'ወለድ የለን (ናጻ ካብ ሪባ)', 'om': 'Dhala hin qabu (Riba-Bilisa)', 'so': 'Ribada la\'aan (Xoroobay Riba)', 'gur': 'ወለድ የለም (ሪባ-ነጻ)'});
  String get standardsCertification => _t({'en': 'Standards & certification', 'am': 'መስፈርቶች እና ማረጋገጫ', 'ti': 'መምዘኒታት ምስክር', 'om': 'Madaallii fi mirkaneessaa', 'so': 'Heerarka iyo shahaadada', 'gur': 'መስፈርቶች እና ምስክር'});
  String get settingsPreferences => _t({'en': 'Settings & preferences', 'am': 'ቅንብሮች እና ምርጫዎች', 'ti': 'ቅጥዒ ምምዛዝ', 'om': "Qindaa'ina fi filannoo", 'so': 'Dejinta iyo doorashooyinka', 'gur': 'ቅንብሮች እና ምርጫዎች'});
  String get wealthProtectionPin => _t({'en': 'Wealth protection & PIN', 'am': 'የሀብት ጥበቃ እና PIN', 'ti': 'ሓለዋ ሃብቲ PIN', 'om': 'Eegumsa qabeenyaa PIN', 'so': 'Ilaalinta hantida PIN', 'gur': 'የሀብት ጥበቃ እና PIN'});
  String get faqSupport => _t({'en': 'FAQ & Support', 'am': 'ጥያቄዎች እና ድጋፍ', 'ti': 'ሕቶታት ሓጋዚ', 'om': 'Gaaffii fi deebii', 'so': 'Su\'aalaha iyo taageerada', 'gur': 'ጥያቄዎች እና ድጋፍ'});
  String get helpComingSoon => _t({'en': 'Help & FAQ — coming soon', 'am': 'እርዳታ እና ጥያቄዎች — በቅርቡ', 'ti': 'ሓጋዚ ሕቶ — ቀልጢፉ', 'om': 'Gargaarsa fi Gaaffii — dhufa', 'so': 'Caawimo iyo Su\'aalaha — soo socdaa', 'gur': 'እርዳታ እና ጥያቄዎች — ቅርቡ'});
  String get manageAlerts => _t({'en': 'Manage price & order alerts', 'am': 'ዋጋ እና ትዕዛዝ ማስጠንቀቂያ አስተዳድር', 'ti': 'ዋጋ ትዕዛዝ ምምሕዳር ሓደጋ ምልክቶ', 'om': 'Beeksisa gatii fi ajajaa bulchi', 'so': 'Maaree digniin qiimaha iyo amarka', 'gur': 'ዋጋ እና ትዕዛዝ ማስጠንቀቂያ አስተዳድር'});
  String get setPinToLock => _t({'en': 'Set a PIN to lock the app', 'am': 'ኣፕ ለመቆለፍ PIN ያዘጋጁ', 'ti': 'PIN ኣቐምጥ ኣፕ ኣዕጽዉ', 'om': 'PIN qindeessuu app cufuuf', 'so': 'Dejiso PIN si aad u xidigto app-ka', 'gur': 'ኣፕ ለዝጋ PIN ያዘጋጁ'});
  String get changePinTitle => _t({'en': 'Change / Remove PIN', 'am': 'PIN ቀይር / አስወግድ', 'ti': 'PIN ቀይር / ኣልዓሎ', 'om': 'PIN jijjiiri / haqii', 'so': 'Beddel / Ka saar PIN', 'gur': 'PIN ቀይር / አስወግድ'});
  String get setPinTitle => _t({'en': 'Set App Lock PIN', 'am': 'የኣፕ ቆልፍ PIN ያዘጋጁ', 'ti': 'PIN ሸፋዕ ኣፕ ቀናብር', 'om': 'PIN cufaa app qindeessuu', 'so': 'Dejiso PIN xididdiga app-ka', 'gur': 'የኣፕ ቆልፍ PIN ያዘጋጁ'});
  String get enterPinHint => _t({'en': 'Enter a 4-digit PIN to lock TradEt when backgrounded for 60+ seconds.', 'am': 'ኣፕ ለ60 ሰከንዶች ወደ ኋላ ሲሄድ ለመቆለፍ 4-ዲጂት PIN ያስገቡ።', 'ti': 'PIN 4 ቁጽሪ ኣቐምጥ ኣፕ TradEt ብ60 ካልኢት ምስ ኣዕረፈ ክዕጾ።', 'om': 'PIN lakkoofsota 4 galchi app TradEt daqiiqaa 60tti duubaatti yeroo deemu cufuuf.', 'so': 'Geli PIN 4 lambar si app TradEt looga xiddo 60 ilbiriqsi kadib.', 'gur': 'ኣፕ ለ60 ሰከ ወደ ኋላ ሲሄድ ለዝጋ 4-ዲጂት PIN ያስገቡ።'});
  String get completeKycRequired => _t({'en': 'Complete KYC to start trading. Required by NBE and ECX regulations.', 'am': 'ለመጀመር ንግድ KYC ያጠናቅቁ። በNBE እና ECX ደምብ ያስፈልጋል።', 'ti': 'KYC ዛዝሞ ንምጅማር ንግዲ። ብNBE ECX ሕጊ የድሊ።', 'om': 'KYC guutuu daldalamuuf. NBE fi ECX dambiidhaan barbaachisa.', 'so': 'KYC dhammaystir si aad u bilaabato ganacsiga. Waxaa u baahan xeerarka NBE iyo ECX.', 'gur': 'KYC ጨርስ ለጀምር ንግድ። NBE እና ECX ደምብ ያስፈጋል።'});
  String get colorGreen => _t({'en': 'Green', 'am': 'አረንጓዴ', 'ti': 'ቀጠልያ', 'om': 'Magariisa', 'so': 'Cagaar', 'gur': 'አረንጓዴ'});
  String get colorBlue => _t({'en': 'Blue', 'am': 'ሰማያዊ', 'ti': 'ሰማያዊ', 'om': 'Cuquliisa', 'so': 'Buluug', 'gur': 'ሰማያዊ'});
  String get colorPurple => _t({'en': 'Purple', 'am': 'ሐምራዊ', 'ti': 'ሐምራዊ', 'om': 'Diimaadduu', 'so': 'Guduud-madow', 'gur': 'ሐምራዊ'});
  String get colorAmber => _t({'en': 'Amber', 'am': 'ብርቱካናማ', 'ti': 'ኣምበር', 'om': 'Ambarii', 'so': 'Amber', 'gur': 'ብርቱካናማ'});
  String get colorTeal => _t({'en': 'Teal', 'am': 'ሰማያዊ-አረንጓዴ', 'ti': 'ቴይል', 'om': 'Teelii', 'so': 'Teel', 'gur': 'ሰማያዊ-አረንጓዴ'});
  String get colorRose => _t({'en': 'Rose', 'am': 'ሮዝ', 'ti': 'ቀዩ-ሮዝ', 'om': 'Roozii', 'so': 'Wareeg-cas', 'gur': 'ሮዝ'});
  String get authenticateToAddPayment => _t({'en': 'Authenticate to add a payment method', 'am': 'የክፍያ ዘዴ ለማከል ማረጋጋጥ', 'ti': 'ሓቀኛነትካ ምርግጋጽ ንምውሳኽ ኣገባብ ክፍሊት', 'om': 'Mala kaffaltii dabaluu mirkaneessuu', 'so': 'Xaqiijinta si aad u darto hab lacag bixin', 'gur': 'ክፍያ ዘዴ ለማክ ማረጋጋጥ'});
  String get failedToAdd => _t({'en': 'Failed to add', 'am': 'ማከል አልተቻለም', 'ti': 'ምውሳኽ ኣይሰለጠን', 'om': "Ida'uu hin milkoofne", 'so': 'Ku darka ma fashilmay', 'gur': 'ማክ አልቻልም'});
  String get refresh => _t({'en': 'Refresh', 'am': 'አድስ', 'ti': 'ኣሕድስ', 'om': 'Haaromsi', 'so': 'Cusboonaysii', 'gur': 'አድስ'});
  String get appVersionFooter => _t({'en': 'TradEt v1.0.0 by Amber — Sharia & Ethiopian Trade Compliant', 'am': 'ትሬድኢት v1.0.0 by አምበር — ሸሪዓ እና የኢትዮጵያ ንግድ ተኳካሪ', 'ti': 'TradEt v1.0.0 by Amber — ሸሪዓ ናይ ኢትዮጵያ ንግዲ', 'om': 'TradEt v1.0.0 by Amber — Shari\'aa fi Daldala Itoophiyaa', 'so': 'TradEt v1.0.0 by Amber — Shariicada iyo Ganacsiga Itoobiya', 'gur': 'TradEt v1.0.0 by Amber — ሸሪዓ እና ኢትዮጵያ ንግድ'});
  String get appVersionFooterShort => _t({'en': 'TradEt v1.0.0 — Sharia & Ethiopian Trade Compliant', 'am': 'TradEt v1.0.0 — ሸሪዓ እና የኢትዮጵያ ንግድ ተኳካሪ', 'ti': 'TradEt v1.0.0 — ሸሪዓ ናይ ኢትዮጵያ ንግዲ', 'om': "TradEt v1.0.0 — Shari'aa fi Daldala Itoophiyaa", 'so': 'TradEt v1.0.0 — Shariicada iyo Ganacsiga Itoobiya', 'gur': 'TradEt v1.0.0 — ሸሪዓ ኢትዮጵያ ንግድ'});

  // ─── Common navigation ────────────────────────────
  String get skip => _t({'en': 'Skip', 'am': 'ዝለል', 'ti': 'ሓልፍ', 'om': 'Dabrisi', 'so': 'Bood', 'gur': 'ዝለል'});
  String get back => _t({'en': 'Back', 'am': 'ተመለስ', 'ti': 'ተመለስ', 'om': "Deebi'i", 'so': 'Ku noqo', 'gur': 'ተመለስ'});
  String get nextArrow => _t({'en': 'Next →', 'am': 'ቀጣይ →', 'ti': 'ቀጺሉ →', 'om': 'Itti aanu →', 'so': 'Xigta →', 'gur': 'ቀጣይ →'});
  String get getStarted => _t({'en': 'Get Started', 'am': 'ጀምር', 'ti': 'ጀምር', 'om': 'Jalqabi', 'so': 'Bilow', 'gur': 'ጀምር'});
  // ─── Locale-aware brand names ─────────────────────
  String get appNameLocalized => _t({'en': 'TradEt', 'am': 'ትሬድኢት', 'ti': 'ትሬድኢት', 'om': 'TradEt', 'so': 'TradEt', 'gur': 'ትሬድኢት'});
  String get bankNameLocalized => _t({'en': 'Amber', 'am': 'አምበር', 'ti': 'አምበር', 'om': 'Amber', 'so': 'Amber', 'gur': 'አምበር'});
  String get byBankName => _t({'en': 'by Amber', 'am': 'በአምበር', 'ti': 'ብ አምበር', 'om': 'Amber dhaan', 'so': 'asal Amber', 'gur': 'በአምበር'});
  String get demoModeBanner => _t({'en': 'DEMO MODE — Data is simulated for presentation', 'am': 'ዴሞ ሁነታ — ዳታ ለዴሞ ተሰናብቷል', 'ti': 'ዴሞ ሁነታ — ዳታ ንዴሞ ቀሪቡ', 'om': 'DEEEMOO — Daataan demoaaf qophaahe', 'so': 'MUUQAAL — Xogtu waxay u diyaarsan tahay bandhigga', 'gur': 'ዴሞ ሁነታ — ዳታ ለዴሞ ቀሪቦ'});
  String get demoModeBannerFull => _t({'en': 'DEMO MODE — All data is simulated for presentation purposes', 'am': 'ዴሞ ሁነታ — ሁሉም ዳታ ለዴሞ ዓላማ ተሰናብቷል', 'ti': 'ዴሞ ሁነታ — ኩሉ ዳታ ንዴሞ ዓላማ ቀሪቡ', 'om': 'DEEEMOO — Daataan hundi kaayyoo demoaaf qophaahe', 'so': 'MUUQAAL — Xogta oo dhan waxay u diyaarsan tahay ujeeddooyinka bandhigga', 'gur': 'ዴሞ ሁነታ — ሁሉ ዳታ ለዴሞ ዓላማ ቀሪቦ'});
  String get exitDemoMode => _t({'en': 'Exit', 'am': 'ውጣ', 'ti': 'ውጻእ', 'om': 'Baqi', 'so': 'Ka bax', 'gur': 'ውጣ'});
  String get exitDemoModeArrow => _t({'en': 'Exit Demo →', 'am': 'ዴሞ ውጣ →', 'ti': 'ዴሞ ውጻእ →', 'om': 'Demo baqi →', 'so': 'Ka bax Muuqaalka →', 'gur': 'ዴሞ ውጣ →'});
  String get failedAttemptsBlock => _t({'en': '5 failed attempts → 15 min block', 'am': '5 ሙከራ ከወደቀ → 15 ደቂቃ ይዘጋል', 'ti': '5 ፈተናታት ምስ ወደቀ → 15 ደቓ ይዕጾ', 'om': 'Yaalii 5 kufee → daqiiqaa 15 cufama', 'so': '5 isku day oo fashilmay → 15 daqiiqo xidid', 'gur': '5 ሙከራ ወደቀ → 15 ደቂቃ ይዝጋ'});
  String byBrand(String brand) => _t({'en': 'by $brand', 'am': 'በ$brand', 'ti': 'ብ$brand', 'om': '$brand dhaan', 'so': 'asal $brand', 'gur': 'በ$brand'});

  // ─── Onboarding screen ────────────────────────────
  String get onboardingEcxTitle => _t({'en': 'Ethiopian Commodity\nExchange (ECX)', 'am': 'የኢትዮጵያ ምርት\nገበያ (ECX)', 'ti': 'ናይ ኢትዮጵያ ምርቲ\nዕዳጋ (ECX)', 'om': 'Gabatee Meeshaalee\nItoophiyaa (ECX)', 'so': 'Ganacsiga Badeecadaha\nItoobiya (ECX)', 'gur': 'የኢትዮጵያ ምርቶች\nዕዳጋ (ECX)'});
  String get onboardingEcxSubtitle => _t({'en': 'Trade real commodities on\nEthiopia\'s official exchange', 'am': 'በኢትዮጵያ ይፋዊ ምርት\nገበያ ላይ ይነግዱ', 'ti': 'ኣብ ወፍሪ ዕዳጋ ኢትዮጵያ\nብቀጥታ ንግዲ ግበር', 'om': "Meeshaalee dhugaa irratti\nGabatee iftoomina Itoophiyaatti gurguri", 'so': 'Ka ganacsado badeecadaha dhab ah\nsuuqa rasmiga ah ee Itoobiya', 'gur': 'ኢትዮጵያ ዕዳጋ ይፋዊ\nምርቶቼን ይሸጡ'});
  String get onboardingEcxBullet1 => _t({'en': 'Coffee, Sesame, Wheat, Gold', 'am': 'ቡና፣ ሰሊጥ፣ ስንዴ፣ ወርቅ', 'ti': 'ቡን፣ ሰሊጥ፣ ስርናይ፣ ወርቂ', 'om': 'Buna, Saliixii, Qamadii, Warqee', 'so': 'Bun, Simsim, Sarreen, Dahab', 'gur': 'ቡና፣ ሰሊጥ፣ ስንዴ፣ ወርቅ'});
  String get onboardingEcxBullet2 => _t({'en': 'ECX trading sessions: 9:00 AM – 3:00 PM EAT', 'am': 'ECX ሰዓቶች: 9:00 ጥዋት – 3:00 ከሰዓት EAT', 'ti': 'ሰዓት ECX: 9:00 ቅዲ ሰዓት – 3:00 ድሕሪ ቐትሪ EAT', 'om': 'Saatii ECX: 9:00 BO – 3:00 WB EAT', 'so': 'Wakhtiga ECX: 9:00 GH – 3:00 GD EAT', 'gur': 'ECX ሰዓቶች: 9:00 ጥዋት – 3:00 ከሰዓት EAT'});
  String get onboardingEcxBullet3 => _t({'en': 'Regulated by ECEA & National Bank of Ethiopia', 'am': 'በECEA እና ብሔራዊ ባንክ ቁጥጥር ስር', 'ti': 'ብ ECEA ብሔራዊ ባንክ ኢትዮጵያ ቁጽጽር', 'om': 'ECEA fi Baankii Biyyoolessaa Itoophiyaan to\'atama', 'so': 'ECEA iyo Baanka Qaranka Itoobiya waxay xukumaan', 'gur': 'ECEA እና ብሔራዊ ባንክ ቁጥጥር'});
  String get onboardingEcxBullet4 => _t({'en': 'Prices updated in real-time from ECX floor', 'am': 'ዋጋዎቹ ከECX ቀጥታ ይዘምናሉ', 'ti': 'ዋጋታት ካብ ECX ቅጽበታዊ ምሕዳስ', 'om': 'Gatiin ECX irraa yeroo hundumaa haaromfama', 'so': 'Qiimayaashu waxay si toos ah uga cusboonaadaan ECX', 'gur': 'ዋጋዎቹ ከECX ቀጥታ ይዘምናሉ'});
  String get onboardingShariaTitle => _t({'en': 'Sharia-Compliant\nTrading Platform', 'am': 'ሸሪዓ ተኳካሪ\nየንግድ መድረክ', 'ti': 'ሸሪዓ ኣሳማሚ\nናይ ንግዲ መደበር', 'om': "Shari'aa Waliin Wal-simu\nBaay'ina Daldala", 'so': 'Goob Ganacsiga\nKu Habboon Shariicada', 'gur': 'ሸሪዓ ተኳካሪ\nናይ ንግድ መድረክ'});
  String get onboardingShariaSubtitle => _t({'en': 'Every trade meets AAOIFI\nIslamic finance standards', 'am': 'እያንዳንዱ ንግድ AAOIFI\nየኢስላም ፋይናንስ ደረጃ', 'ti': 'ነፍሲ ወከፍ ንግዲ AAOIFI\nሕጊ ፋይናንስ ምስልምና', 'om': 'Daldalli hundi AAOIFI\nMadaallii faayinaansii Islaamaa guuta', 'so': 'Ganacsiga kasta wuxuu la kulmi\nQodobada maaliyadda Islaamka AAOIFI', 'gur': 'ሁሉም ንግድ AAOIFI\nየኢስላም ፋይናንስ ደረጃ'});
  String get onboardingShariaBullet1 => _t({'en': 'No Riba (interest) — flat 1.5% commission only', 'am': 'ወለድ የለም — 1.5% ኮሚሽን ብቻ', 'ti': 'ወለድ ዘሎ — 1.5% ኮሚሽን ጥራሕ', 'om': 'Dhala hin qabu — komishinii 1.5% qofa', 'so': 'Riba la\'aan — komishin 1.5% kaliya', 'gur': 'ወለድ የለም — 1.5% ኮሚሽን ብቻ'});
  String get onboardingShariaBullet2 => _t({'en': 'No Gharar (uncertainty) — transparent pricing', 'am': 'ዕርበት የለም — ግልጽ ዋጋ', 'ti': 'ዕርበት ዘሎ — ግሉጽ ዋጋ', 'om': 'Gharar hin qabu — gatii iftaahu', 'so': 'Gharar la\'aan — qiime cad', 'gur': 'ዕርበት የለም — ሃላዊ ዋጋ'});
  String get onboardingShariaBullet3 => _t({'en': 'Haram screening: debt <30%, haram revenue <5%', 'am': 'ሃራም ምርጫ: 借30%, ሃራም <5%', 'ti': 'ሃራም ምምርቓ: <30% 빈, ሃራም <5%', 'om': 'Saagi haram: liqii <30%, galii haram <5%', 'so': 'Shaandhaynta xaaraan: deyn <30%, dakhli xaaraan <5%', 'gur': 'ሃራም ምርጫ: 借30%, ሃራም <5%'});
  String get onboardingShariaBullet4 => _t({'en': 'AAOIFI Standard No. 21 compliance on all assets', 'am': 'AAOIFI ደረጃ ቁ. 21 ሁሉም ንብረቶች', 'ti': 'AAOIFI ደረጃ 21 ኩሎም ንብረታት', 'om': 'AAOIFI Heera Lakk. 21 qabeenyaa hunda irratti', 'so': 'AAOIFI Heer Lakabka 21 dhammaan hantida', 'gur': 'AAOIFI ደረጃ 21 ሁሉም ንብረቶች'});
  String get onboardingKycTitle => _t({'en': 'Identity Verification\nRequired', 'am': 'ማንነት ማረጋገጥ\nያስፈልጋል', 'ti': 'ምርግጋጽ ህልውና\nይሕለፍ', 'om': 'Mirkaneessaa Eenyummaa\nBarbaachisa', 'so': 'Xaqiijinta Aqoonsiga\nWaa Waajib', 'gur': 'ማንነት ማረጋገጥ\nያስፈጋል'});
  String get onboardingKycSubtitle => _t({'en': 'Required by Ethiopian law\nbefore you can start trading', 'am': 'ንግድ ከመጀመርዎ ፊት\nበኢትዮጵያ ሕግ ያስፈልጋል', 'ti': 'ቅድሚ ንምጅማር ንግዲ\nብሕጊ ኢትዮጵያ ይሕለፍ', 'om': 'Daldalamuuf dura\ndambii Itoophiyaatiin barbaachisa', 'so': 'Loo baahan yahay sharciga Itoobiya\nkahor aad bilaabato ganacsiga', 'gur': 'ንግድ ከጀምር ፊት\nየኢትዮጵያ ሕግ ያስፈጋል'});
  String get onboardingKycBullet1 => _t({'en': 'National ID, Passport, or Kebele ID accepted', 'am': 'ብሔራዊ መታወቂያ፣ ፓስፖርት፣ ወይም ቀበሌ ተቀባይነት ያለው', 'ti': 'ሃገራዊ መፍለጺ፣ ፓስፖርት፣ ቀበሌ ዲምዕ', 'om': 'Waraqaa eenyummaa biyyoolessaa, paaspoortiif, Qeebellee', 'so': 'Aqoonsiga qaranka, baasaboor, ama Kebele la aqbali', 'gur': 'ብሔራዊ መታወቂያ፣ ፓስፖርት ወይም ቀበሌ'});
  String get onboardingKycBullet2 => _t({'en': 'Verified in minutes — no branch visit needed', 'am': 'ደቂቃዎች ውስጥ ይረጋግጣል — ቅርንጫፍ መሄድ አያስፈልግም', 'ti': 'ብደቓይቃ ይረጋጋጽ — ቅርንጫፍ ምኻድ ኣየድሊን', 'om': 'Daqiiqaatiin mirkanaawa — damee dhaquu hin barbaachisu', 'so': 'Daqiiqado gudahood xaqiijin — xafiisku laguma baahna', 'gur': 'ደቂቃዎቹ ውስጥ ይረጋግጣል — ቅርንጫፍ አያስፈጋም'});
  String get onboardingKycBullet3 => _t({'en': 'Data encrypted & stored securely (AES-256)', 'am': 'ዳታ ተመስጥሮ ደህና ይቀመጣል (AES-256)', 'ti': 'ዳታ ምስጢር ኮይኑ ብDDA ይቃዘን (AES-256)', 'om': 'Daataan kan sirreeffame (AES-256)', 'so': 'Xogta waxa la qarsiyay oo si ammaan ah loo kaydiyay (AES-256)', 'gur': 'ዳታ ተመስጥሮ ደህና ይቀመጣል (AES-256)'});
  String get onboardingKycBullet4 => _t({'en': 'One-time verification — trade freely after', 'am': 'አንድ ጊዜ ማረጋገጫ — ከዚህ በኋላ ነጻ ይሸጡ', 'ti': 'ሓደ ጊዜ ምርግጋጽ — ድሕሪ ኡኡ ናጻ ንግዲ', 'om': 'Yeroo tokko mirkaneessuu — booda bilisaan gurguri', 'so': 'Mar keliya xaqiijin — ka dib si xor ah u ganacsado', 'gur': 'አንድ ጊዜ ማረጋገጫ — ከዚህ ነጻ ንግድ'});

  // ─── Register screen ──────────────────────────────
  String get minEightChars => _t({'en': 'Min 8 characters', 'am': 'ቢያንስ 8 ፊደሎች', 'ti': 'ዝወሓደ 8 ምልክታት', 'om': 'Xiqqa hamma 8', 'so': 'Ugu yaraan 8 xaraf', 'gur': 'ቢያንስ 8 ፊደሎች'});
  String get mustContainUppercase => _t({'en': 'Must contain an uppercase letter', 'am': 'ትልቅ ፊደል መኖር አለበት', 'ti': 'ዓቢ ፊደል ክህሉ ኣለዎ', 'om': 'Qubee guddaa qabaachuu qaba', 'so': 'Waa inuu ka kooban yahay xaraf weyn', 'gur': 'ዓቢ ፊደል ክህሉ ኣለዎ'});
  String get mustContainNumber => _t({'en': 'Must contain a number', 'am': 'ቁጥር መኖር አለበት', 'ti': 'ቁጽሪ ክህሉ ኣለዎ', 'om': 'Lakkoofsa qabaachuu qaba', 'so': 'Waa inuu ka kooban yahay nambar', 'gur': 'ቁጥር ክህሉ ኣለዎ'});
  String get mustContainSpecialChar => _t({'en': 'Must contain a special character', 'am': 'ልዩ ምልክት መኖር አለበት', 'ti': 'ፍሉይ ምልክት ክህሉ ኣለዎ', 'om': 'Mallattoo addaa qabaachuu qaba', 'so': 'Waa inuu ka kooban yahay xaraf gaar ah', 'gur': 'ፍሉይ ምልክት ክህሉ ኣለዎ'});
  String get acceptTermsRequired => _t({'en': 'Please accept the Terms of Service and Privacy Policy to continue.', 'am': 'ለቀጠሉ የአገልግሎት ውሎዎቹን እና የግላዊነት ፖሊሲውን ይቀበሉ።', 'ti': 'ንቀጺሉ ናይ ኣገልግሎት ውዕሊ ናይ ምስጢርነት ፖሊሲ ቀበሎ።', 'om': 'Itti fufuuf shartoota tajaajilaa fi polisii dhuunfaa eeyyami.', 'so': 'Si aad u sii wadato, aqbali Shuruucda Adeegga iyo Xeerka Arrimaha Gaarka ah.', 'gur': 'ቀጠሉ ለ የአገልግሎት ውሎዎቹን ምስጢርነት ፖሊሲ ይቀበሉ።'});
  String get joinToStartTrading => _t({'en': 'Join TradEt to start trading', 'am': 'ለመጀመር ንግድ TradEt ይቀላቀሉ', 'ti': 'TradEt ተሓባበሩ ንምጅማር ንግዲ', 'om': 'Daldalamuuf TradEt makalee', 'so': 'TradEt ku biir si aad u bilaabato ganacsiga', 'gur': 'ለጀምር ንግድ TradEt ይቀላቀሉ'});
  String get passwordStrengthLabel => _t({'en': 'Strength: ', 'am': 'ጥንካሬ: ', 'ti': 'ሓይሊ: ', 'om': 'Jabina: ', 'so': 'Xoogga: ', 'gur': 'ጥንካሬ: '});
  String get complianceSummary => _t({'en': 'AAOIFI Sharia compliant • ECX regulated\nNBE supervised • Riba-free fees', 'am': 'AAOIFI ሸሪዓ ተኳካሪ • ECX ቁጥጥር\nNBE ቁጥጥር • ወለድ-ነጻ ክፍያ', 'ti': 'AAOIFI ሸሪዓ ኣሳማሚ • ECX ቁጽጽር\nNBE ቁጽጽር • ወለድ-ናጻ ክፍሊት', 'om': "AAOIFI Shari'aa wajjiin • ECX to'atame\nNBE to'atame • kafaltii dhala-bilisaa", 'so': 'AAOIFI Shariicad ku haboon • ECX xukuma\nNBE kormeerka • kharashka ribada la\'aanta', 'gur': 'AAOIFI ሸሪዓ ተኳካሪ • ECX ቁጥጥር\nNBE ቁጥጥር • ወለድ-ነጻ ክፍያ'});
  String get iAgreeToThe => _t({'en': 'I agree to the ', 'am': 'ለ ', 'ti': 'ናብ ', 'om': 'Argattoota ', 'so': 'Waxaan aqbalayaa ', 'gur': 'ለ '});
  String get termsOfService => _t({'en': 'Terms of Service', 'am': 'የአገልግሎት ውሎዎች', 'ti': 'ናይ ኣገልግሎት ውዕሊ', 'om': 'Shartoota Tajaajilaa', 'so': 'Shuruucda Adeegga', 'gur': 'የአገልግሎት ውሎዎች'});
  String get andConjunction => _t({'en': ' and ', 'am': ' እና ', 'ti': ' ከምኡ ', 'om': ' fi ', 'so': ' iyo ', 'gur': ' እና '});
  String get privacyPolicy => _t({'en': 'Privacy Policy', 'am': 'የግላዊነት ፖሊሲ', 'ti': 'ፖሊሲ ምስጢርነት', 'om': 'Polisii Dhuunfaa', 'so': 'Xeerka Arrimaha Gaarka', 'gur': 'የምስጢርነት ፖሊሲ'});
  String get tosAgreementSuffix => _t({'en': '. My data will be processed in accordance with NBE data residency requirements and INSA CSMS guidelines.', 'am': '። ዳታዬ በNBE ዳታ ፍቃዶች እና INSA CSMS ሁኔታዎች መሰረት ይሰራጫል።', 'ti': '። ዳታይ ብNBE ፍቃዳት ዳታ INSA CSMS ሕጊ ይሰርሕ።', 'om': '. Daataan koo NBE fi INSA CSMS hordofuudhaan hojjetama.', 'so': '. Xogtaydu waxay u shaqayn doontaa shuruucda kaydinta xogta NBE iyo INSA CSMS.', 'gur': '። ዳታዬ NBE እና INSA CSMS ሕጊ ይሰርሐ።'});
  String get requiredField => _t({'en': 'Required', 'am': 'ያስፈልጋል', 'ti': 'ይሕለፍ', 'om': 'Barbaachisaa', 'so': 'Waajib', 'gur': 'ያስፈጋል'});

  // ─── App lock screen ──────────────────────────────
  String get enterPinToContinue => _t({'en': 'Enter your PIN to continue', 'am': 'ለቀጠሉ PIN ያስገቡ', 'ti': 'ንቀጺሉ PIN ኣእቱ', 'om': 'Itti fufuuf PIN galchi', 'so': 'Si aad u sii wadato PIN geli', 'gur': 'ለቀጠሉ PIN ያስገቡ'});
  String get incorrectPin => _t({'en': 'Incorrect PIN. Try again.', 'am': 'PIN ትክክል አይደለም። ደግሜ ሞክሩ።', 'ti': 'PIN ቅኑዕ ኣይኮነን። ደጊምካ ፈትን።', 'om': 'PIN hin sirre. Irra deebi\'i yaalidhu.', 'so': 'PIN khalad ah. Mar kale isku day.', 'gur': 'PIN ትክክል አይደለም። ደጊም ሞክሩ።'});
  String get useBiometric => _t({'en': 'Use Biometric', 'am': 'ባዮሜትሪክ ተጠቀም', 'ti': 'ባዮሜትሪክ ተጠቀም', 'om': 'Biometirikii fayyadami', 'so': 'Isticmaal Bayomeetrikada', 'gur': 'ባዮሜትሪክ ተጠቀም'});

  // ─── Portfolio screen ─────────────────────────────
  String get startTradingPortfolio => _t({'en': 'Start trading to build your portfolio', 'am': 'ፖርትፎሊዮ ለመሰብሰብ ንግድ ይጀምሩ', 'ti': 'ንምጅማር ፖርትፎሊዮ ንግዲ ጀምር', 'om': 'Portfoliokee ijaaruuf gurguruu jalqabi', 'so': 'Si aad portfolio-gaaga u dhisto ganacsiga bilow', 'gur': 'ፖርትፎሊዮ ለሰብሰብ ንግድ ይጀምሩ'});
  String authenticateToWithdraw(String amount) => _t({'en': 'Authenticate to withdraw $amount ETB', 'am': '$amount ETB ለማውጣት ያረጋግጡ', 'ti': '$amount ETB ንምስሓብ ኣረጋጉጽ', 'om': '$amount ETB baasuuf mirkaneessi', 'so': 'Xaqiiji si aad u saarto $amount ETB', 'gur': '$amount ETB ለሳብ ያረጋግጡ'});

  // ─── Alerts screen ────────────────────────────────
  String get createPriceAlertSubtitle => _t({'en': 'Get notified when price hits your target', 'am': 'ዋጋ ዒላማዎ ሲደርስ ያሳውቅዎታል', 'ti': 'ዋጋ ዕላማኻ ምስ ዘዕርፍ ይነግረካ', 'om': 'Gatiin galma kee gahe yoo ta\'u beeksifama', 'so': 'Ogaysiin marka qiimaha gaaro bartilmaameedkaaga', 'gur': 'ዋጋ ዒላማዎ ሲደርስ ያሳውቅዎታል'});
  String currentPriceDisplay(String price) => _t({'en': 'Current: $price ETB', 'am': 'አሁን: $price ETB', 'ti': 'ሕጂ: $price ETB', 'om': 'Yeroo kana: $price ETB', 'so': 'Hadda: $price ETB', 'gur': 'አሁን: $price ETB'});
  String get wentAbove => _t({'en': 'Went above', 'am': 'ከ... በላይ ሆነ', 'ti': 'ልዕሊ... ኾነ', 'om': 'Ol darbuu', 'so': 'Ka sarreeyay', 'gur': 'ከ... በላይ ሆነ'});
  String get droppedBelow => _t({'en': 'Dropped below', 'am': 'ከ... በታች ወደቀ', 'ti': 'ትሕቲ... ወደቀ', 'om': 'Gadi bu\'uu', 'so': 'Ka hoos u dhacay', 'gur': 'ከ... በታች ወደቀ'});
  String hitTargetSymbol(String symbol) => _t({'en': '$symbol hit target!', 'am': '$symbol ዒላማ ደርሷል!', 'ti': '$symbol ዕላማ ብጺሑ!', 'om': '$symbol galma gahe!', 'so': '$symbol bartilmaameedka gaartay!', 'gur': '$symbol ዒላማ ደርሷል!'});

  // ─── Orders screen ────────────────────────────────
  String get failedToCancelOrder => _t({'en': 'Failed to cancel order', 'am': 'ትዕዛዝ መሰረዝ አልተሳካም', 'ti': 'ትዕዛዝ ምሰዓር ኣይሰለጠን', 'om': 'Ajaja haaquu hin milkoofne', 'so': 'Fasaxa amarka wuu guul darraystay', 'gur': 'ትዕዛዝ ሰረዝ አልተሳካም'});
  String get orderCancelledSuccess => _t({'en': 'Order cancelled successfully', 'am': 'ትዕዛዝ ተሰርዟል', 'ti': 'ትዕዛዝ ተሰሪዙ', 'om': 'Ajajni haaqame', 'so': 'Amarka si guul leh ayaa la baajiyay', 'gur': 'ትዕዛዝ ተሰርዟ'});
  String ordersCountLabel(int n) => _t({'en': '$n orders', 'am': '$n ትዕዛዞች', 'ti': '$n ትዕዛዛት', 'om': 'Ajajoota $n', 'so': '$n amar', 'gur': '$n ትዕዛዞች'});
  String get orderExportTitle => _t({'en': 'Order History Statement', 'am': 'የትዕዛዝ ታሪክ ሪፖርት', 'ti': 'ናይ ትዕዛዝ ታሪክ ሪፖርት', 'om': 'Gabaasa Seenaa Ajaja', 'so': 'Warbixin Taariikhda Amarka', 'gur': 'የትዕዛዝ ታሪክ ሪፖርት'});
  String get exportDateHeader => _t({'en': 'Date', 'am': 'ቀን', 'ti': 'ዕለት', 'om': 'Guyyaa', 'so': 'Taariikhda', 'gur': 'ቀን'});
  String get exportTypeHeader => _t({'en': 'Type', 'am': 'አይነት', 'ti': 'ዓይነት', 'om': 'Gosa', 'so': 'Nooca', 'gur': 'ዓይነት'});
  String get exportQtyHeader => _t({'en': 'Qty', 'am': 'መጠን', 'ti': 'ብዝሒ', 'om': "Ba'aa", 'so': 'Tirada', 'gur': 'መጠን'});
  String get exportPriceEtbHeader => _t({'en': 'Price (ETB)', 'am': 'ዋጋ (ETB)', 'ti': 'ዋጋ (ETB)', 'om': 'Gatii (ETB)', 'so': 'Qiimaha (ETB)', 'gur': 'ዋጋ (ETB)'});
  String get exportTotalEtbHeader => _t({'en': 'Total (ETB)', 'am': 'ጠቅላላ (ETB)', 'ti': 'ጠቕላላ (ETB)', 'om': 'Waliigala (ETB)', 'so': 'Wadarta (ETB)', 'gur': 'ጠቅላላ (ETB)'});
  String get exportFeeEtbHeader => _t({'en': 'Fee (ETB)', 'am': 'ክፍያ (ETB)', 'ti': 'ክፍሊት (ETB)', 'om': 'Kafaltii (ETB)', 'so': 'Kharashka (ETB)', 'gur': 'ክፍያ (ETB)'});
  String get exportStatusHeader => _t({'en': 'Status', 'am': 'ሁኔታ', 'ti': 'ኩነታት', 'om': 'Haala', 'so': 'Xaalada', 'gur': 'ሁኔታ'});

  // ─── Zakat screen ─────────────────────────────────
  String zakatCalculationError(String e) => _t({'en': 'Failed to calculate: $e', 'am': 'ማስሊያ አልተሳካም: $e', 'ti': 'ምሕሳብ ኣይሰለጠን: $e', 'om': 'Herreega hin milkoofne: $e', 'so': 'Xisaabinta wey guul darrantay: $e', 'gur': 'ማስሊ አልተሳካም: $e'});
  String get zakatSubtitle => _t({'en': 'Calculate your annual Zakat', 'am': 'ዓመታዊ ዘካትዎን ያሰሉ', 'ti': 'ዓመታዊ ዘካትካ ስሊ', 'om': 'Zakaata waggaa kee hisi', 'so': 'Xisaabi Zakadaada sanadlaha ah', 'gur': 'ዓመታዊ ዘካትዎን ያሰሉ'});
  String get zakatInfoText => _t({'en': 'Your portfolio value and wallet balance are auto-calculated. Add other wealth below for a complete Zakat assessment.', 'am': 'የፖርትፎሊዮ ዋጋዎ እና ኪሳዎ ቀሪቤ ቀሪ ያለው ሁኔታ ቀለምጥ ። ሙሉ ዘካት ምዘናዎ ሌሎች ሀብቶችዎን ያስገቡ።', 'ti': 'ዋጋ ፖርትፎሊዮኻ ቀሪ ኪሳዃ ቀሪቤ ቀሪ ሕሳብ ።', 'om': 'Gatiin portfoliokaa fi daneensi waalleetii kun of-danda\'umaan hisaafama. Dukura guutuu zakaataa, qabeenya biraa gad dabali.', 'so': 'Qiimaha portfolio-gaaga iyo haraagga jeebkaaga si toos ah ayaa loo xisaabin. Ku dar hanti kale hoosta si aad u hesho qiimaynta buuxda ee Zakaadda.', 'gur': 'ፖርትፎሊዮ ዋጋዎ እና ኪሳዎ ቀሪቤ ቀሪ ። ሙሉ ዘካት ምዘናዎ ሌሎች ሀብቶቾን ያስገቡ።'});
  String get nisabGold => _t({'en': 'Gold (85g)', 'am': 'ወርቅ (85g)', 'ti': 'ወርቂ (85g)', 'om': 'Warqee (85g)', 'so': 'Dahab (85g)', 'gur': 'ወርቅ (85g)'});
  String get nisabSilver => _t({'en': 'Silver (595g)', 'am': 'ብር (595g)', 'ti': 'ብሩር (595g)', 'om': 'Meetii (595g)', 'so': 'Lacag (595g)', 'gur': 'ብር (595g)'});
  String get etbPerMonth => _t({'en': 'ETB/month', 'am': 'ETB/ወር', 'ti': 'ETB/ወርሒ', 'om': 'ETB/ji\'a', 'so': 'ETB/bil', 'gur': 'ETB/ወር'});
  String get zakatBreakdownPrefix => _t({'en': 'Zakat: ', 'am': 'ዘካት: ', 'ti': 'ዘካት: ', 'om': 'Zakaata: ', 'so': 'Zakad: ', 'gur': 'ዘካት: '});

  // ─── Transactions / Analytics ─────────────────────
  String etbReservedInOrders(String amount) => _t({'en': '$amount ETB reserved in open orders', 'am': '$amount ETB ክፍት ትዕዛዞች ውስጥ', 'ti': '$amount ETB ኣብ ክፉት ትዕዛዛት', 'om': '$amount ETB ajajota banaa keessatti', 'so': '$amount ETB waxay ku jirtaa amarrada furan', 'gur': '$amount ETB ክፍት ትዕዛዞቹ ውስጥ'});

  // ─── Trade screen ─────────────────────────────────
  String priceAlertFor(String symbol) => _t({'en': 'Price Alert — $symbol', 'am': 'የዋጋ ማስጠንቀቂያ — $symbol', 'ti': 'ናይ ዋጋ ሓደጋ ምልክት — $symbol', 'om': 'Beeksisa Gatii — $symbol', 'so': 'Digniinta Qiimaha — $symbol', 'gur': 'የዋጋ ማስጠንቀቂያ — $symbol'});
  String get targetPriceEtb => _t({'en': 'Target Price (ETB)', 'am': 'ዒላማ ዋጋ (ETB)', 'ti': 'ዋጋ ዕላማ (ETB)', 'om': 'Gatii galma (ETB)', 'so': 'Qiimaha bartilmaameedka (ETB)', 'gur': 'ዒላማ ዋጋ (ETB)'});
  String get identityVerificationRequired => _t({'en': 'Identity Verification Required', 'am': 'ማንነት ማረጋጋጥ ያስፈልጋል', 'ti': 'ምርግጋጽ ህልውና ይሕለፍ', 'om': 'Mirkaneessaa Eenyummaa Barbaachisa', 'so': 'Xaqiijinta Aqoonsiga Waajib Ah', 'gur': 'ማንነት ማረጋጋጥ ያስፈጋል'});
  String get kycRequiredDescription => _t({'en': 'Complete KYC verification to start trading. This is required by NBE regulations.', 'am': 'ንግድ ለመጀመር KYC ማረጋጋጥ ያስፈልጋል። ይህ በNBE ደንቦች ይጠየቃል።', 'ti': 'KYC ምርግጋጽ ክትዛዘም ምስ ፈለኻ ንምጅማር ንግዲ። ብ NBE ሕጊ ይሕለፍ።', 'om': 'Daldalamuuf KYC mirkaneessuu xumuramuu qaba. Kuni dandeettii NBE dhaan barbaachisa.', 'so': 'Buuxi xaqiijinta KYC si aad u bilaabato ganacsiga. Tan waxay u baahan tahay xeerarka NBE.', 'gur': 'ንግድ ለጀምር KYC ማረጋጋጥ ያስፈጋል። ይህ NBE ደንቦች ይጠይቃል።'});
  String get completeVerification => _t({'en': 'Complete Verification →', 'am': 'ማረጋጋጥ ጨርስ →', 'ti': 'ምርግጋጽ ዛዝም →', 'om': 'Mirkaneessuu xumuuri →', 'so': 'Xaqiijinta dhamee →', 'gur': 'ማረጋጋጥ ጨርስ →'});
  String get ecxSessionClosedFallback => _t({'en': 'ECX session closed. Trading is only permitted during official ECX sessions.', 'am': 'ECX ሴሽን ተዘግቷል። ንግድ የሚፈቀደው በESX ሴሽን ሰዓቶች ብቻ ነው።', 'ti': 'ECX ሴሽን ዓጽዩ። ንግዲ ጥራሕ ኣብ ሴሽን ECX ዝፍቀድ ።', 'om': 'Seeshiniin ECX cufame. Daldalli yeroo seeshinii ECX iftoomina qofa hayyamama.', 'so': 'Session-ka ECX waá la xidhay. Ganacsiga waxaa kaliya la oggolaaday xaaladaha session-ka rasmi ah ee ECX.', 'gur': 'ECX ሴሽን ተዘጋ። ንግድ ECX ሴሽን ሰዓቶቸ ብቻ ፈቀዱ።'});
  String get kycBeforeTrading => _t({'en': 'Identity verification (KYC) required before trading.', 'am': 'ንግድ ከመጀመርዎ ፊት ማንነት ማረጋጋጥ (KYC) ያስፈልጋል።', 'ti': 'ቅድሚ ንግዲ ምርግጋጽ ህልውና (KYC) ይሕለፍ።', 'om': 'Daldalamuuf dura mirkaneessaa eenyummaa (KYC) barbaachisa.', 'so': 'Xaqiijinta aqoonsiga (KYC) waa in la sameeyo kahor ganacsiga.', 'gur': 'ንግድ ከጀምር ፊት ማንነት ማረጋጋጥ (KYC) ያስፈጋል።'});
  String get pricePerUnitEtb => _t({'en': 'Price per unit (ETB)', 'am': 'ዋጋ በክፍል (ETB)', 'ti': 'ዋጋ ብ ክፍሊ (ETB)', 'om': 'Gatii tokkootti (ETB)', 'so': 'Qiimaha midkiiba (ETB)', 'gur': 'ዋጋ ለአንድ ክፍሊ (ETB)'});
  String get marketPriceLabel => _t({'en': 'Market price', 'am': 'ዋጋ ገበያ', 'ti': 'ዋጋ ዕዳጋ', 'om': 'Gatii gabaa', 'so': 'Qiimaha suuqa', 'gur': 'ዋጋ ገቢያ'});
  String get filledAtMarketPrice => _t({'en': 'Filled at best available market price', 'am': 'በተሻለው ዋጋ ገበያ ይሞላ', 'ti': 'ብዝሓሸ ዋጋ ዕዳጋ ይምላእ', 'om': 'Gatii gabaa gaarii argameetti guutama', 'so': 'Waxaa ku buuxsamay qiimaha ugu wanaagsan ee suuqa', 'gur': 'በሚሻለው ዋጋ ገቢያ ይሞላ'});
  String cashAvailableLabel(String value) => _t({'en': 'Cash: $value ETB', 'am': 'ጥሬ ገንዘብ: $value ETB', 'ti': 'ጥረ ገንዘብ: $value ETB', 'om': 'Maallaqa: $value ETB', 'so': 'Lacag: $value ETB', 'gur': 'ጥሬ ገንዘብ: $value ETB'});
  String holdingsQtyLabel(String qty) => _t({'en': 'Holdings: $qty', 'am': 'ይዞታ: $qty', 'ti': 'ዘለካ: $qty', 'om': 'Qabeenya: $qty', 'so': 'Hanti: $qty', 'gur': 'ይዞታ: $qty'});
  String get subtotal => _t({'en': 'Subtotal', 'am': 'ከፊል ጠቅላላ', 'ti': 'ከፊል ጠቕላላ', 'om': 'Gatii walakkaa', 'so': 'Wadarta qayb', 'gur': 'ከፊል ጠቅላላ'});
  String get feeFlat => _t({'en': 'Fee (1.5% flat)', 'am': 'ክፍያ (1.5% ቋሚ)', 'ti': 'ክፍሊት (1.5% ቋሚ)', 'om': 'Kafaltii (1.5% duraatti)', 'so': 'Kharash (1.5% xasil)', 'gur': 'ክፍያ (1.5% ቋሚ)'});
  String get feeShort => _t({'en': 'Fee (1.5%)', 'am': 'ክፍያ (1.5%)', 'ti': 'ክፍሊት (1.5%)', 'om': 'Kafaltii (1.5%)', 'so': 'Kharash (1.5%)', 'gur': 'ክፍያ (1.5%)'});
  String get ribaFreeLabel => _t({'en': 'No interest (Riba-free) — flat commission', 'am': 'ወለድ የለም (ሪባ-ነጻ) — ቋሚ ኮሚሽን', 'ti': 'ወለድ ዘሎ (ሪባ-ናጻ) — ቋሚ ኮሚሽን', 'om': 'Dhala hin qabu (Riba-bilisaa) — komishinii duraatti', 'so': 'Riba La\'aan — komishin xasil', 'gur': 'ወለድ የለም (ሪባ-ነጻ) — ቋሚ ኮሚሽን'});
  String get ribaFreeShort => _t({'en': 'Riba-free flat commission', 'am': 'ሪባ-ነጻ ቋሚ ኮሚሽን', 'ti': 'ሪባ-ናጻ ቋሚ ኮሚሽን', 'om': 'Komishinii riba-bilisaa duraatti', 'so': 'Komishin Riba-free xasil', 'gur': 'ሪባ-ነጻ ቋሚ ኮሚሽን'});
  String get high => _t({'en': 'High', 'am': 'ከፍተኛ', 'ti': 'ላዕለዋይ', 'om': 'Ol', 'so': 'Sarreeye', 'gur': 'ከፍተኛ'});
  String get low => _t({'en': 'Low', 'am': 'ዝቅተኛ', 'ti': 'ታሕታዋይ', 'om': 'Gadi', 'so': 'Hooseeye', 'gur': 'ዝቅተኛ'});
  String authenticateToBuy(String symbol) => _t({'en': 'Authenticate to buy $symbol', 'am': '$symbol ለመግዛት ያረጋግጡ', 'ti': '$symbol ንምዕዳጉ ኣረጋጉጽ', 'om': '$symbol bitachuuf mirkaneessi', 'so': 'Xaqiiji si aad u iibsato $symbol', 'gur': '$symbol ለጉዛ ያረጋግጡ'});
  String authenticateToSell(String symbol) => _t({'en': 'Authenticate to sell $symbol', 'am': '$symbol ለመሸጥ ያረጋግጡ', 'ti': '$symbol ንምሻጡ ኣረጋጉጽ', 'om': '$symbol gurguruuf mirkaneessi', 'so': 'Xaqiiji si aad u iibiso $symbol', 'gur': '$symbol ለሽጥ ያረጋግጡ'});

  // ─── ShariaBadge ──────────────────────────────────
  String get shariaCompliantBadge => _t({'en': 'Sharia Compliant', 'am': 'ሸሪዓ ተኳካሪ', 'ti': 'ሸሪዓ ኣሳማሚ', 'om': "Shari'aa waliin wal-simu", 'so': 'Ku habboon Shariicada', 'gur': 'ሸሪዓ ተኳካሪ'});
  String get permissible => _t({'en': 'Permissible', 'am': 'ፍቃድ ያለው', 'ti': 'ፍቓድ ዘሎ', 'om': 'Hayyamamaa', 'so': 'La oggolaaday', 'gur': 'ፍቃድ ያለው'});
  String get nonHalal => _t({'en': 'Non-Halal', 'am': 'ሐላል ያልሆነ', 'ti': 'ሐላል ዘይኮነ', 'om': 'Halaal Miti', 'so': 'Aan Xalaal Ahayn', 'gur': 'ሐላል ያልሆነ'});
  String get nonCompliant => _t({'en': 'Non-Compliant', 'am': 'ተኳካሪ ያልሆነ', 'ti': 'ኣሳማሚ ዘይኮነ', 'om': 'Wal-hin simin', 'so': 'Aan Ku Habboonayn', 'gur': 'ተኳካሪ ያልሆነ'});

  // ─── Disclaimer footer ────────────────────────────
  String get disclaimerText => _t({'en': 'Disclaimer: TradEt is a Sharia-compliant trading platform for Ethiopian commodities. All information provided is for informational purposes only and does not constitute financial, investment, or legal advice. Past performance is not indicative of future results. Trading involves risk — please consult a qualified financial advisor before making investment decisions.', 'am': 'ማሳሰቢያ: TradEt ሸሪዓ ተኳካሪ የኢትዮጵያ ምርቶች የንግድ ማዕከል ነው። ሁሉም መረጃዎች ለጠቅላላ ዕውቀት ብቻ ሲሆኑ ፋይናንሺያል፣ ኢንቨስትመንት ወይም ህጋዊ ምክርን አይወክሉም። ያለፈ አፈጻጸም ለወደፊቱ ዋስትና አይሰጥም። ንግድ አደጋ ይዟል — ኢንቨስት ከማድረግ ፊት ብቁ ፋይናንሺያል አማካሪ ያማክሩ።', 'ti': 'ማሳሰቢያ: TradEt ሸሪዓ-ኣሳማሚ ናይ ምርቲ ኢትዮጵያ ናይ ንግዲ መደበር ። ኩሉ ሓቢሬታ ንሓፈሻዊ ሓብሬታ ጥራሕ ። ናይ ዝሓለፈ ናይ ንግዲ ዉጥን ዛዕባ ናይ ዘይምምሳሉ ርጋጸ ።', 'om': 'Beeksisa: TradEt Shari\'aa-waliin wal-simu kan meeshaalee Itoophiyaatiif tajaajilu. Odeeffannoon dhiyaate marti-tajaajilaa qofa. Hojmaatni darbe bu\'aa gara fuulduraa hin mirkaneessu. Daldalli sodaachisa — dura murtii invastimantii murteessuu ogeessa fayinaansii gaafadhu.', 'so': 'Ogolaanshaha: TradEt waa goobjoog ganacsiga badeecadaha Itoobiya ee ku habboon Shariicada. Dhammaan macluumaadka waxa lagu bixiyay ujeeddooyinka macluumaadka kaliya mana matalayso talo maaliyadeed, maalgelin, ama sharci. Waxqabadkii hore k엄ma muujinayso natiijooyinka mustaqbalka. Ganacsiga wuxuu keenaa khatarta — fadlan la tasho khubir maaliyad ah kahor go\'aan maalgelin ah.', 'gur': 'ማሳሰቢያ: TradEt ሸሪዓ ተኳካሪ ናይ ኢትዮጵያ ምርቶቼ ናይ ንግድ ማዕከል ።ሁሉ ሓቢሬታ ለጠቅላላ ዕወቀት ። ያለፈ ሥራ ዋስትና አይሰጥም። ንግድ አደጋ ። ፋይናንሺያ አማካሪ ያማክሩ።'});

  // ─── Export sheet ─────────────────────────────────
  String exportTitle(String title) => _t({'en': 'Export $title', 'am': '$title ወደ ውጭ ላክ', 'ti': '$title ናብ ወጻኢ ሰደድ', 'om': '$title ergi', 'so': 'Dhoofso $title', 'gur': '$title ወደ ወጭ ላክ'});
  String get pdfDocument => _t({'en': 'PDF Document', 'am': 'PDF ሰነድ', 'ti': 'ሰነድ PDF', 'om': 'Waraqaa PDF', 'so': 'Dukumiintiga PDF', 'gur': 'PDF ሰነድ'});
  String get pdfDocumentSubtitle => _t({'en': 'Formal statement, ready to print or share', 'am': 'ሰነድ ለህትመት ወይም ማካፈያ', 'ti': 'ሰነድ ንፕሪንት ወይ ምካፋፍ', 'om': 'Ibsa murtee, maxxansuuf ykn qoodachuuf', 'so': 'Qormo rasmiyeed, diyaar u ah daabacaadda ama wadaagidda', 'gur': 'ሰነድ ለህትመት ወይም ማካፈያ'});
  String get excelSpreadsheet => _t({'en': 'Excel Spreadsheet (.xlsx)', 'am': 'Excel ሥርዓተ ሰነድ (.xlsx)', 'ti': 'Excel ሥርዓተ ሰነድ (.xlsx)', 'om': 'Gabatee Excel (.xlsx)', 'so': 'Xaashida Excel (.xlsx)', 'gur': 'Excel ሥርዓተ ሰነድ (.xlsx)'});
  String get excelSubtitle => _t({'en': 'Open directly in Microsoft Excel', 'am': 'ቀጥታ Microsoft Excel ውስጥ ይከፈታል', 'ti': 'ቐጥታ Microsoft Excel ክፈቱ', 'om': 'Microsoft Excel keessatti kallattiin bani', 'so': 'Toos ugu fur Microsoft Excel', 'gur': 'ቀጥታ Microsoft Excel ይከፈታ'});
  String get csvFile => _t({'en': 'CSV File', 'am': 'CSV ፋይል', 'ti': 'ፋይል CSV', 'om': 'Faayilii CSV', 'so': 'Faylka CSV', 'gur': 'CSV ፋይል'});
  String get csvSubtitle => _t({'en': 'Plain text, compatible with any spreadsheet', 'am': 'ቀላል ጽሑፍ ከሁሉም ሥርዓተ ሰነዶች ጋር ይሰራል', 'ti': 'ቀሊል ጽሑፍ ምስ ኩሎም ሥርዓተ ሰነዳት ይሰርሕ', 'om': 'Barruu salphaa, gabatee kamuu waliin walsimuu', 'so': 'Qoraal fudud, ku habboon xaashidda kasta', 'gur': 'ቀሊ ጽሑፍ ሁሉ ሥርዓተ ሰነዶቸ ይሰራ'});
  String get exportComplianceFooter => _t({'en': 'Sharia Board Compliance Certified — AAOIFI Standards Applied  |  ECX & NBE Compliant  |  No Riba (interest) instruments  |  INSA CSMS Guideline v1.0', 'am': 'ሸሪዓ ሸምጋዮች ፈቃድ — AAOIFI ደረጃዎች ተፈጽሟል | ECX & NBE ቁጥጥር | ወለድ ሳይኖር (ሪባ) | INSA CSMS ዕቅድ v1.0', 'ti': 'ሸሪዓ ፈቃድ — AAOIFI ደረጃታት ተፈጺሙ | ECX & NBE ቁጽጽር | ወለድ ዘሎ (ሪባ) | INSA CSMS ዕቅዲ v1.0', 'om': 'Boordiin Shari\'aa Seeraa mirkaneeffame — Sadarkaalee AAOIFI raawwatame | ECX & NBE wal-simu | Maallaqa dhala(riba) hin qabne | INSA CSMS Qajeelfama v1.0', 'so': 'Xafidda Shariicada Ansax siisay — Heerarka AAOIFI la dabaqay | ECX & NBE waafaqsan | Aaladda Riba (dulsaar) la\'aan | Hogaanshaha INSA CSMS v1.0', 'gur': 'ሸሪዓ ፈቃድ — AAOIFI ደረጃዎቸ ተፈጽሟ | ECX & NBE ቁጥጥር | ወለድ ሳይኖር (ሪባ) | INSA CSMS ዕቅድ v1.0'});

  // ─── Dashboard widgets ────────────────────────────
  String get noMarketDataAvailable => _t({'en': 'No market data available', 'am': 'የገበያ ዳታ የለም', 'ti': 'ናይ ዕዳጋ ዳታ ዘሎ', 'om': 'Deetaa gabaa hin jiru', 'so': 'Macluumaad suuq ma jiro', 'gur': 'የገቢያ ዳታ የለም'});
  String get noLosersToday => _t({'en': 'No losers today', 'am': 'ዛሬ ዝቅ ያሉ ዋጋዎች የሉም', 'ti': 'ሎሚ ዝቅ ዝበሉ ዋጋታት ዘሎ', 'om': 'Har\'a kan kufan hin jiran', 'so': 'Maanta ma jiraan kuwa barakici ku gaaray', 'gur': 'ዛሬ ዝቅ ያሉ ዋጋዎቸ የሉም'});
  String get ribaFreeWithdrawal => _t({'en': 'Riba-free withdrawal to your saved bank account', 'am': 'ወለድ-ነጻ ገንዘብ ወጪ ወደ ባንክ ሒሳብዎ', 'ti': 'ወለድ-ናጻ ሒሳብ ናብ ባንክ ሒሳቡ', 'om': 'Baasuun dhala-bilisaa gara herrega baankiikee', 'so': 'Bixitaan Riba-free loo gayn doonaa xisaabta bangigaaga', 'gur': 'ወለድ-ነጻ ወጪ ወደ ባንክ ሒሳብዎ'});
  String get selectPaymentMethod => _t({'en': 'Select payment method:', 'am': 'የክፍያ ዘዴ ምረጡ:', 'ti': 'ኣገባብ ክፍሊት ምረጽ:', 'om': 'Mala kaffaltii filadhu:', 'so': 'Hab lacag-bixin dooro:', 'gur': 'ክፍያ ዘዴ ምረጡ:'});

  // ─── Register screen (password strength) ─────────
  String get passwordWeak => _t({'en': 'Weak', 'am': 'ደካማ', 'ti': 'ሰጣሕ', 'om': 'Laafaa', 'so': 'Daciif', 'gur': 'ደካማ'});
  String get passwordFair => _t({'en': 'Fair', 'am': 'መካከለኛ', 'ti': 'ማእከላይ', 'om': 'Giddugaleessa', 'so': 'Dhexdhexaad', 'gur': 'መካከለኛ'});
  String get passwordGood => _t({'en': 'Good', 'am': 'ጥሩ', 'ti': 'ጽቡቕ', 'om': 'Gaarii', 'so': 'Wanaagsan', 'gur': 'ጥሩ'});
  String get passwordStrong => _t({'en': 'Strong', 'am': 'ጠንካራ', 'ti': 'ሓያል', 'om': 'Jabaa', 'so': 'Xoog leh', 'gur': 'ጠንካራ'});

  // ─── Converter screen ─────────────────────────────
  String get currencyConverter => _t({'en': 'Currency Converter', 'am': 'ምንዛሬ መቀያያሪያ', 'ti': 'ቀያያሪ ምንዛሬ', 'om': 'Jijjiirtuu maallaqaa', 'so': 'Baddalaha lacagta', 'gur': 'ምንዛሬ ቀያያሪ'});
  String get nbeExchangeRates => _t({'en': 'NBE Exchange Rates', 'am': 'NBE የምንዛሬ ዋጋ', 'ti': 'ናይ NBE ምጣነ ምንዛሬ', 'om': 'Gatii jijjiirraa NBE', 'so': 'Sicirka sarrifka NBE', 'gur': 'NBE የምንዛሬ ዋጋ'});
  String get enterAmount => _t({'en': 'Enter amount', 'am': 'መጠን ያስገቡ', 'ti': 'ዓቐን ኣእቱ', 'om': "Baay'ina galchi", 'so': 'Geli xadiga', 'gur': 'መጠን ያስገቡ'});
  String get noRatesAvailable => _t({'en': 'No rates available', 'am': 'ምንም ዋጋ የለም', 'ti': 'ዋጋ ዘይብሉ', 'om': 'Gatiin hin jiru', 'so': 'Qiyaas la heli maayo', 'gur': 'ምንም ዋጋ የለም'});
  String get currency => _t({'en': 'Currency', 'am': 'ምንዛሬ', 'ti': 'ምንዛሬ', 'om': 'Maallaqaa', 'so': 'Lacagta', 'gur': 'ምንዛሬ'});
  String get ratesSourcedFromNBE => _t({'en': 'Rates sourced from National Bank of Ethiopia', 'am': 'ዋጋዎቹ ከኢትዮጵያ ብሔራዊ ባንክ', 'ti': 'ዋጋታት ካብ ናሽናል ባንክ ኢትዮጵያ', 'om': 'Gatiin Baankii Biyyoolessaa Itoophiyaa irraa', 'so': 'Qiyaasaha ka yimid Baanka Qaran ee Itoobiya', 'gur': 'ዋጋዎቹ ከኢትዮጵያ ብሔራዊ ባንክ'});

  // ─── Charts ──────────────────────────────────────────
  String get priceChart => _t({'en': 'Price Chart', 'am': 'የዋጋ ቻርት', 'ti': 'ናይ ዋጋ ቻርት', 'om': 'Chaartii Gatii', 'so': 'Jaantuska Qiimaha', 'gur': 'የዋጋ ቻርት'});
  String get noChartData => _t({'en': 'No chart data', 'am': 'ምንም ቻርት ዳታ የለም', 'ti': 'ዳታ ቻርት ዘሎ', 'om': 'Deetaa chaartii hin jiru', 'so': 'Xog jaantuska ma jirto', 'gur': 'ምንም ቻርት ዳታ የለም'});
  String get noChartDataAvailable => _t({'en': 'No chart data available', 'am': 'ቻርት ዳታ አይገኝም', 'ti': 'ዳታ ቻርት ዘሎ', 'om': 'Deetaa chaartii hin argamne', 'so': 'Xog jaantuska la heli maayo', 'gur': 'ቻርት ዳታ አይገኝም'});

  // ─── Payment methods / Profile (new unique keys) ─────
  String get addPaymentMethod => _t({'en': 'Add Payment Method', 'am': 'የክፍያ ዘዴ ጨምር', 'ti': 'ኣገባብ ክፍሊት ወስኽ', 'om': 'Mala kaffaltii dabali', 'so': 'Ku dar hab lacag-bixin', 'gur': 'የክፍያ ዘዴ ጨምር'});
  String get removeAccount => _t({'en': 'Remove Account', 'am': 'ሒሳብ አስወግድ', 'ti': 'ሒሳብ ኣልዕሎ', 'om': 'Herrega haqi', 'so': 'Ka saar xisaabta', 'gur': 'ሒሳብ አስወግድ'});
  String get close => _t({'en': 'Close', 'am': 'ዝጋ', 'ti': 'ዕጸዎ', 'om': 'Cufii', 'so': 'Xidh', 'gur': 'ዝጋ'});
  String get commissionLimits => _t({'en': 'Commission & trading limits', 'am': 'ኮሚሽን እና የንግድ ወሰን', 'ti': 'ኮሚሽን ወ ገደብ ንግዲ', 'om': 'Komiishinii fi daangaa daldala', 'so': 'Guddoomiyaha & Xaddadka ganacsiga', 'gur': 'ኮሚሽን እና የንግድ ወሰን'});
  String get profileUpdated => _t({'en': 'Profile updated successfully', 'am': 'ፕሮፋይሉ ተሻሽሏል', 'ti': 'ፕሮፋይል ብዓወት ሕዲሱ', 'om': 'Piroofaayiliin milkiinan haaromfame', 'so': 'Boggu si guul leh ayaa loo cusboonaysiiyay', 'gur': 'ፕሮፋይሉ ተሻሽሏል'});
  String get aboutTradEt => _t({'en': 'About TradEt', 'am': 'ስለ ትሬድኢት', 'ti': 'ብዛዕባ ትሬድኢት', 'om': "Waa'ee TradEt", 'so': 'Ku saabsan TradEt', 'gur': 'ስለ ትሬድኢት'});
  String get shariaCompliantPlatform => _t({'en': 'Sharia-compliant Ethiopian commodity trading platform.', 'am': 'ሸሪዓ ተገዢ ኢትዮጵያ የሸቀጥ ንግድ መድረክ።', 'ti': 'ሸሪዓ ዝኽተል ናይ ኢትዮጵያ ሸቐጥ ናይ ንግዲ መድረኽ።', 'om': "Shari'aa hordofu gabaa meeshaalee Itoophiyaa.", 'so': 'Goobo ganacsiga alaabta Itoobiya ee ku habboon Shariicada.', 'gur': 'ሸሪዓ ተስማሚ ኢትዮጵያ ሸቀጥ ንግድ መሣርያ።'});

  // ─── Security screen ──────────────────────────────────
  String get withBiometrics => _t({'en': 'With biometrics', 'am': 'ባዮሜትሪክ', 'ti': 'ብባዮሜትሪክ', 'om': 'Bayoomeetriksiin', 'so': 'Bayometriga', 'gur': 'ባዮሜትሪክ'});
  String get biometricsUnavailable => _t({'en': 'Biometrics (unavailable)', 'am': 'ባዮሜትሪክ (አይገኝም)', 'ti': 'ባዮሜትሪክ (ዘይርከብ)', 'om': 'Bayoomeetriksii (hin argamne)', 'so': 'Bayometrika (ma heli karo)', 'gur': 'ባዮሜትሪክ (አይገኝም)'});
  String get withPin => _t({'en': 'With PIN', 'am': 'PIN ጋር', 'ti': 'ብPIN', 'om': 'PINiin', 'so': 'PIN la', 'gur': 'PIN ጋር'});
  String get authMethod => _t({'en': 'Authentication Method', 'am': 'የማረጋጊጥ ዘዴ', 'ti': 'ኣገባብ ምርግጋጽ', 'om': 'Mala mirkaneessuu', 'so': 'Habka xaqiijinta', 'gur': 'የማረጋጊጥ ዘዴ'});
  String get howToVerifyIdentity => _t({'en': 'How to verify your identity', 'am': 'ማንነትዎን እንዴት ማረጋጊጥ', 'ti': 'ህልውናኻ ብኸምዚ ኣረጋግጽ', 'om': 'Eenyummaa kee akkam mirkanaa\'uu', 'so': 'Sida aad aqoonsigaaga xaqiijiso', 'gur': 'ማንነቱን እንዴት ማረጋጊጥ'});
  String get biometrics => _t({'en': 'Biometrics', 'am': 'ባዮሜትሪክ', 'ti': 'ባዮሜትሪክ', 'om': 'Bayoomeetriksii', 'so': 'Bayometrikska', 'gur': 'ባዮሜትሪክ'});
  String get sessionProtection => _t({'en': 'Session Protection', 'am': 'ሴሽን ጥበቃ', 'ti': 'ሴሽን ሓለዋ', 'om': 'Eegumsa seeshinii', 'so': 'Ilaalinta session-ka', 'gur': 'ሴሽን ጥበቃ'});
  String get configWithinInsa => _t({'en': 'Configurable within INSA CSMS bounds', 'am': 'በINSA CSMS ድንበር ውስጥ ሊስተካከል ይችላል', 'ti': 'ኣብ ውሽጢ ዶብ INSA CSMS ክቅየር ይካኣል', 'om': 'Daangaa INSA CSMS keessatti qindaa\'uu danda\'ama', 'so': 'Xaddadka INSA CSMS gudaha laga dejin karaa', 'gur': 'INSA CSMS ዶብ ውስጥ ሊስተካከል ይቻላ'});
  String get accountLockout => _t({'en': 'Account Lockout', 'am': 'የሒሳብ መቆለፊያ', 'ti': 'ዕጸፋ ሒሳብ', 'om': 'Cufaa herregaa', 'so': 'Xidida akoonka', 'gur': 'የሒሳብ መቆለፊያ'});
  String get insaMandated => _t({'en': 'INSA Mandated', 'am': 'INSA ተደንጋጋ', 'ti': 'INSA ዝእዘዘ', 'om': 'INSA dirqisiise', 'so': 'INSA waajib sameysey', 'gur': 'INSA ተደንጋጋ'});
  String get biometricEnrollPrompt => _t({'en': 'Go to Settings → Security to enroll your biometrics.', 'am': 'ባዮሜትሪክ ለመመዝገብ ቅንጅቶች → ደህንነት ይሂዱ።', 'ti': 'ናብ ቅጥዒ → ድሕንነት ዕደም ባዮሜትሪካዊ ቑሶ።', 'om': 'Baayoomeetrikii galchuuf Qindaa\'ina → Nageenyaa deemi.', 'so': 'Aad u xidha Dejinta → Amniga si aad ugu diwaan-geliso bayometrigaaga.', 'gur': 'ቅንጅቶቸ → ደህንነት ሂድ ባዮሜትሪክ ለምዝገብ።'});
  String get biometricSuccess => _t({'en': 'Biometric authentication successful!', 'am': 'ባዮሜትሪክ ማረጋጊጥ ተሳክቷል!', 'ti': 'ምርግጋጽ ባዮሜትሪክ ተዓዊቱ!', 'om': 'Mirkaneessaan bayoomeetriksii milkaawe!', 'so': 'Xaqiijinta bayometrika way guulatay!', 'gur': 'ባዮሜትሪክ ማረጋጊጥ ተሳክቷ!'});
  String get biometricFailed => _t({'en': 'Biometric authentication failed.', 'am': 'ባዮሜትሪክ ማረጋጊጥ አልተሳካም።', 'ti': 'ምርግጋጽ ባዮሜትሪክ ኣይሰለጠን።', 'om': 'Mirkaneessaan bayoomeetriksii hin milkoofne.', 'so': 'Xaqiijinta bayometrika way fashilantay.', 'gur': 'ባዮሜትሪክ ማረጋጊጥ አልተሳካም።'});
  String get newPinHint => _t({'en': 'New PIN (4 digits)', 'am': 'አዲስ PIN (4 ቁጥሮች)', 'ti': 'ሓዲሽ PIN (4 ቑጽሪ)', 'om': 'PIN haaraa (lakk. 4)', 'so': 'PIN cusub (4 nambar)', 'gur': 'አዲስ PIN (4 ቁጥሮቸ)'});
  String get confirmPinHint => _t({'en': 'Confirm PIN', 'am': 'PIN አረጋግጥ', 'ti': 'PIN ኣረጋግጽ', 'om': 'PIN mirkaneessi', 'so': 'PIN xaqiiji', 'gur': 'PIN አረጋግጥ'});
  String get pinRemoved => _t({'en': 'PIN removed', 'am': 'PIN ተወግዷል', 'ti': 'PIN ተኣሊዩ', 'om': 'PIN haqame', 'so': 'PIN waa la tirtiray', 'gur': 'PIN ተወግዷ'});
  String get removePinButton => _t({'en': 'Remove PIN', 'am': 'PIN አስወግድ', 'ti': 'PIN ኣልዕሎ', 'om': 'PIN haqi', 'so': 'Ka saar PIN', 'gur': 'PIN አስወግድ'});
  String get savePin => _t({'en': 'Save PIN', 'am': 'PIN አስቀምጥ', 'ti': 'PIN ዓቅብ', 'om': "PIN olkaa'i", 'so': 'Kaydi PIN', 'gur': 'PIN አኑር'});
  String get pinInvalid => _t({'en': 'PIN must be exactly 4 digits', 'am': 'PIN ትክክል 4 ቁጥሮች መሆን አለበት', 'ti': 'PIN ልክ 4 ቑጽሪ ክኸውን ኣለዎ', 'om': 'PIN lakkoofsa 4 qofa ta\'uu qaba', 'so': 'PIN waa in uu ahaa 4 nambar oo kaliya', 'gur': 'PIN ትክክለኛ 4 ቁጥሮቸ ሊሆን አለበት'});
  String get pinSet => _t({'en': 'Security PIN set', 'am': 'የደህንነት PIN ተዘጋጅቷል', 'ti': 'ናይ ድሕንነት PIN ዝቀረበ', 'om': 'PIN nageenyaa qophaahe', 'so': 'PIN amni ayaa la dejiyay', 'gur': 'የደህንነት PIN ተዘጋጅቷ'});
  String get anyAvailable => _t({'en': 'Any Available', 'am': 'ማናቸውም', 'ti': 'ዝኾነ ዘሎ', 'om': 'Kamiyyuu argamu', 'so': 'Wixii la heli karo', 'gur': 'ማናቸውም'});
  String get biometricsFirstThenPin => _t({'en': 'Biometrics first, then PIN', 'am': 'ቀድሞ ባዮሜትሪክ፣ ቀጥሎ PIN', 'ti': 'ቅድሚ ባዮሜትሪክ፣ ቀጺሉ PIN', 'om': 'Dursa bayoomeetriksii, booda PIN', 'so': 'Bayometrika marka hore, ka dib PIN', 'gur': 'ቀድሞ ባዮሜትሪክ፣ ቀጥሎ PIN'});
  String get biometricsOnly => _t({'en': 'Biometrics Only', 'am': 'ባዮሜትሪክ ብቻ', 'ti': 'ባዮሜትሪክ ጥራሕ', 'om': 'Bayoomeetriksii qofa', 'so': 'Bayometrika kaliya', 'gur': 'ባዮሜትሪክ ብቻ'});
  String get pinOnly => _t({'en': 'PIN Only', 'am': 'PIN ብቻ', 'ti': 'PIN ጥራሕ', 'om': 'PIN qofa', 'so': 'PIN kaliya', 'gur': 'PIN ብቻ'});
  String get sessionTimeout => _t({'en': 'Session Timeout', 'am': 'ሴሽን ማብቂያ', 'ti': 'ሴሽን ምዕጻው', 'om': 'Yeroo seeshinii', 'so': 'Xilliga session-ka', 'gur': 'ሴሽን ማብቂያ'});
  String get autoLogoutAfterInactivity => _t({'en': 'Auto-logout after inactivity', 'am': 'ቦዶ ሆኖ ሲቀር ይወጣል', 'ti': 'ምንቅስቃስ ምስ ጠፍአ ይወጽ', 'om': 'Sosochuu dhaabuu booda of-baasuu', 'so': 'Ka bax toos markuu hurdo la\'aano', 'gur': 'ቦዶ ሆኖ ሲቀር ይወጣ'});
  String get appLockDelay => _t({'en': 'App Lock Delay', 'am': 'ኣፕ የቆልፍ ጊዜ', 'ti': 'ኣፕ ጊዜ ምዕጻው', 'om': 'Tarii cufaa app', 'so': 'Daahitaanka xidida app-ka', 'gur': 'ኣፕ የቆልፍ ጊዜ'});
  String get lockAfterBackgrounding => _t({'en': 'Lock screen after backgrounding', 'am': 'ወደ ኋላ ሲሄድ ይቆለፋል', 'ti': 'ናብ ድሕሪ ምስ ከደ ይዕጾ', 'om': 'Gara duubaa yeroo deemu cufama', 'so': 'Xidid shaashadda ka dib marka la damiyey', 'gur': 'ወደ ኋላ ሲሄድ ይቆለፋ'});
  // ─── Profile screen settings subtitles ─────────────
  String get subtitleTermsRiskPrivacy => _t({'en': 'Terms, Risk Disclosures, Privacy Policy', 'am': 'ውሎዎች፣ አደጋ ምስክሮች፣ የግላዊነት ፖሊሲ', 'ti': 'ውዕሊ፣ ሓደጋ ምስክርነት፣ ፖሊሲ ምስጢርነት', 'om': 'Shartoota, Ibsa Gaaga, Polisii Dhuunfaa', 'so': 'Shuruucda, Muujinta Khatarta, Xeerka Arrimaha Gaarka', 'gur': 'ውሎዎቸ፣ አደጋ ምስክሮቸ፣ ምስጢርነት ፖሊሲ'});
  String get subtitleEcxLicensing => _t({'en': 'ECX licensing info', 'am': 'ECX ፍቃድ መረጃ', 'ti': 'ሓበሬታ ፍቓድ ECX', 'om': 'Odeeffannoo hayyama ECX', 'so': 'Macluumaadka ruqsadda ECX', 'gur': 'ECX ፍቃድ ሓበሬታ'});
  String get subtitleShariaAudit => _t({'en': 'Sharia screening audit', 'am': 'የሸሪዓ ምርጫ ምርመራ', 'ti': 'ናይ ሸሪዓ ምምርቓ ምፍታሽ', 'om': "Qormaata saagii Shari'aa", 'so': 'Xisaabinta xayiraadda Shariicada', 'gur': 'የሸሪዓ ምርጫ ምርመራ'});
  String get subtitleTaxDeclaration => _t({'en': 'Annual P&L for tax declaration', 'am': 'ዓመታዊ ትርፍ/ኪሳራ ለታክስ ጊዜ', 'ti': 'ዓመታዊ ትርፊ/ክሳራ ናይ ታክስ ምልክት', 'om': 'Tarreeffama taaksii waggaaf Bu\'aa/Kasaaraa', 'so': 'Faa\'iidada/Khasaare sanadlaha ah ee bayaanka canshuurta', 'gur': 'ዓመታዊ ትርፍ/ኪሳራ ለታክስ'});
  String get subtitlePriceMovements => _t({'en': 'Price movements & trends', 'am': 'የዋጋ እንቅስቃሴ እና አዝማሚያዎች', 'ti': 'ምቅስቃስ ዋጋ ዝምባሌ', 'om': 'Sosochuu gatii fi damee', 'so': 'Dhaqdhaqaaqyada qiimaha & tolooyinka', 'gur': 'የዋጋ እንቅስቃሴ እና አዝማሚያዎቸ'});
  String get subtitleNewsletterAi => _t({'en': 'Newsletter & AI assistance', 'am': 'ዜና ደብዳቤ እና AI እርዳታ', 'ti': 'ሓዲሽ ዜና AI ሓጋዚ', 'om': 'Waraqaa Oduu fi gargaarsa AI', 'so': 'Warqadda wararka & caawinta AI', 'gur': 'ዜና ደብዳቤ AI እርዳታ'});
  String get subtitleFaqDocs => _t({'en': 'FAQ, docs, community forums', 'am': 'ጥያቄዎች፣ ሰነዶች፣ የማህበረሰብ ፎረሞች', 'ti': 'ሕቶ ሰነዳት ፎረም', 'om': 'Gaaffilee, Waraqaalee, Foorami hawaasaa', 'so': 'Su\'aalaha, dukumiintiyadda, barxadyada bulshada', 'gur': 'ጥያቄዎቸ፣ ሰነዶቸ፣ ፎረሞቸ'});
  String get subtitleSupportTicket => _t({'en': 'Submit ticket or chat with agents', 'am': 'ቲኬት ያስገቡ ወይም ከወኪሎች ጋር ይወያዩ', 'ti': 'ቲኬት ኣእቱ ወይ ምስ ወኪላት ሕወስ', 'om': 'Tiikeetii galchi ykn hoggantoota waliin haasawuu', 'so': 'Xogta soo gudbi ama la sheekeyso wakiilada', 'gur': 'ቲኬት ያስገቡ ወይ ከወኪሎቸ ጋር ይወያዩ'});
  String get subtitlePasswordTwoFa => _t({'en': 'Password & 2FA', 'am': 'የይለፍ ቃል እና 2FA', 'ti': 'ፓስወርድ 2FA', 'om': 'Jecha darbii fi 2FA', 'so': 'Furaha sirta & 2FA', 'gur': 'ፓስወርድ 2FA'});
  String get subtitleDataSharing => _t({'en': 'Data sharing & visibility', 'am': 'ዳታ ማካፈያ እና ታይነት', 'ti': 'ዳታ ምክፋፍ ታይነት', 'om': 'Qooduu deetaa fi mul\'achuu', 'so': 'Wadaagista xogta & muuqaalka', 'gur': 'ዳታ ማካፈያ ታይነት'});
  String get subtitleWealthProtection => _t({'en': 'Wealth protection & PIN', 'am': 'ሀብት ጥበቃ እና PIN', 'ti': 'ሕልዋ ዕቃ PIN', 'om': 'Eegumsa qabeenya fi PIN', 'so': 'Ilaalinta hantida & PIN', 'gur': 'ሀብት ጥበቃ PIN'});
  String get subtitlePersonalDetails => _t({'en': 'Update personal details, avatar & contact', 'am': 'የግል መረጃ፣ ምስሉ እና ዕውቂያ ያዘምኑ', 'ti': 'ሓበሬታ ውልቀ፣ ስዕሊ ዕውቂያ ኣዕዝዝ', 'om': 'Odeeffannoo dhuunfaa, suura fi qunnamtii haaromsi', 'so': 'Macluumaadka shakhsiga, sawirka & xiriirka cusboonaysii', 'gur': 'ናይ ውልቀ ሓበሬታ፣ ምስሉ ዕውቂያ ኣዘምን'});
  String get subtitleBankAccounts => _t({'en': 'Manage linked bank accounts & invoices', 'am': 'የተሳሰሩ ባንክ ሒሳቦችን እና ቢሎዎችን አስተዳድሩ', 'ti': 'ምምሕዳር ናይ ዝተኣሳሰሩ ባንክ ሒሳባት ናብዳዎ', 'om': 'Herrega baankii fi herrega galii bulchi', 'so': 'Maamul xisaabaha bangiga la xidnay & qaansooyinka', 'gur': 'ናይ ዝተሳሰሩ ባንክ ሒሳቦቸ ኣስተዳድሩ'});
  String get subtitleAccountSecurity => _t({'en': 'Protect your account & manage privacy', 'am': 'ሒሳብዎን ይጠብቁ እና ምስጢርነት ያስተዳድሩ', 'ti': 'ሒሳብካ ሓሉ ምስጢርነት ምምሕዳር', 'om': 'Herrega kee tiksi fi dhuunfaa bulchi', 'so': 'Xisaabta ilaali & maamul arrimaha gaarka ah', 'gur': 'ሒሳብዎን ጠብቁ ምስጢርነት ያስተዳድሩ'});
  String get subtitleChangePassword => _t({'en': 'Change password & enable Two-Factor Authentication (2FA)', 'am': 'የይለፍ ቃል ይቀይሩ እና 2FA ያስጀምሩ', 'ti': 'ፓስወርድ ቀይር 2FA ጀምር', 'om': 'Jecha darbii jijjiiri fi 2FA jalqabi', 'so': 'Furaha sirta beddel & 2FA hawl-geli', 'gur': 'ፓስወርድ ቀይር 2FA ጀምር'});
  String get subtitleDataVisibility => _t({'en': 'Manage data sharing & account visibility settings', 'am': 'የዳታ ማካፈያ እና ሒሳብ ታይነት ቅንጅቶች ያስተዳድሩ', 'ti': 'ቅንጅቶ ምክፋፍ ዳታ ሒሳብ ታይነት ምምሕዳር', 'om': 'Qindaa\'ina qooduu deetaa fi argamuu herregaa bulchi', 'so': 'Maamul goobaha wadaagista xogta & muuqaalka xisaabta', 'gur': 'ናይ ዳታ ማካፈያ ሒሳብ ታይነት ቅንጅቶቸ ያስተዳድሩ'});
  String get subtitleAlertsMessaging => _t({'en': 'Configure alerts & messaging preferences', 'am': 'ማስጠንቀቂያ እና ምልክት ቅምሞዎቹን ያቀናጁ', 'ti': 'ናይ ሓደጋ ምልክቶ ናይ መልእኽቲ ምምሕዳር ቀናብር', 'om': 'Qindaa\'ina beeksisaa fi ergaa', 'so': 'Dejiso doorashooyinka digniin-bixinta & farriimaha', 'gur': 'ማስጠንቀቂያ ምልክት ቅምሞዎቸ ያቀናጁ'});
  String get subtitleConfigureAlerts => _t({'en': 'Configure push/email alerts for price movements & trends', 'am': 'ለዋጋ እንቅስቃሴ push/email ማስጠንቀቂያ ያቀናጁ', 'ti': 'ናይ ዋጋ ምቅስቃስ push/email ሓደጋ ምልክቶ ቀናብር', 'om': 'Beeksisa push/email sosochuu gatii qindeessi', 'so': 'Dejiso digniin-bixinta push/email dhaqdhaqaaqyada qiimaha', 'gur': 'ዋጋ ምቅስቃስ push/email ማስጠንቀቂያ ያቀናጁ'});
  String get subtitleNewsletterToggle => _t({'en': 'Toggle newsletter & system-triggered AI assistance', 'am': 'ዜና ደብዳቤ እና AI እርዳታ ያብሩ/ያጥፉ', 'ti': 'ዜና ደብዳቤ AI ሓጋዚ ኣብሩ/ኣጥፍኡ', 'om': 'Waraqaa oduu fi gargaarsa AI banaa/cufaa', 'so': 'Toggle warqadda wararka & gargaarka AI-ka nidaamka u kiciya', 'gur': 'ዜና ደብዳቤ AI እርዳታ ያብሩ/ያጥፉ'});
  String get subtitleFaqHelp => _t({'en': 'FAQ, documentation & contact', 'am': 'ጥያቄዎች፣ ሰነዶች እና ዕውቂያ', 'ti': 'ሕቶ ሰነዳት ዕውቂያ', 'om': 'Gaaffilee, Waraqaalee fi Qunnamtii', 'so': 'Su\'aalaha, dukumiintiyadda & xiriirka', 'gur': 'ጥያቄዎቸ፣ ሰነዶቸ ዕውቂያ'});
  String get subtitleAccessFaq => _t({'en': 'Access FAQ, help documentation & community forums', 'am': 'ጥያቄዎቻቸውን፣ እርዳታ ሰነዶቻቸውን እና ፎረሞቻቸውን ይጎብኙ', 'ti': 'ሕቶ ሰነዳት ፎረም ሓጋዚ ጎብዝ', 'om': 'Gaaffilee, Waraqaalee gargarsaa fi Foorami hawaasaa ilaalee', 'so': 'Gal Su\'aalaha, dukumiintiyadda gargaarka & barxadyada bulshada', 'gur': 'ጥያቄዎቸ፣ ሰነዶቸ ፎረሞቸ ጎብኙ'});
  String get subtitleSupportChat => _t({'en': 'Submit a support ticket or start an in-app chat', 'am': 'ቲኬት ያስገቡ ወይም ኣፕ ውስጥ ውይይት ጀምሩ', 'ti': 'ቲኬት ኣእቱ ወይ ኣፕ ውሽጢ ሕወስ ጀምር', 'om': 'Tiikeetii galchi ykn haasawa app keessaa jalqabi', 'so': 'Xogta geli ama bilow wada-hadal app-ka gudihiisa', 'gur': 'ቲኬት ያስገቡ ወይ ኣፕ ውስጥ ውይይት ጀምሩ'});
  String get qty => _t({'en': 'Qty', 'am': 'ብዛት', 'ti': 'ብዝሒ', 'om': "Ba'aa", 'so': 'Tirada', 'gur': 'ብዛት'});
  String get unit => _t({'en': 'Unit', 'am': 'ክፍሊ', 'ti': 'ክፍሊ', 'om': 'Iddoo', 'so': 'Cutubka', 'gur': 'ክፍሊ'});
  String get avg => _t({'en': 'Avg', 'am': 'አማካይ', 'ti': 'ማእከላይ', 'om': 'Giddugaleessa', 'so': 'Celceliska', 'gur': 'አማካይ'});
  String get changeLabel => _t({'en': 'Change', 'am': 'ቀይር', 'ti': 'ቀይር', 'om': 'Jijjiiri', 'so': 'Beddel', 'gur': 'ቀይር'});
  String get setPinButton => _t({'en': 'Set PIN', 'am': 'PIN ዘርጋ', 'ti': 'PIN ቀናብር', 'om': 'PIN qindeessi', 'so': 'Dejiso PIN', 'gur': 'PIN ዘርጋ'});
  String get securityRequired => _t({'en': 'Security Required', 'am': 'ደህንነት ያስፈልጋል', 'ti': 'ድሕንነት ይሕለፍ', 'om': 'Nageenyaan barbaachisa', 'so': 'Amni waajib ah', 'gur': 'ደህንነት ያስፈጋ'});
  String get enterPin => _t({'en': 'Enter PIN', 'am': 'PIN ያስገቡ', 'ti': 'PIN ኣእቱ', 'om': 'PIN galchi', 'so': 'Geli PIN', 'gur': 'PIN ያስገቡ'});
  String get ok => _t({'en': 'OK', 'am': 'እሺ', 'ti': 'ቅቡል', 'om': 'Egaa', 'so': 'Waaye', 'gur': 'እሺ'});
  String get appVersion => _t({'en': 'Version 1.0', 'am': 'ስሪት 1.0', 'ti': 'ሓርበኛ 1.0', 'om': 'Galmee 1.0', 'so': 'Nooca 1.0', 'gur': 'ስሪት 1.0'});
  String get tooManyFailedAttempts => _t({'en': 'Too many failed attempts', 'am': 'ብዙ ሙከራዎች ወድቀዋል', 'ti': 'ብዙ ፈተናታት ወዲቀን', 'om': "Yaalii kufe baay'inaan", 'so': 'Isku dayado fashilmay oo badan', 'gur': 'ብዙ ሙከራዎቸ ወድቀዋ'});
  String get securityPinRequiredMsg => _t({'en': 'A security PIN is required to authorize transactions.\n\nGo to Profile → Security → App Lock to set up your PIN.', 'am': 'ግብይቶችን ለማፅደቅ የደህንነት PIN ያስፈልጋል።\n\nPIN ለማዘጋጀት ፕሮፋይል → ደህንነት → ኣፕ ቆልፍ ይሂዱ።', 'ti': 'PIN ድሕንነት ንምርግጋጽ ምትሕልላፍ ያስፈልጋ።\n\nPIN ንምቕናዕ ፕሮፋይል → ድሕንነት → ሸፋዕ ኣፕ ሂድ።', 'om': 'Hojii mallaqa hayyamuuf PIN nageenyaa barbaachisa.\n\nPIN qopheessuuf Piroofaayilii → Nageenyaa → Cufaa App deemuun.', 'so': 'PIN amni ah ayaa loo baahan yahay si loo oggolaado macaamilaadaha.\n\nSi aad PIN u dejiso u tag Profile → Amniga → App Lock.', 'gur': 'ግብይቶቼን ለፍቀድ የደህንነት PIN ያስፈጋ።\n\nPIN ለዘጋጀ ፕሮፋይል → ደህንነት → ኣፕ ቆልፍ ሂዱ።'});

  // ─── Profile / Account Details ────────────────────────────
  String get kycVerifiedTier => _t({'en': 'Tier 1 — Verified ✓', 'am': 'ደረጃ 1 — ተረጋግጧል ✓', 'ti': 'ቀዳማይ ደረጃ — ተረጋጊጹ ✓', 'om': 'Sadarkaa 1 — Mirkanaawe ✓', 'so': 'Heer 1 — La xaqiijiyay ✓', 'gur': 'ደረጃ 1 — ተረጋግጧ ✓'});
  String get kycUploadDocs => _t({'en': 'Upload ID documents & check approval', 'am': 'መታወቂያ ይስቀሉ እና ፍቃድ ያረጋግጡ', 'ti': 'ወثائق ናይ መለለዪ ኣስቀምጥ ምፍቃድ ርአ', 'om': 'Waraqaalee ID kaa\'i hayyama ilaalee', 'so': 'Dhig dukumiintiyada aqoonsiga & hubi oggolaanshaha', 'gur': 'ID ሰነዶቸ ስቀሉ ፍቃድ ያረጋግጡ'});
  String get flatCommissionLimit => _t({'en': '1.5% flat commission • 100K ETB daily limit', 'am': '1.5% ኮሚሽን • 100ሺ ETB ዕለታዊ ወሰን', 'ti': '1.5% ኮሚሽን • 100ሺ ETB ዕለታዊ ጸዳ', 'om': 'Komishinii 1.5% • Daangaa guyyaa ETB 100K', 'so': 'Komishin 1.5% • 100K ETB xad maalinlah', 'gur': '1.5% ኮሚሽን • 100ሺ ETB ዕለታዊ ወሰን'});
  String get commissionRateLabel => _t({'en': 'Commission rate', 'am': 'የኮሚሽን መጠን', 'ti': 'ምጣነ ኮሚሽን', 'om': 'Iddoo komishinii', 'so': 'Heerka komishiniga', 'gur': 'የኮሚሽን መጠን'});
  String get commissionRateValue => _t({'en': '1.5% flat (Riba-free)', 'am': '1.5% ቋሚ (ሪባ-ነጻ)', 'ti': '1.5% ቋሚ (ሪባ-ናጻ)', 'om': '1.5% duraatti (Riba-bilisaa)', 'so': '1.5% xasil (Riba-free)', 'gur': '1.5% ቋሚ (ሪባ-ነጻ)'});
  String get dailyWithdrawalLimit => _t({'en': 'Daily withdrawal limit', 'am': 'ዕለታዊ ወጪ ወሰን', 'ti': 'ዕለታዊ ጸዳ ምውጻእ', 'om': 'Daangaa baasuun guyyaa', 'so': 'Xadka bixitaanka maalinlaha', 'gur': 'ዕለታዊ ወጪ ወሰን'});
  String get weeklyTradingLimit => _t({'en': 'Weekly trading limit', 'am': 'ሳምንታዊ የንግድ ወሰን', 'ti': 'ሳምናዊ ጸዳ ንግዲ', 'om': 'Daangaa daldala torbanaa', 'so': 'Xadka ganacsiga toddobaadlaha', 'gur': 'ሳምንታዊ የንግድ ወሰን'});
  String get planTypeLabel => _t({'en': 'Plan', 'am': 'ዕቅድ', 'ti': 'ዕቅዲ', 'om': 'Karoora', 'so': 'Qorshe', 'gur': 'ዕቅድ'});
  String get settlementLabel => _t({'en': 'Settlement', 'am': 'ማስተካከያ', 'ti': 'ኣወሳሰና', 'om': 'Qoduumaa', 'so': 'Xal-gelin', 'gur': 'ማስተካከያ'});
  String get retailTraderStandard => _t({'en': 'Retail Trader — Standard', 'am': 'ትናንሽ ነጋዴ — ደረጃ', 'ti': 'ነጋዴ ንእሽቶ — ደረጃ', 'om': 'Gurgurtaa — Sadarkaa', 'so': 'Ganacsade Yar — Caadi', 'gur': 'ትናንሽ ነጋዴ — ደረጃ'});
  String get settlementTPlus2 => _t({'en': 'T+2 (ECX standard)', 'am': 'T+2 (ECX ደረጃ)', 'ti': 'T+2 (ECX ደረጃ)', 'om': 'T+2 (Sadarkaa ECX)', 'so': 'T+2 (heerka ECX)', 'gur': 'T+2 (ECX ደረጃ)'});
  String get shariaFeeNote => _t({'en': 'All fees are Sharia-compliant flat commissions. No hidden interest (Riba) charges.', 'am': 'ሁሉም ክፍያዎች ሸሪዓ ተኳካሪ ቋሚ ኮሚሽኖች ናቸው። ምንም ወለድ (ሪባ) የለም።', 'ti': 'ኩሉ ክፍሊታት ሸሪዓ-ኣሳማሚ ቋሚ ኮሚሽን እዮም። ወለድ (ሪባ) የልቦን።', 'om': 'Kafaltiin hundi komishinii duraatti Shari\'aa-waliin wal-simu. Dhala (Riba) dhokataa hin qabu.', 'so': 'Dhammaan kharashyaddu waa komishinno xasil oo ku habboon Shariicada. Lacag dulsaar (Riba) ah ma jirto.', 'gur': 'ሁሉ ክፍያዎቸ ሸሪዓ ቋሚ ኮሚሽኖቸ ናቸው። ወለድ (ሪባ) የለም።'});
  String get personalInformationSub => _t({'en': 'Personal information', 'am': 'የግል መረጃ', 'ti': 'ሓበሬታ ውልቀ', 'om': 'Odeeffannoo dhuunfaa', 'so': 'Macluumaadka shakhsiga', 'gur': 'ናይ ውልቀ ሓበሬታ'});
  String get kycFinancialProfile => _t({'en': 'KYC financial profile', 'am': 'KYC የፋይናንስ ፕሮፋይል', 'ti': 'ናይ KYC ፋይናንስ ፕሮፋይል', 'om': 'Piroofaayilii faayinaansii KYC', 'so': 'Xogta maaliyadeed ee KYC', 'gur': 'KYC ፋይናንስ ፕሮፋይል'});
  String get aaoifiCompliant => _t({'en': 'AAOIFI Compliant', 'am': 'AAOIFI ተኳካሪ', 'ti': 'AAOIFI ኣሳማሚ', 'om': "AAOIFI Waliin wal-simu", 'so': 'AAOIFI ku habboon', 'gur': 'AAOIFI ተኳካሪ'});
  String get country => _t({'en': 'Country', 'am': 'ሀገር', 'ti': 'ሃገር', 'om': 'Biyya', 'so': 'Wadanka', 'gur': 'ሀገር'});
  String get dateOfBirth => _t({'en': 'Date of Birth', 'am': 'የልደት ቀን', 'ti': 'ዕለት ልደት', 'om': 'Guyyaa dhalachuu', 'so': 'Taariikhda dhalashada', 'gur': 'የልደት ቀን'});
  String get cityLabel => _t({'en': 'City', 'am': 'ከተማ', 'ti': 'ከተማ', 'om': 'Magaalaa', 'so': 'Magaalada', 'gur': 'ከተማ'});
  String get editProfile => _t({'en': 'Edit Profile', 'am': 'ፕሮፋይል አርትዕ', 'ti': 'ፕሮፋይል ኣርትዕ', 'om': 'Piroofaayilii gulaali', 'so': 'Bogga wax ka beddel', 'gur': 'ፕሮፋይል አርትዕ'});
  String get saveFailed => _t({'en': 'Failed to save. Please try again.', 'am': 'ማስቀመጥ አልተሳካም። እባክዎ ደግሜ ሞክሩ።', 'ti': 'ምዕቃብ ኣይሰለጠን። በጃኻ ደጊምካ ፈትን።', 'om': 'Olkaa\'uun hin milkoofne. Maaloo irra deebi\'i yaalidhu.', 'so': 'Keydinta way ku guul darreysatay. Fadlan mar kale isku day.', 'gur': 'ማስቀ አልተሳካም። እባክህ ደጊም ሞክሩ።'});
  String get saving => _t({'en': 'Saving…', 'am': 'እየቀመጠ…', 'ti': 'ይዕቅብ…', 'om': 'Olkaa\'ama…', 'so': 'Kaydinaya…', 'gur': 'ቀምጦ…'});
  String get ecxLicensing => _t({'en': 'ECX licensing & compliance status', 'am': 'ECX ፍቃድ እና ተኳካሪ ሁኔታ', 'ti': 'ፍቓድ ECX ናይ ምስምምዓ ኩነታ', 'om': 'Hayyama ECX fi Haala wal-simuu', 'so': 'Ruqsadda ECX & xaalada waafaqsanaanta', 'gur': 'ECX ፍቃድ ተኳካሪ ሁኔታ'});
  String get shariaScreeningReport => _t({'en': 'Sharia screening process & audit reports', 'am': 'የሸሪዓ ምርጫ ሂደት እና ምርመራ ሪፖርቶች', 'ti': 'ናይ ሸሪዓ ምምርቓ ሂደት ናይ ምርመራ ሪፖርት', 'om': 'Dhiyeessii saagii Shari\'aa fi gabaasaalee qormaataa', 'so': 'Nidaamka xayiraadda Shariicada & warbixinnada xisaabinta', 'gur': 'የሸሪዓ ምርጫ ሂደት ምርመራ ሪፖርቶቸ'});
  String get annualTaxStatements => _t({'en': 'Annual P&L statements for tax declaration', 'am': 'ዓመታዊ ትርፍ/ኪሳራ ሪፖርቶች ለታክስ ጊዜ', 'ti': 'ዓመታዊ ሪፖርት ናይ ትርፊ/ክሳራ ንምልክት ታክስ', 'om': 'Gabaasa waggaaf Bu\'aa/Kasaaraa tarreeffama taaksii', 'so': 'Warbixinnada sanadlaha ah ee Faa\'iido/Khasaare ee bayaanka canshuurta', 'gur': 'ዓመታዊ ትርፍ/ኪሳራ ሪፖርቶቸ ለታክስ'});
  String get privacyControlsComingSoon => _t({'en': 'Privacy Controls — coming soon', 'am': 'የምስጢርነት ቅንጅቶች — በቅርቡ', 'ti': 'ቅንጅቶ ምስጢርነት — ቀልጢፉ', 'om': 'Qindaa\'ina Dhuunfaa — dhufa', 'so': 'Xaddadka Arrimaha Gaarka — soo socdaa', 'gur': 'ምስጢርነት ቅንጅቶቸ — ቅርቡ'});

  // ─── Account / Profile Information screen ───────────
  String get closeAccount => _t({'en': 'Close Account', 'am': 'ሒሳብ ዝጋ', 'ti': 'ሒሳብ ዕጸዎ', 'om': 'Herrega cufii', 'so': 'Xidh Xisaabta', 'gur': 'ሒሳብ ዝጋ'});
  String get closeAccountTitle => _t({'en': 'Close your account?', 'am': 'ሒሳብዎን ይዘጉ?', 'ti': 'ሒሳብካ ዕጸዎ?', 'om': 'Herrega kee cufuu?', 'so': 'Xisaabtagaaga xidhi?', 'gur': 'ሒሳብህን ዝጋ?'});
  String get closeAccountWarning => _t({'en': 'This will permanently delete your account, portfolio, and all transaction history. This action cannot be undone.', 'am': 'ይህ ሒሳብዎን፣ ፖርትፎሊዮዎን እና ሁሉም ግብይቶን ይሰርዛል። ይህ ሊቀለበስ አይችልም።', 'ti': 'እዚ ሒሳብካ ፖርትፎሊዮካ ኩሉ ምምልላስ ዘይካኣሎ ይሰርዞ።', 'om': 'Kun herrega kee, poortfooliyoo kee, fi tarreeffama hojii hunda ni haqa. Kun deebi\'uu hin danda\'u.', 'so': 'Tani waxay si joogto ah u tirtirtaa xisaabtagaaga, portfolio-gaaga, iyo taariikhda dhammaan macaamilaadaha. Ficilkan lama noqon karo.', 'gur': 'ይህ ሒሳብህን፣ ፖርትፎሊዮህን ሁሉ ይሰርዛ። ሊቀለበስ አይቻልም።'});
  String get confirmCloseAccount => _t({'en': 'Yes, close my account', 'am': 'አዎ፣ ሒሳቤን ዝጋ', 'ti': 'እወ፣ ሒሳበይ ዕጸዎ', 'om': 'Eeyyee, herrega koo cufii', 'so': 'Haa, xidh xisaabtayda', 'gur': 'አዎ ሒሳቤን ዝጋ'});
  String get saveChanges => _t({'en': 'Save Changes', 'am': 'ለውጦቹን አስቀምጥ', 'ti': 'ለውጢታት ዓቅብ', 'om': 'Jijjiirama ol-kaanah', 'so': 'Keydi isbedelada', 'gur': 'ለውጦቹን አኑር'});
  String get cancelEdit => _t({'en': 'Cancel', 'am': 'ሰርዝ', 'ti': 'ሰርዝ', 'om': 'Haqi', 'so': 'Baaji', 'gur': 'ሰርዝ'});
  String get city => _t({'en': 'City', 'am': 'ከተማ', 'ti': 'ከተማ', 'om': 'Magaalaa', 'so': 'Magaalada', 'gur': 'ከተማ'});
  String get registrationStep => _t({'en': 'Registration', 'am': 'ምዝገባ', 'ti': 'ምዝገባ', 'om': 'Galmeessa', 'so': 'Diiwaangelinta', 'gur': 'ምዝገባ'});
  String get documentUpload => _t({'en': 'Document Upload', 'am': 'ሰነድ ስቀል', 'ti': 'ሰነድ ስቀል', 'om': 'Sanaduu fe\'i', 'so': 'Dukumiintiga geli', 'gur': 'ሰነድ ስቀል'});
  String get tier1Verified => _t({'en': 'Tier 1 — Verified ✓', 'am': 'ደረጃ 1 — ተረጋግጧል ✓', 'ti': 'ደረጃ 1 — ተረጋጊጹ ✓', 'om': 'Sadarkaa 1 — Mirkanaame ✓', 'so': 'Heer 1 — Xaqiijiyay ✓', 'gur': 'ደረጃ 1 — ተረጋግጧ ✓'});
  String get uploadIdDocuments => _t({'en': 'Upload ID documents & check approval', 'am': 'መታወቂያ ሰነዶች ያስጭኑ እና ፈቃድ ያረጋግጡ', 'ti': 'ሰነዳት መፍለጺ ስቐሎ ፈቓድ ኣረጋግጽ', 'om': 'Waraqaalee eenyummaa fe\'i hayyama ilaali', 'so': 'Dukumiintiyadda aqoonsiga geli ee hubso oggolaanshaha', 'gur': 'ሰነዶቸ ያስጭኑ ፈቃድ ያረጋግጡ'});
  String get commissionRate => _t({'en': 'Commission rate', 'am': 'የኮሚሽን ተመን', 'ti': 'ምጣነ ኮሚሽን', 'om': 'Gatii komishinii', 'so': 'Heerka komishinku', 'gur': 'ኮሚሽን ተመን'});
  String get commissionValue => _t({'en': '1.5% flat (Riba-free)', 'am': '1.5% ቋሚ (ወለድ-ነጻ)', 'ti': '1.5% ቋሚ (ወለድ-ናጻ)', 'om': '1.5% duraatti (dhala-bilisaa)', 'so': '1.5% xasil (Riba-free)', 'gur': '1.5% ቋሚ (ወለድ-ነጻ)'});
  String get planType => _t({'en': 'Plan', 'am': 'እቅድ', 'ti': 'ውጥን', 'om': 'Karoora', 'so': 'Qorshe', 'gur': 'እቅድ'});
  String get settlementType => _t({'en': 'Settlement', 'am': 'ክፍያ ወቅት', 'ti': 'ምፍታሕ', 'om': 'Fumiinsa', 'so': 'Xalashada', 'gur': 'ክፍያ ወቅት'});
  String get kycStatusLabel => _t({'en': 'KYC Status', 'am': 'KYC ሁኔታ', 'ti': 'KYC ኩነታ', 'om': 'Haala KYC', 'so': 'Xaalada KYC', 'gur': 'KYC ሁኔታ'});
  String get devicesLabel => _t({'en': 'Devices', 'am': 'መሳሪያዎች', 'ti': 'መሳርሒታት', 'om': 'Meeshaalee', 'so': 'Qalabka', 'gur': 'መሳሪያዎቸ'});
  String get hideBalance => _t({'en': 'Hide Balance', 'am': 'ቀሪ ደብቅ', 'ti': 'ቀሪ ሕቡእ', 'om': 'Haftee dhoksi', 'so': 'Qari Haraaga', 'gur': 'ቀሪ ደብቅ'});
  String get showBirthday => _t({'en': 'Show my birthday', 'am': 'ልደቴን አሳይ', 'ti': 'ልደተይ ኣርኢ', 'om': 'Dhalootakoo agarsiisi', 'so': 'Tus dhalashadayda', 'gur': 'ልደቴን ኣርኢ'});
  String get showPlan => _t({'en': 'Show my plan', 'am': 'እቅዴን አሳይ', 'ti': 'ውጥነይ ኣርኢ', 'om': 'Karoora koo agarsiisi', 'so': 'Tus qorshahayga', 'gur': 'እቅዴን ኣርኢ'});
  String get socialMediaAdvertising => _t({'en': 'Social media and advertising', 'am': 'ሶሻል ሚዲያ እና ማስታወቂያ', 'ti': 'ሶሻሊ ሚዲያ ኣዋጅ', 'om': 'Miidiyaa hawaasaa fi beeksisa', 'so': 'Warbaahinta bulshada iyo xayeysiinta', 'gur': 'ሶሻል ሚዲያ ማስታወቂያ'});
  String get privacyPersonalizedOffers => _t({'en': 'Personalised TradEt offers', 'am': 'ለናንተ የተበጀ ትሬድኢት ቅናሾች', 'ti': 'ናትካ ቅናሾ ትሬድኢት', 'om': 'Dhiyeessii TradEt dhuunfaaf', 'so': 'Qiimo-dhimis TradEt oo kuu gaar ah', 'gur': 'ለናንተ ትሬድኢት ቅናሾቸ'});
  String get privacyPartnerOffers => _t({'en': 'Personalized partners offers', 'am': 'ለናንተ የተበጀ ሽርካ ቅናሾች', 'ti': 'ናትካ ቅናሾ ዓበይቲ', 'om': 'Dhiyeessii michootaa dhuunfaaf', 'so': 'Qiimo-dhimis gacalayaasha oo kuu gaar ah', 'gur': 'ሽርካ ቅናሾቸ'});
  String get tradeVolatilityAlert => _t({'en': 'Trade volatility alert', 'am': 'የንግድ መቀዛቀዝ ማስጠንቀቂያ', 'ti': 'ናይ ንግዲ ዝቁጣ ምልክቶ', 'om': 'Beeksisa jijjirama daldala', 'so': 'Digniinta go\'ga ganacsiga', 'gur': 'ንግድ ማስጠንቀቂያ'});
  String get commodityVolatilityAlert => _t({'en': 'Commodity volatility alert', 'am': 'የምርት ዋጋ ለውጥ ማስጠንቀቂያ', 'ti': 'ናይ ምርቲ ዝቁጣ ምልክቶ', 'om': 'Beeksisa jijjirama meeshaa', 'so': 'Digniinta go\'ga badeecadda', 'gur': 'ምርት ዋጋ ለውጥ ማስጠንቀቂያ'});
  // ─── Appearance screen ───────────────────────────────
  String get themeSubtitle => _t({'en': 'Choose your preferred color theme', 'am': 'የሚወዱትን ቀለም ጭብጥ ይምረጡ', 'ti': 'ጭብጥ ቀለም ምረጽ', 'om': 'Tiima halluu barbaaddu filadhu', 'so': 'Dooro mowduuca midabka aad doorbidayso', 'gur': 'የሚወዱትን ቀለም ጭብጥ ምረጡ'});
  String get interfaceLayout => _t({'en': 'Interface', 'am': 'ממשק', 'ti': 'ኢንተርፌስ', 'om': 'Karooraafi', 'so': 'Xarunta', 'gur': 'ኢንተርፌስ'});
  String get interfaceSubtitle => _t({'en': 'Customize the app layout and density', 'am': 'የኣፕ አቀማመጥ ያበጁ', 'ti': 'ኣፕ ቅርጺ ቀናብር', 'om': 'Caasima app qindeessi', 'so': 'Nidaamka app-ka habayn', 'gur': 'ኣፕ አቀማምጥ ያበጁ'});
  String get textSize => _t({'en': 'Text Size', 'am': 'የጽሑፍ መጠን', 'ti': 'ዓቐን ጽሑፍ', 'om': 'Madaallii barruu', 'so': 'Cabbirka qoraalka', 'gur': 'የጽሑፍ ዓቐን'});
  String get textSizeSubtitle => _t({'en': 'Adjust the text size for readability', 'am': 'ለቀላዕ ንባብ ጽሑፍ ዓቐን ኣስተካክል', 'ti': 'ዓቐን ጽሑፍ ንምንባብ ቀናብር', 'om': 'Madaallii barruu dubbisuuf qindeessi', 'so': 'Cabbirka qoraalka u habayn si loo akhriyi karo', 'gur': 'ለቀላዕ ንባብ ጽሑፍ ዓቐን ቀናብር'});
  String get languageSubtitle => _t({'en': 'Select your preferred language', 'am': 'የሚወዱትን ቋንቋ ይምረጡ', 'ti': 'ቋንቋ ምረጽ', 'om': 'Afaan barbaaddu filadhu', 'so': 'Dooro luqadda aad doorbidayso', 'gur': 'ቋንቋ ምረጡ'});
  // ─── About Us screen ─────────────────────────────────
  String get rateUs => _t({'en': 'Rate us on the App Store', 'am': 'ኣፕ ስቶር ላይ ይደምድሙን', 'ti': 'ኣፕ ስቶር ደምዱሙና', 'om': 'App Stoore irratti nu madaalli', 'so': 'Nagu qiimeey App Store-ka', 'gur': 'ኣፕ ስቶር ይደምድሙን'});
  String get ourBlog => _t({'en': 'Our Blog', 'am': 'ብሎጋችን', 'ti': 'ብሎጋና', 'om': 'Bloogii keenya', 'so': 'Bloggeena', 'gur': 'ብሎጋቸን'});
  String get followOnX => _t({'en': 'Follow us on X', 'am': 'ኤክስ ላይ ይከተሉን', 'ti': 'ኤክስ ይከታተሉና', 'om': 'X irratti nu hordofi', 'so': 'Nagu raac X', 'gur': 'ኤክስ ላይ ከተሉን'});
  String get likeOnFacebook => _t({'en': 'Like us on Facebook', 'am': 'ፌስቡክ ላይ ይወዱን', 'ti': 'ፌስቡክ ኣፍቅሩና', 'om': 'Facebook irratti nu jaalladdhu', 'so': 'Nagu jecel Facebook', 'gur': 'ፌስቡክ ላይ ወዱን'});
  String get openSourceLicenses => _t({'en': 'Open Source Licenses', 'am': 'ክፍት ምንጭ ፈቃዶች', 'ti': 'ክፍት ምንጪ ፈቓዳት', 'om': 'Hayyamoota madda banaa', 'so': 'Ruqsadaha isha furan', 'gur': 'ክፍት ምንጭ ፈቃዶቸ'});
  String get appVersionLabel => _t({'en': 'Version', 'am': 'ስሪት', 'ti': 'ሓርበኛ', 'om': 'Galmee', 'so': 'Nooca', 'gur': 'ስሪት'});
  // ─── Help sub-topics ─────────────────────────────────
  String get gettingStarted => _t({'en': 'Getting Started', 'am': 'ጅምሮ', 'ti': 'ምጅማር', 'om': 'Jalqabuu', 'so': 'Bilaabista', 'gur': 'ጅምሮ'});
  String get tradingHelp => _t({'en': 'Trading', 'am': 'ንግድ', 'ti': 'ንግዲ', 'om': 'Daldala', 'so': 'Ganacsiga', 'gur': 'ንግድ'});
  String get depositWithdrawalHelp => _t({'en': 'Deposit and Withdrawal', 'am': 'ማስገባ እና ማውጣት', 'ti': 'ኣታዊ ወጻኢ', 'om': 'Galchuu fi baasuu', 'so': 'Dhigida iyo saarista', 'gur': 'ማስገባ ማውጣት'});
  String get profileKycHelp => _t({'en': 'Profile & KYC', 'am': 'ፕሮፋይል እና KYC', 'ti': 'ፕሮፋይል KYC', 'om': 'Piroofaayilii fi KYC', 'so': 'Profile iyo KYC', 'gur': 'ፕሮፋይል KYC'});
  String get securityFraudHelp => _t({'en': 'Security & Fraud', 'am': 'ደህንነት እና ማጭበርበር', 'ti': 'ድሕንነት ምትላል', 'om': 'Nageenyaa fi Doorsisuu', 'so': 'Amni & Khiyaanadda', 'gur': 'ደህንነት ማጭበርበር'});
  // ─── Occupation / dropdown options ──────────────────
  String get occupationPublicSector => _t({'en': 'Public Sector Employee (Government)', 'am': 'የሕዝብ ዘርፍ ሰራተኛ (መንግስት)', 'ti': 'ሰራሕተኛ ህዝቢ ዘርፊ (መንግስቲ)', 'om': 'Hojjetaa seektara mootummaa', 'so': 'Shaqaalaha Qaybta Dadweynaha (Dowladda)', 'gur': 'ሕዝብ ዘርፍ ሠራተኛ'});
  String get occupationPrivateSector => _t({'en': 'Private Sector Employee', 'am': 'የግል ዘርፍ ሰራተኛ', 'ti': 'ሰራሕተኛ ብሕቲ ዘርፊ', 'om': 'Hojjetaa seektara dhuunfaa', 'so': 'Shaqaalaha Qaybta Gaarka ah', 'gur': 'ግል ዘርፍ ሠራተኛ'});
  String get occupationSelfEmployed => _t({'en': 'Self-Employed / Entrepreneur', 'am': 'ራሱን ቀጥሮ / ኢንትሪፕሬነር', 'ti': 'ናጻ ሰራሕ / ኢንትሪፕሬነር', 'om': 'Of-ta\'umsa / Bizii dhuunfaa', 'so': 'Shaqada naftiisa / Ganacsade', 'gur': 'ራሱን ቀጥሮ / ኢንትሪፕሬነር'});
  String get occupationFreelancer => _t({'en': 'Freelancer / Digital Professional', 'am': 'ፍሪላንሰር / ዲጂታል ባለሙያ', 'ti': 'ፍሪላንሰር / ዲጂታል ሙያ', 'om': 'Firilaansara / Ogummaa dijiitaalaa', 'so': 'Freelancer / Xirfadlaha dhijitaalka', 'gur': 'ፍሪላንሰር / ዲጂታል ባለሙያ'});
  String get occupationStudent => _t({'en': 'Student', 'am': 'ተማሪ', 'ti': 'ተማሃራይ', 'om': 'Barataa', 'so': 'Arday', 'gur': 'ተማሪ'});
  String get occupationUnemployed => _t({'en': 'Unemployed', 'am': 'ሥራ-አጥ', 'ti': 'ስራ-ኣልቦ', 'om': 'Hojii-dhabu', 'so': 'Shaqo-la\'aan', 'gur': 'ሥራ-አጥ'});
  String get occupationRetired => _t({'en': 'Retired / Pensioner', 'am': 'ጡረተኛ', 'ti': 'ጡረተኛ', 'om': 'Jiraataa / Hawaasaa', 'so': 'Nasasho / Macaash-qaade', 'gur': 'ጡረተኛ'});
  String get occupationHomemaker => _t({'en': 'Homemaker', 'am': 'የቤት አስተዳዳሪ', 'ti': 'ምምሕዳር ገዛ', 'om': 'Bulchiinsa manaa', 'so': 'Maareeyaha guriga', 'gur': 'ቤት አስተዳዳሪ'});
  String get occupationNgo => _t({'en': 'NGO / International Organization Employee', 'am': 'NGO / ዓለምአቀፍ ድርጅት ሰራተኛ', 'ti': 'NGO / ዓለምለኻዊ ድርጅት', 'om': 'NGO / Hojjetaa dhaabbata addunyaa', 'so': 'NGO / Shaqaalaha Hay\'adda Caalamiga ah', 'gur': 'NGO / ዓለምአቀፍ ሠራተኛ'});
  String get wealthPersonalSavings => _t({'en': 'Personal Savings', 'am': 'ግል ቁጠባ', 'ti': 'ናጻ ቁጠባ', 'om': 'Qusannaa dhuunfaa', 'so': 'Kaydinta shakhsiga', 'gur': 'ግል ቁጠባ'});
  String get wealthInheritance => _t({'en': 'Inheritance', 'am': 'ውርስ', 'ti': 'ውርሲ', 'om': 'Dhaalaa', 'so': 'Dhaxal', 'gur': 'ውርስ'});
  String get wealthBusinessProfits => _t({'en': 'Business Profits', 'am': 'የንግድ ትርፍ', 'ti': 'ትርፊ ቢዝነስ', 'om': "Bu'aa bizinaasii", 'so': 'Faa\'iidada ganacsiga', 'gur': 'ንግድ ትርፍ'});
  String get wealthInvestmentReturns => _t({'en': 'Investment Returns / Dividends', 'am': 'ኢንቨስትመንት ትርፍ / ዲቪደንድ', 'ti': 'ትርፊ ኢንቨስትመንት / ዲቪደንድ', 'om': "Bu'aa invastimantii / Diiviidandii", 'so': 'Dakhliga maalgelinta / Labooyinka', 'gur': 'ኢንቨስትመንት ትርፍ'});
  String get wealthRealEstate => _t({'en': 'Real Estate / Property Sale', 'am': 'ሪል ኤስቴት / ንብረት ሽያጭ', 'ti': 'ሪል ኤስቴት / ሽያጥ ንብረት', 'om': 'Mana lafa / Gurgurtaa qabeenyaa', 'so': 'Dhul-guryaha / Iibka hantida', 'gur': 'ሪል ኤስቴት / ሽያጭ'});
  String get wealthGratuity => _t({'en': 'Gratuity / Severance Pay', 'am': 'ሸቦ / ካሳ ክፍያ', 'ti': 'ፍሉይ ክፍሊት / ካሳ', 'om': 'Kafaltii addaa / Kaasaa', 'so': 'Abaal-marin / Mushaharka dillaacidda', 'gur': 'ሸቦ / ካሳ'});
  String get wealthGiftFamily => _t({'en': 'Gift / Family Support', 'am': 'ስጦታ / ቤተሰብ ድጋፍ', 'ti': 'ህያብ / ድጋፍ ስድራቤት', 'om': 'Kennaa / Gargaarsa maatii', 'so': 'Hadiyad / Taageero qoyska', 'gur': 'ስጦታ / ቤተሰብ ድጋፍ'});
  String get fundsEmploymentIncome => _t({'en': 'Employment Income (Salary)', 'am': 'ሥራ ገቢ (ደሞዝ)', 'ti': 'ኣታዊ ስራሕ (ደሞዝ)', 'om': 'Galii hojii (Mindaa)', 'so': 'Dakhliga shaqada (Mushaharka)', 'gur': 'ሥራ ገቢ (ደሞዝ)'});
  String get fundsBusinessRevenue => _t({'en': 'Business Revenue', 'am': 'የንግድ ገቢ', 'ti': 'ኣታዊ ቢዝነስ', 'om': 'Galii bizinaasii', 'so': 'Dakhliga ganacsiga', 'gur': 'ንግድ ገቢ'});
  String get fundsSaleOfAssets => _t({'en': 'Sale of Assets', 'am': 'ንብረት ሽያጭ', 'ti': 'ሽያጥ ንብረታት', 'om': 'Gurgurtaa qabeenyaa', 'so': 'Iibka hantida', 'gur': 'ንብረት ሽያጭ'});
  String get fundsRemittances => _t({'en': 'Remittances (Diaspora Support)', 'am': 'ቅሬ ዲያስፖራ ድጋፍ', 'ti': 'ምስዳድ ፈሰስ (ዲያስፖራ ድጋፍ)', 'om': 'Ergaa maallaqaa (Gargaarsa Diasporaa)', 'so': 'Xawaaladaha (Taageerida Diaspora)', 'gur': 'ቅሬ ዲያስፖራ'});
  String get fundsGovernmentAllowance => _t({'en': 'Government Allowance / Pension', 'am': 'የመንግስት አበል / ጡረታ', 'ti': 'ወጻኢ መንግስቲ / ጡረታ', 'om': 'Murtee mootummaa / Jireenyaa', 'so': 'Tabarucaadka dowladda / Madaxbannaanida', 'gur': 'መንግስት አበል / ጡረታ'});
  String get fundsSavingsWithdrawal => _t({'en': 'Savings Withdrawal', 'am': 'ቁጠባ ወጪ', 'ti': 'ምስሓብ ቁጠባ', 'om': 'Baasuu qusannaa', 'so': 'Saarista kaydinta', 'gur': 'ቁጠባ ወጪ'});
  String get tradingPurposeLearning => _t({'en': 'Investing for Learning Purposes', 'am': 'ለትምህርት ዓላማ ኢንቨስት ማድረግ', 'ti': 'ኢንቨስትመንት ንዓላማ ትምህርቲ', 'om': 'Invastimantii kaayyoo baruuf', 'so': 'Maalgelinta ujeedada barashada', 'gur': 'ለትምህርት ዓላማ ኢንቨስት'});
  String get tradingPurposeLongTerm => _t({'en': 'Long-term Wealth Building', 'am': 'ረጅም ጊዜ ሀብት ግንባታ', 'ti': 'ርዝሓቱ ሃብቲ ህንፀት', 'om': 'Ijaarsa qabeenya yeroo dheeraa', 'so': 'Dhismaha hantida dheer ee waqtiga dheer', 'gur': 'ረጅም ጊዜ ሀብት ምስራት'});
  String get tradingPurposeInfrequent => _t({'en': 'Infrequent trading, when I see an opportunity', 'am': 'አልፎ አልፎ ንግድ፣ ዕድል ሲያዩ', 'ti': 'ዝሑሉ ምዝዛት ምርጫ ምስ ረኸቡ', 'om': 'Daldala yeroon yoo carraan argeetti', 'so': 'Ganacsi aan badnayn, markaan fursad arko', 'gur': 'አልፎ ንግድ ዕድል ሲያዩ'});
  String get tradingPurposeFrequent => _t({'en': 'Frequent trading focused on generating ongoing income', 'am': 'ቀጣይ ገቢ ለማዘጋጀት ተደጋጋሚ ንግድ', 'ti': 'ቀጻሊ ሃብቲ ንምርካብ ተደጋጋሚ ንግዲ', 'om': 'Daldala baayyee galii itti fufaaf', 'so': 'Ganacsi joogto ah oo diiwaanka dakhliga socda leh', 'gur': 'ቀጣይ ገቢ ለማዘጋጀት ተደጋጋሚ ንግድ'});
  String get tradingPurposePreserveCapital => _t({'en': 'Preserve capital', 'am': 'ካፒታል ጠብቅ', 'ti': 'ካፒታል ሓሉ', 'om': 'Kaappitaala tiksi', 'so': 'Ilaalin raasumaalka', 'gur': 'ካፒታል ጠብቅ'});
  String get tradingPurposeExploratory => _t({'en': 'Exploratory investing', 'am': 'አሳሽ ኢንቨስትመንት', 'ti': 'ናይ ምፍታሽ ኢንቨስትመንት', 'om': 'Invastimantii qormaataa', 'so': 'Maalgelin baadh-raac', 'gur': 'አሳሽ ኢንቨስትመንት'});

  // ─── Profile screen missing keys ─────────────────────────
  String get personalInformation => _t({'en': 'Personal Information', 'am': 'የግል መረጃ', 'ti': 'ናይ ውልቀ ሓበሬታ', 'om': 'Odeeffannoo dhuunfaa', 'so': 'Macluumaadka Shakhsiga', 'gur': 'ናይ ግለ ሓበሬታ'});
  String get subtitleStandardsCert => _t({'en': 'Standards & certification', 'am': 'ደረጃዎች እና ምስክርነት', 'ti': 'ደረጃታት ምስክርነት', 'om': 'Mallattoowwan fi ragaa', 'so': 'Heerarka & xaqiijinta', 'gur': 'ደረጃዎቸ ምስክርነት'});
  String get nationalBankLabel => _t({'en': 'National Bank', 'am': 'ብሔራዊ ባንክ', 'ti': 'ሃገራዊ ባንኪ', 'om': 'Baankii Biyyaalessaa', 'so': 'Bangiga Qaranka', 'gur': 'ሃገራዊ ባንኪ'});
  String get faqAndSupport => _t({'en': 'FAQ & Support', 'am': 'ጥ.ይ.ጠ. እና ድጋፍ', 'ti': 'ሕቶ ሓጋዚ', 'om': 'Gaaffilee fi deggersa', 'so': 'Su\'aalaha & Taageerada', 'gur': 'ጥ.ይ.ጠ. ድጋፍ'});
  String get tier1VerifiedStep => _t({'en': 'Tier 1 Verified', 'am': 'ደረጃ 1 ተረጋግጧል', 'ti': 'ደረጃ 1 ተረጋጊጹ', 'om': 'Sadarkaa 1 Mirkanaawe', 'so': 'Heer 1 La Xaqiijiyay', 'gur': 'ደረጃ 1 ተረጋግጧ'});
  String get kycInProgress => _t({'en': 'KYC Tier 1 — In Progress', 'am': 'KYC ደረጃ 1 — በሂደት', 'ti': 'KYC ደረጃ 1 — ኣብ ምክያድ', 'om': 'KYC Sadarkaa 1 — Adeemaa', 'so': 'KYC Heer 1 — Socda', 'gur': 'KYC ደረጃ 1 — ሂደት'});
  String get shariaAaoifi => _t({'en': 'Sharia (AAOIFI)', 'am': 'ሸሪዓ (AAOIFI)', 'ti': 'ሸሪዓ (AAOIFI)', 'om': "Shari'aa (AAOIFI)", 'so': 'Shariicada (AAOIFI)', 'gur': 'ሸሪዓ (AAOIFI)'});
  String get ribaFree => _t({'en': 'Riba-Free', 'am': 'ሪባ-ነጻ', 'ti': 'ሪባ-ናጻ', 'om': 'Riba-Bilisaa', 'so': 'Riba-Lacag la\'aanta', 'gur': 'ሪባ-ነጻ'});
  String get noShortSell => _t({'en': 'No Short Sell', 'am': 'አጭር ሽያጭ የለም', 'ti': 'ሓጺር ሽያጥ የልቦ', 'om': 'Gurgurtaa gabaabduu hin jiru', 'so': 'Ganacsiga Gaaban ma jiro', 'gur': 'አጭር ሽያጭ የለም'});

  // ─── Orders extras ────────────────────────────────────────
  String get pendingOrders => _t({'en': 'Pending orders awaiting fill', 'am': 'መሙላት የሚጠብቁ ትዕዛዞች', 'ti': 'መሙላእ ዝጽበዩ ትእዛዛት', 'om': 'Ajajamoo guuttamuu eegan', 'so': 'Dalabaadka sugaya buuxinta', 'gur': 'መሙላት የሚጠባ ትዕዛዞች'});
  String get noOpenOrders => _t({'en': 'No open orders', 'am': 'ክፍት ትዕዛዝ የለም', 'ti': 'ክፉት ትእዛዝ የልቦን', 'om': 'Ajaja banaa hin jiru', 'so': 'Ma jiraan dalabaad furan', 'gur': 'ክፉት ትዕዛዝ የለም'});
  String get noOpenOrdersDesc => _t({'en': "All your orders have been filled or cancelled. Tap any asset to place a new order.", 'am': 'ሁሉም ትዕዛዞችዎ ተሞልተዋል ወይም ተሰርዘዋል። አዲስ ትዕዛዝ ለመስጠት ማንኛውንም ንብረት ይጫኑ።', 'ti': 'ኩሉ ትእዛዛትኩም ተሞሊኦም ወይ ተሳርዞም ኣለዉ።', 'om': "Ajajawwan kee hundi guutamaniiru ykn haqamaniiru.", 'so': "Dhammaan dalabkaagu waa la buuxiyay ama la baajiyay.", 'gur': 'ሁሉ ትዕዛዞቸ ተሞልተዋ ወይ ተሰርዘዋ።'});

  // ─── Profile menu / Upgrade ────────────────────────────────
  String get upgrade => _t({'en': 'Upgrade', 'am': 'ማሻሻል', 'ti': 'ምሕዳስ', 'om': "Fooyya'iinsa", 'so': 'Kor u qaad', 'gur': 'ማሻሻ'});

  // ─── Invite Friends ────────────────────────────────────────
  String get endsInDays => _t({'en': 'Ends in 15 days', 'am': 'በ15 ቀናት ያበቃል', 'ti': 'ኣብ 15 መዓልታት ይውዳእ', 'om': 'Guyyaa 15 keessatti dhaabata', 'so': '15 maalmood ka dib waa dhamaan', 'gur': 'በ15 ቀናት ያበቃ'});
  String get earn500PerFriend => _t({'en': 'Earn 500 per friend', 'am': 'በጓደኛ 500 ያስገኛሉ', 'ti': 'ብዓርኪ 500 ኣታዊ ይኹን', 'om': 'Hiriyaa tokkoof 500 argadhu', 'so': 'Saaxiib walba 500 ka hel', 'gur': 'በጓደኛ 500 ያስገኛ'});
  String get yourFriendsHaveToDo => _t({'en': 'Your friends have to do', 'am': 'ጓደኞችዎ ሊያደርጉ ያለባቸው', 'ti': 'ኣዕሩኽትኹም ክገብሩ ዘለዎም', 'om': 'Hiriyoonni kee hojjechuu qabu', 'so': 'Waa in saaxiibadaadu sameeyaan', 'gur': 'ጓደኞቸ ሊያደርጉ ያለባቸው'});
  String get signUpWithLink => _t({'en': 'Sign up with your link', 'am': 'በሊንክዎ ይመዝገቡ', 'ti': 'ብሊንክኹም ተመዝገቡ', 'om': 'Liinkii keetiin galmaa\'i', 'so': 'Ku diiwaangaliso linkigaaga', 'gur': 'በሊንክዎ ይመዝገቡ'});
  String get verifyIdentity => _t({'en': 'And verify their identity', 'am': 'እና ማንነታቸውን ያረጋግጡ', 'ti': 'ከምኡውን መንነቶም የረጋግጹ', 'om': 'Eenyummaa isaanii mirkaneessuu', 'so': 'Oo aqoonsigooda xaqiijiya', 'gur': 'ማንነታቸውን ያረጋግጡ'});
  String get addMoneyToAccount => _t({'en': 'Add money to their account', 'am': 'ወደ ሂሳባቸው ገንዘብ ያክሉ', 'ti': 'ኣብ ሕሳቦም ገንዘብ ይውስኹ', 'om': 'Herrega isaaniitti maallaqa dabali', 'so': 'Lacag ku dar akoonkooda', 'gur': 'ወደ ሂሳባቸው ገንዘብ ያክሉ'});
  String get viaDebitOrBank => _t({'en': 'Via debit card or bank transfer', 'am': 'በዴቢት ካርድ ወይም በባንክ ዝውውር', 'ti': 'ብዴቢት ካርድ ወይ ብባንክ ምትሕልላፍ', 'om': 'Kaardii Debit ykn dabarsa baankii', 'so': 'Kaadhka Debit ama wareejinta bangiga', 'gur': 'በዴቢት ካርድ ወይ ባንክ ዝውውር'});
  String get make3TradeOrders => _t({'en': 'Make 3 trade orders of 1000 minimum each', 'am': '3 የንግድ ትዕዛዞችን እያንዳንዱ ከ1000 ጀምሮ ያድርጉ', 'ti': '3 ናይ ንግዲ ትእዛዛት ነፍሲወከፍ ካብ 1000 ጀሚሩ ግበሩ', 'om': 'Ajaja daldalaa 3 tokko tokko 1000 ol godhi', 'so': '3 dalab ganacsi oo mid walba ugu yaraan 1000 ah samee', 'gur': '3 የንግድ ትዕዛዞች እያንዳንዱ ከ1000 ጀምሮ ያድርጉ'});
  String get cashTxNotCount => _t({'en': "Some cash transactions, like to self and others bank account don't count", 'am': 'አንዳንድ የጥሬ ገንዘብ ግብይቶች፣ ለራስ እና ለሌላ ባንክ ሂሳብ አይቆጠሩም', 'ti': 'ገሊኦም ናይ ጥረ ገንዘብ ንግድታት፣ ንርእስኹምን ንኻልኦት ባንኪ ሕሳብን ኣይቑጸሩን', 'om': 'Daldalli maallaqa qarshii muraasni, ofiifi herrega baankii nama biraa hin lakkaa\'amu', 'so': 'Macaamil lacag-caddaan ah qaarkood, sida nafta iyo akoonnada bangi ee kale ma tirsanaan doonaan', 'gur': 'አንዳንድ የጥሬ ገንዘብ ግብይቶቸ ለራስ ለሌላ ባንክ ሂሳብ አይቆጠሩም'});
  String get pastInvites => _t({'en': 'Past invites', 'am': 'ያለፉ ግብዣዎች', 'ti': 'ዝሓለፉ ዕድመታት', 'om': 'Afeerraa darbe', 'so': 'Casuumaadyada hore', 'gur': 'ያለፉ ግብዣዎቸ'});
  String get getHelp => _t({'en': 'Get help', 'am': 'እርዳታ ያግኙ', 'ti': 'ሓገዝ ርኸቡ', 'om': 'Gargaarsa argadhu', 'so': 'Hel caawimaad', 'gur': 'እርዳታ ያግኙ'});
  String get inviteOfferTerms => _t({'en': 'offer end at each end of the month. Max 5 invites per month. T&C apply', 'am': 'ቅናሹ በወሩ መጨረሻ ያበቃል። በወር ቢበዛ 5 ግብዣዎች። ውሎች ይመለከታሉ', 'ti': 'ቅናሽ ኣብ መወዳእታ ወርሒ ይውዳእ። ኣብ ወርሒ ካብ 5 ዕድመታት ኣይበዝሕን። ውዕላት ይትግበሩ', 'om': 'Tajaajilli dhuma ji\'aa irratti dhaabata. Ji\'atti afeerraa 5 ol miti. Haalonni ni hojjetu', 'so': 'Dalacadda waxay dhamaaneysaa dhammaadka bisha. Ugu badnaan 5 casuumaad bishii. Shuruudo waa la dabaqayaa', 'gur': 'ቅናሹ በወሩ መጨረሻ ያበቃ። በወር ቢበዛ 5 ግብዣዎቸ።'});
  String get inviteFriendsButton => _t({'en': 'Invite friends', 'am': 'ጓደኞችን ይጋብዙ', 'ti': 'ኣዕሩኽ ዓድሙ', 'om': 'Hiriyoota afeeri', 'so': 'Casuun saaxiibada', 'gur': 'ጓደኞቸ ይጋብዙ'});
  String get inviteLinkCopied => _t({'en': 'Invite link copied — share with your friends!', 'am': 'የግብዣ ሊንክ ተቀድቷል — ለጓደኞችዎ ያጋሩ!', 'ti': 'ሊንክ ዕድመ ተቐዲሑ — ንኣዕሩኽትኹም ኣካፍሉ!', 'om': "Liinkii afeerraa garagalfameera — hiriyoota keetiif qoodi!", 'so': 'Linkiga casuumaadda waa la koobiyey — saaxiibadaada la wadaag!', 'gur': 'የግብዣ ሊንክ ተቀድቷ — ለጓደኞችዎ ያጋሩ!'});

  // ─── Learn screen ────────────────────────────────────────
  String get learnTradingBasics => _t({'en': 'Trading Basics', 'am': 'የንግድ መሰረታዊ ነገሮች', 'ti': 'መሰረታት ናይ ንግዲ', 'om': 'Bu\'uura Daldalaa', 'so': 'Aasaaska Ganacsiga', 'gur': 'የንግድ መሰረታዊ ነገሮቸ'});
  String get learnTradingBasicsDesc => _t({'en': 'Understand the fundamentals of commodity trading.', 'am': 'የእቃ ንግድ መሰረታዊ ነገሮችን ይረዱ።', 'ti': 'መሰረታት ናይ ንግዲ ኣቑሑ ተረድኡ።', 'om': 'Bu\'uura daldala oomishaa hubadhu.', 'so': 'Fahan aasaaska ganacsiga alaabta.', 'gur': 'የዕቃ ንግድ መሰረታዊ ነገሮቸ ይረዱ።'});
  String get learnShariaFinance => _t({'en': 'Sharia & Islamic Finance', 'am': 'ሸሪዓ እና እስላማዊ ፋይናንስ', 'ti': 'ሸሪዓ ከምኡውን እስላማዊ ፋይናንስ', 'om': "Shari'aa fi Faayinaansii Islaamaa", 'so': 'Shareecada & Maaliyadda Islaamiga', 'gur': 'ሸሪዓ እስላማዊ ፋይናንስ'});
  String get learnShariaFinanceDesc => _t({'en': 'Learn how AAOIFI screens halal investments.', 'am': 'AAOIFI እንዴት ሐላል ኢንቨስትመንቶችን እንደሚለይ ይማሩ።', 'ti': 'AAOIFI ብኸመይ ሓላል ኢንቨስትመንታት ከምዝፍትሽ ተምሃሩ።', 'om': 'AAOIFI akkaataa investimantii halaal itti adda baasu baradhu.', 'so': 'Baro sida AAOIFI uu u baaro maalgashiga halaal.', 'gur': 'AAOIFI እንዴት ሐላል ኢንቨስትመንቶቸ እንደሚለይ ይማሩ።'});
  String get learnCharts => _t({'en': 'Reading Charts', 'am': 'ቻርቶችን ማንበብ', 'ti': 'ቻርትታት ምንባብ', 'om': 'Caarttota Dubbisuu', 'so': 'Akhrinta Jaantusyada', 'gur': 'ቻርቶቸ ማንበብ'});
  String get learnChartsDesc => _t({'en': 'Master candlestick patterns and indicators.', 'am': 'የሻማ መልክ እና ጠቋሚዎችን ይምሩ።', 'ti': 'ኣቕሑ ሻምዕን ኣመልከቲታትን ኣጽንዑ።', 'om': "Hoodee kanaadiilii fi mallattoolee barii.", 'so': 'Sare u qaad qaababka kandalka iyo tilmaamayaasha.', 'gur': 'የሻማ መልክ ጠቋሚዎቸ ይምሩ።'});
  String get learnRiskMgmt => _t({'en': 'Risk Management', 'am': 'የአደጋ አስተዳደር', 'ti': 'ምሕደራ ሓደጋ', 'om': 'Bulchiinsa Balaa', 'so': 'Maaraynta Khatarta', 'gur': 'የአደጋ አስተዳደር'});
  String get learnRiskMgmtDesc => _t({'en': 'Protect your capital — diversification & position sizing.', 'am': 'ካፒታልዎን ይጠብቁ — ብዝሃነት እና የቦታ መጠን።', 'ti': 'ካፒታልኩም ሓልዉ — ብዙሕነትን መጠን ቦታን።', 'om': 'Kaappitaala kee tiksi — gargar baasuu fi guddina iddoo.', 'so': 'Ilaali raasumaalkaaga — kala duwanaansho & cabbirka jagada.', 'gur': 'ካፒታልዎ ይጠብቁ — ብዝሃነት የቦታ መጠን።'});
  String get learnEthiopianMarkets => _t({'en': 'Ethiopian Markets', 'am': 'የኢትዮጵያ ገበያዎች', 'ti': 'ናይ ኢትዮጵያ ዕዳጋታት', 'om': 'Gabaa Itoophiyaa', 'so': 'Suuqyada Itoobiya', 'gur': 'የኢትዮጵያ ገበያዎቸ'});
  String get learnEthiopianMarketsDesc => _t({'en': 'ECX, ESX, NBE — how local markets work.', 'am': 'ECX፣ ESX፣ NBE — የአገር ውስጥ ገበያዎች እንዴት እንደሚሰሩ።', 'ti': 'ECX፣ ESX፣ NBE — ናይ ሃገር ውሽጢ ዕዳጋታት ብኸመይ ከምዝሰርሑ።', 'om': 'ECX, ESX, NBE — gabaan biyya keessaa akkamiin akka hojjetu.', 'so': 'ECX, ESX, NBE — sida suuqyada gudaha u shaqeeyaan.', 'gur': 'ECX፣ ESX፣ NBE — የአገር ውስጥ ገበያዎቸ እንዴት እንደሚሰሩ።'});

  // ─── Inbox screen ────────────────────────────────────────
  String get markAllRead => _t({'en': 'Mark all read', 'am': 'ሁሉንም እንደተነበበ ምልክት አድርግ', 'ti': 'ኩሎም ከም ዝንበቡ ምልክት ግበር', 'om': 'Hunda dubbifame jedhi', 'so': 'Calaamadi dhammaan akhriyey', 'gur': 'ሁሉ እንደተነበበ ምልክት አድርግ'});
  String get markedAllRead => _t({'en': 'Marked all as read', 'am': 'ሁሉም እንደተነበበ ምልክት ተደርጓል', 'ti': 'ኩሎም ከም ዝንበቡ ተመልኪቶም', 'om': "Hundi dubbifameera jedhamee mallatteeffameera", 'so': 'Dhammaan waa la calaamadiyey akhriyey', 'gur': 'ሁሉ እንደተነበበ ምልክት ተደርጓ'});

  /// Multi-language translation helper.
  String _t(Map<String, String> translations) {
    return translations[locale.languageCode] ?? translations['en']!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'am', 'ti', 'om', 'so', 'gur'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}
