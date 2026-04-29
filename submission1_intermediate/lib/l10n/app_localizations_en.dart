// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titleApp => 'Story App';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get emptyData => 'No stories uploaded yet.';

  @override
  String get searchStory => 'Search story';

  @override
  String get newStory => 'New Story';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmDesc => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get loadingStory => 'Loading stories...';

  @override
  String get emptyStoryTitle => 'No stories yet';

  @override
  String get errorLoadStory => 'Failed to load stories';

  @override
  String get retry => 'Retry';

  @override
  String get addStoryTitle => 'Add story';

  @override
  String get choosePhoto => 'Please select a photo first';

  @override
  String get successUpload => 'Story uploaded successfully!';

  @override
  String get addLocation => 'Add Location';

  @override
  String get tapToPickLocation => 'Tap to pick a location on map';

  @override
  String get locationSaved => 'Coordinates saved. Tap to change.';

  @override
  String get uploading => 'Uploading...';

  @override
  String get uploadStory => 'Upload story';

  @override
  String get descStory => 'Story description';

  @override
  String get writeDescHint => 'Write your story here...';

  @override
  String get descEmptyError => 'Description cannot be empty';

  @override
  String get tipCardText => 'Ensure the photo is clear and the description well represents your story.';

  @override
  String get pickLocationTitle => 'Pick Location';

  @override
  String get selectedLocation => 'Selected Location';

  @override
  String get loadingAddress => 'Loading address...';

  @override
  String get addressText => 'Address:';

  @override
  String get addressUnknown => 'Unknown address';

  @override
  String get useThisLocation => 'Use This Location';

  @override
  String get registerTitle => 'Register Account';

  @override
  String get createAccount => 'Create New Account';

  @override
  String get registerSub => 'Fill in the details below to join.';

  @override
  String get fullName => 'Full Name';

  @override
  String get inputNameHint => 'Enter your name';

  @override
  String get nameEmptyError => 'Name is required';

  @override
  String get emailLabel => 'Email';

  @override
  String get inputEmailHint => 'Enter your email';

  @override
  String get emailEmptyError => 'Email is required';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Minimum 6 characters';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters';

  @override
  String get registerSuccess => 'Registration successful, please login';

  @override
  String get registerFailed => 'Registration failed, check connection or email';

  @override
  String get registerNow => 'Register Now';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get pickOrTakePhoto => 'Pick or take a photo';

  @override
  String get photoSelected => 'Photo selected';

  @override
  String get loginWelcomeTitle => 'Welcome';

  @override
  String get loginWelcomeSub => 'Login to start reading and sharing stories.';

  @override
  String get inputPasswordHint => 'Enter your password';

  @override
  String get loginFailed => 'Connection failed or invalid credentials';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get registerHere => 'Register here';

  @override
  String get detailStoryTitle => 'Story Detail';

  @override
  String get storyLocation => 'Story Location';

  @override
  String get addressNotFound => 'Address not found';

  @override
  String get addressNotAvailable => 'Address not available';

  @override
  String get minutesAgo => 'm ago';

  @override
  String get hoursAgo => 'h ago';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get daysAgo => 'd ago';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get noInternet => 'No internet connection. Please ensure you are connected to a network.';
}
