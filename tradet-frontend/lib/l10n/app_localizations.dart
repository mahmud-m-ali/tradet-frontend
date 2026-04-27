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
  String get assetsTracked => _t({'en': 'assets tracked', 'am': 'ንብረቶች ይከታተላሉ', 'ti': 'ትካላት ይስዓቡ', 'om': 'qabeenya hordofame', 'so': 'hantiwadaag la socdo', 'gur': 'ንብረቶች ይከታተላሉ'});
  String get capitalAtRisk => _t({'en': 'Capital at Risk', 'am': 'ተጋላጭ ካፒታል', 'ti': 'ኣብ ሓደጋ ዘሎ ካፒታል', 'om': 'Kaappitaala Gaaga Jiru', 'so': 'Maalgelin Khatar', 'gur': 'ተጋላጭ ካፒታል'});
  String get transactions => _t({'en': 'Transactions', 'am': 'ግብይቶች', 'ti': 'ምትሕልላፍ', 'om': 'Hojii Mallaqa', 'so': 'Macaamilaadaha', 'gur': 'ግብይቶች'});
  String get viewHistory => _t({'en': 'View history', 'am': 'ታሪክ ይመልከቱ', 'ti': 'ታሪኽ ርአ', 'om': 'Seenaa ilaalee', 'so': 'Taariikhda eeg', 'gur': 'ታሪክ ይመልከቱ'});

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
  String get limitOrderPlaced => _t({'en': 'Limit order placed (pending fill)', 'am': 'ሊሚት ትዕዛዝ ተቀምጧል (በመጠባበቅ ላይ)', 'ti': 'ሊሚት ትእዛዝ ተቐሚጡ (ይጽበ ኣሎ)', 'om': "Ajajni daangaa kaa'ameera (guutamuu eega)", 'so': 'Dalabka xadku waa la dhigay (sugitaanka)', 'gur': 'የገደብ ትእዛዝ ተቀምጧል (ይጠብቃል)'});
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

  // ─── Alerts ──────────────────────────────────────
  String get priceAlertsTitle => _t({'en': 'Price Alerts', 'am': 'የዋጋ ማንቂያ', 'ti': 'ናይ ዋጋ መጠንቀቕታ', 'om': 'Beeksisa gatii', 'so': 'Digniinta qiimaha', 'gur': 'የዋጋ ማስጠንቀቂያ'});
  String get createPriceAlert => _t({'en': 'Create Price Alert', 'am': 'የዋጋ ማንቂያ ይፍጠሩ', 'ti': 'ናይ ዋጋ መጠንቀቕታ ፍጠር', 'om': 'Beeksisa gatii uumi', 'so': 'Samee digniinta qiimaha', 'gur': 'የዋጋ ማስጠንቀቂያ ፍጠር'});
  String get targetPrice => _t({'en': 'Target Price (ETB)', 'am': 'ዒላማ ዋጋ (ETB)', 'ti': 'ዒላማ ዋጋ (ETB)', 'om': 'Gatii xiyyeeffannoo (ETB)', 'so': 'Bartilmaameedka qiimaha (ETB)', 'gur': 'ዒላማ ዋጋ (ETB)'});
  String get above => _t({'en': 'Above', 'am': 'በላይ', 'ti': 'ልዕሊ', 'om': 'Ol', 'so': 'Kor', 'gur': 'በላይ'});
  String get below => _t({'en': 'Below', 'am': 'በታች', 'ti': 'ታሕቲ', 'om': 'Gadi', 'so': 'Hoos', 'gur': 'በታች'});
  String get create => _t({'en': 'Create', 'am': 'ፍጠር', 'ti': 'ፍጠር', 'om': 'Uumi', 'so': 'Samee', 'gur': 'ፍጠር'});
  String get triggered => _t({'en': 'Triggered', 'am': 'ተቀስቅሷል', 'ti': 'ተቐሲቑ', 'om': "Ka'eera", 'so': 'Waa shaqeeyay', 'gur': 'ተነሳስቷል'});
  String get activeAlerts => _t({'en': 'Active Alerts', 'am': 'ንቁ ማንቂያዎች', 'ti': 'ንጡፋት መጠንቀቕታታት', 'om': 'Beeksisota hojii irra jiran', 'so': 'Digniinaha firfircoon', 'gur': 'ንቁ ማስጠንቀቂያዎች'});
  String get noAlertsYet => _t({'en': 'No alerts yet', 'am': 'ገና ማንቂያ የለም', 'ti': 'ገና መጠንቀቕታ የለን', 'om': 'Hanga ammaatti beeksisni hin jiru', 'so': 'Wali digniin ma jirto', 'gur': 'ገና ማስጠንቀቂያ የለም'});

  // ─── News ────────────────────────────────────────
  String get newsFeedTitle => _t({'en': 'News Feed', 'am': 'ዜና', 'ti': 'ዜና', 'om': 'Oduu', 'so': 'Wararka', 'gur': 'ዜና'});
  String get ethiopia => _t({'en': 'Ethiopia', 'am': 'ኢትዮጵያ', 'ti': 'ኢትዮጵያ', 'om': 'Itoophiyaa', 'so': 'Itoobiya', 'gur': 'ኢትዮጵያ'});
  String get islamicFinance => _t({'en': 'Islamic Finance', 'am': 'እስላማዊ ፋይናንስ', 'ti': 'ኢስላማዊ ፋይናንስ', 'om': 'Faayinaansii Islaamaa', 'so': 'Maaliyadda Islaamiga', 'gur': 'ኢስላማዊ ፋይናንስ'});
  String get global => _t({'en': 'Global', 'am': 'ዓለም አቀፍ', 'ti': 'ዓለምለኻዊ', 'om': 'Addunyaa', 'so': 'Caalamiga', 'gur': 'ዓለም አቀፍ'});
  String get noNewsAvailable => _t({'en': 'No news available', 'am': 'ዜና የለም', 'ti': 'ዜና የለን', 'om': 'Oduun hin argamne', 'so': 'War la heli maayo', 'gur': 'ዜና የለም'});

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

  // ─── Converter ───────────────────────────────────
  String get currencyConverter => _t({'en': 'Currency Converter', 'am': 'የምንዛሬ መቀየሪያ', 'ti': 'መቐየሪ ምንዛሬ', 'om': 'Jijjiirtuu maallaqaa', 'so': 'Beddelka lacagta', 'gur': 'የምንዛሬ መቀየሪያ'});
  String get enterAmount => _t({'en': 'Enter amount', 'am': 'መጠን ያስገቡ', 'ti': 'መጠን ኣእቱ', 'om': 'Hanga galchi', 'so': 'Geli qadarka', 'gur': 'መጠን አግባ'});
  String get nbeExchangeRates => _t({'en': 'NBE Exchange Rates', 'am': 'የኤንቢኢ ምንዛሬ', 'ti': 'ናይ NBE ምንዛሬ', 'om': 'Gatii jijjiirraa NBE', 'so': 'Sicirka sarrifka NBE', 'gur': 'የNBE ምንዛሬ'});
  String get currency => _t({'en': 'Currency', 'am': 'ምንዛሬ', 'ti': 'ምንዛሬ', 'om': 'Maallaqa', 'so': 'Lacagta', 'gur': 'ምንዛሬ'});
  String get noRatesAvailable => _t({'en': 'No rates available', 'am': 'ምንዛሬ የለም', 'ti': 'ምንዛሬ የለን', 'om': 'Gatiin hin argamne', 'so': 'Sicir la heli maayo', 'gur': 'ምንዛሬ የለም'});

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
