import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @titleApp.
  ///
  /// In en, this message translates to:
  /// **'Story App'**
  String get titleApp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @emptyData.
  ///
  /// In en, this message translates to:
  /// **'No stories uploaded yet.'**
  String get emptyData;

  /// No description provided for @searchStory.
  ///
  /// In en, this message translates to:
  /// **'Search story'**
  String get searchStory;

  /// No description provided for @newStory.
  ///
  /// In en, this message translates to:
  /// **'New Story'**
  String get newStory;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loadingStory.
  ///
  /// In en, this message translates to:
  /// **'Loading stories...'**
  String get loadingStory;

  /// No description provided for @emptyStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'No stories yet'**
  String get emptyStoryTitle;

  /// No description provided for @errorLoadStory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load stories'**
  String get errorLoadStory;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @addStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add story'**
  String get addStoryTitle;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Please select a photo first'**
  String get choosePhoto;

  /// No description provided for @successUpload.
  ///
  /// In en, this message translates to:
  /// **'Story uploaded successfully!'**
  String get successUpload;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get addLocation;

  /// No description provided for @tapToPickLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick a location on map'**
  String get tapToPickLocation;

  /// No description provided for @locationSaved.
  ///
  /// In en, this message translates to:
  /// **'Coordinates saved. Tap to change.'**
  String get locationSaved;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @uploadStory.
  ///
  /// In en, this message translates to:
  /// **'Upload story'**
  String get uploadStory;

  /// No description provided for @descStory.
  ///
  /// In en, this message translates to:
  /// **'Story description'**
  String get descStory;

  /// No description provided for @writeDescHint.
  ///
  /// In en, this message translates to:
  /// **'Write your story here...'**
  String get writeDescHint;

  /// No description provided for @descEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Description cannot be empty'**
  String get descEmptyError;

  /// No description provided for @tipCardText.
  ///
  /// In en, this message translates to:
  /// **'Ensure the photo is clear and the description well represents your story.'**
  String get tipCardText;

  /// No description provided for @pickLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick Location'**
  String get pickLocationTitle;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected Location'**
  String get selectedLocation;

  /// No description provided for @loadingAddress.
  ///
  /// In en, this message translates to:
  /// **'Loading address...'**
  String get loadingAddress;

  /// No description provided for @addressText.
  ///
  /// In en, this message translates to:
  /// **'Address:'**
  String get addressText;

  /// No description provided for @addressUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown address'**
  String get addressUnknown;

  /// No description provided for @useThisLocation.
  ///
  /// In en, this message translates to:
  /// **'Use This Location'**
  String get useThisLocation;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register Account'**
  String get registerTitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createAccount;

  /// No description provided for @registerSub.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details below to join.'**
  String get registerSub;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @inputNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get inputNameHint;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameEmptyError;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @inputEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get inputEmailHint;

  /// No description provided for @emailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailEmptyError;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get passwordHint;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthError;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful, please login'**
  String get registerSuccess;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed, check connection or email'**
  String get registerFailed;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @pickOrTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Pick or take a photo'**
  String get pickOrTakePhoto;

  /// No description provided for @photoSelected.
  ///
  /// In en, this message translates to:
  /// **'Photo selected'**
  String get photoSelected;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSub.
  ///
  /// In en, this message translates to:
  /// **'Login to start reading and sharing stories.'**
  String get loginWelcomeSub;

  /// No description provided for @inputPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get inputPasswordHint;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed or invalid credentials'**
  String get loginFailed;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @registerHere.
  ///
  /// In en, this message translates to:
  /// **'Register here'**
  String get registerHere;

  /// No description provided for @detailStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Story Detail'**
  String get detailStoryTitle;

  /// No description provided for @storyLocation.
  ///
  /// In en, this message translates to:
  /// **'Story Location'**
  String get storyLocation;

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get addressNotFound;

  /// No description provided for @addressNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Address not available'**
  String get addressNotAvailable;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'m ago'**
  String get minutesAgo;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'h ago'**
  String get hoursAgo;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'d ago'**
  String get daysAgo;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please ensure you are connected to a network.'**
  String get noInternet;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
