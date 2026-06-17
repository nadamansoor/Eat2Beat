// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Eat2Beat`
  String get appTitle {
    return Intl.message('Eat2Beat', name: 'appTitle', desc: '', args: []);
  }

  /// `Language Selection`
  String get languageSelection {
    return Intl.message(
      'Language Selection',
      name: 'languageSelection',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `العربية (Arabic)`
  String get arabic {
    return Intl.message('العربية (Arabic)', name: 'arabic', desc: '', args: []);
  }

  /// `My Account`
  String get myAccount {
    return Intl.message('My Account', name: 'myAccount', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Log out`
  String get logout {
    return Intl.message('Log out', name: 'logout', desc: '', args: []);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Theme Selection`
  String get themeSelection {
    return Intl.message(
      'Theme Selection',
      name: 'themeSelection',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message('Light Theme', name: 'lightTheme', desc: '', args: []);
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message('Dark Theme', name: 'darkTheme', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Offers`
  String get offers {
    return Intl.message('Offers', name: 'offers', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Back to restaurants`
  String get backToRestaurants {
    return Intl.message(
      'Back to restaurants',
      name: 'backToRestaurants',
      desc: '',
      args: [],
    );
  }

  /// `No meals found matching "{query}".`
  String noMealsFound(Object query) {
    return Intl.message(
      'No meals found matching "$query".',
      name: 'noMealsFound',
      desc: '',
      args: [query],
    );
  }

  /// `No meals available in this restaurant.`
  String get noMealsAvailable {
    return Intl.message(
      'No meals available in this restaurant.',
      name: 'noMealsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No recommendations found matching "{query}".`
  String noRecsFound(Object query) {
    return Intl.message(
      'No recommendations found matching "$query".',
      name: 'noRecsFound',
      desc: '',
      args: [query],
    );
  }

  /// `No recommendations available.`
  String get noRecsAvailable {
    return Intl.message(
      'No recommendations available.',
      name: 'noRecsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No restaurants found matching "{query}".`
  String noRestFound(Object query) {
    return Intl.message(
      'No restaurants found matching "$query".',
      name: 'noRestFound',
      desc: '',
      args: [query],
    );
  }

  /// `No restaurants available.`
  String get noRestAvailable {
    return Intl.message(
      'No restaurants available.',
      name: 'noRestAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No Favorites Found`
  String get noFavsFound {
    return Intl.message(
      'No Favorites Found',
      name: 'noFavsFound',
      desc: '',
      args: [],
    );
  }

  /// `No Favorites Yet`
  String get noFavsYet {
    return Intl.message(
      'No Favorites Yet',
      name: 'noFavsYet',
      desc: '',
      args: [],
    );
  }

  /// `No favorite meals match "{query}".`
  String noFavsMatch(Object query) {
    return Intl.message(
      'No favorite meals match "$query".',
      name: 'noFavsMatch',
      desc: '',
      args: [query],
    );
  }

  /// `Start exploring our menu and heart the dishes you love!`
  String get startExploring {
    return Intl.message(
      'Start exploring our menu and heart the dishes you love!',
      name: 'startExploring',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Please log in to view recommendations.`
  String get pleaseLoginRecs {
    return Intl.message(
      'Please log in to view recommendations.',
      name: 'pleaseLoginRecs',
      desc: '',
      args: [],
    );
  }

  /// `All Meals`
  String get allMeals {
    return Intl.message('All Meals', name: 'allMeals', desc: '', args: []);
  }

  /// `Recommended`
  String get recommended {
    return Intl.message('Recommended', name: 'recommended', desc: '', args: []);
  }

  /// `Restaurants`
  String get restaurants {
    return Intl.message('Restaurants', name: 'restaurants', desc: '', args: []);
  }

  /// `Top Rated`
  String get topRated {
    return Intl.message('Top Rated', name: 'topRated', desc: '', args: []);
  }

  /// `Favorites`
  String get favorites {
    return Intl.message('Favorites', name: 'favorites', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Profile saved successfully!`
  String get profileSaved {
    return Intl.message(
      'Profile saved successfully!',
      name: 'profileSaved',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Phone 2`
  String get phone2 {
    return Intl.message('Phone 2', name: 'phone2', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Turn Leftovers into\nOpportunities`
  String get onboardingTitle1 {
    return Intl.message(
      'Turn Leftovers into\nOpportunities',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Together, we can make a real impact.\nTurning leftover food into meaningful meals\nthat feed people, not landfills.`
  String get onboardingDesc1 {
    return Intl.message(
      'Together, we can make a real impact.\nTurning leftover food into meaningful meals\nthat feed people, not landfills.',
      name: 'onboardingDesc1',
      desc: '',
      args: [],
    );
  }

  /// `Save Meal, Save Money`
  String get onboardingTitle2 {
    return Intl.message(
      'Save Meal, Save Money',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy delicious meals at a lower price while\nhelping restaurants reduce food waste,\nIt's a win win.`
  String get onboardingDesc2 {
    return Intl.message(
      'Enjoy delicious meals at a lower price while\nhelping restaurants reduce food waste,\nIt\'s a win win.',
      name: 'onboardingDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Feed Hearts, Not Waste`
  String get onboardingTitle3 {
    return Intl.message(
      'Feed Hearts, Not Waste',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Reduce food waste by connecting surplus\nmeals with charities. Every act of giving\nbrings hope to someone's day.`
  String get onboardingDesc3 {
    return Intl.message(
      'Reduce food waste by connecting surplus\nmeals with charities. Every act of giving\nbrings hope to someone\'s day.',
      name: 'onboardingDesc3',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back! Glad\nto see you, Again!`
  String get welcomeBack {
    return Intl.message(
      'Welcome back! Glad\nto see you, Again!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email`
  String get enterEmail {
    return Intl.message(
      'Enter your Email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Or Login with`
  String get orLoginWith {
    return Intl.message(
      'Or Login with',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don’t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// ` Register Now`
  String get registerNow {
    return Intl.message(
      ' Register Now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// ` Login Now`
  String get loginNow {
    return Intl.message(' Login Now', name: 'loginNow', desc: '', args: []);
  }

  /// `by signing up, you agree to our`
  String get termsAgreementPrefix {
    return Intl.message(
      'by signing up, you agree to our',
      name: 'termsAgreementPrefix',
      desc: '',
      args: [],
    );
  }

  /// ` conditions `
  String get termsAgreementConditions {
    return Intl.message(
      ' conditions ',
      name: 'termsAgreementConditions',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get termsAgreementAnd {
    return Intl.message(' and ', name: 'termsAgreementAnd', desc: '', args: []);
  }

  /// `privacy policy of the app`
  String get termsAgreementPolicy {
    return Intl.message(
      'privacy policy of the app',
      name: 'termsAgreementPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Hello! Register to get\nstarted`
  String get registerHeader {
    return Intl.message(
      'Hello! Register to get\nstarted',
      name: 'registerHeader',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Restaurant Name`
  String get restaurantName {
    return Intl.message(
      'Restaurant Name',
      name: 'restaurantName',
      desc: '',
      args: [],
    );
  }

  /// `Owner Full Name`
  String get ownerFullName {
    return Intl.message(
      'Owner Full Name',
      name: 'ownerFullName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant Address`
  String get restaurantAddress {
    return Intl.message(
      'Restaurant Address',
      name: 'restaurantAddress',
      desc: '',
      args: [],
    );
  }

  /// `National ID`
  String get nationalId {
    return Intl.message('National ID', name: 'nationalId', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `User`
  String get userRole {
    return Intl.message('User', name: 'userRole', desc: '', args: []);
  }

  /// `Admin`
  String get adminRole {
    return Intl.message('Admin', name: 'adminRole', desc: '', args: []);
  }

  /// `Charity`
  String get charityRole {
    return Intl.message('Charity', name: 'charityRole', desc: '', args: []);
  }

  /// `Charity portal coming soon!`
  String get charityPortalSoon {
    return Intl.message(
      'Charity portal coming soon!',
      name: 'charityPortalSoon',
      desc: '',
      args: [],
    );
  }

  /// `Google Login is available for User role only`
  String get googleLoginUserOnly {
    return Intl.message(
      'Google Login is available for User role only',
      name: 'googleLoginUserOnly',
      desc: '',
      args: [],
    );
  }

  /// `you must accept the terms and conditions`
  String get acceptTermsFirst {
    return Intl.message(
      'you must accept the terms and conditions',
      name: 'acceptTermsFirst',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Don't worry! It occurs. Please enter the email address linked with your account.`
  String get forgotPasswordDesc {
    return Intl.message(
      'Don\'t worry! It occurs. Please enter the email address linked with your account.',
      name: 'forgotPasswordDesc',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `A password reset link has been sent to {email}. Please check your Gmail.`
  String resetLinkSent(Object email) {
    return Intl.message(
      'A password reset link has been sent to $email. Please check your Gmail.',
      name: 'resetLinkSent',
      desc: '',
      args: [email],
    );
  }

  /// `Remember Password ?`
  String get rememberPassword {
    return Intl.message(
      'Remember Password ?',
      name: 'rememberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Create New Password`
  String get createNewPasswordTitle {
    return Intl.message(
      'Create New Password',
      name: 'createNewPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your new password must be unique from those previously used.`
  String get createNewPasswordDesc {
    return Intl.message(
      'Your new password must be unique from those previously used.',
      name: 'createNewPasswordDesc',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password Required`
  String get passwordRequired {
    return Intl.message(
      'Password Required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordMinLength {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed Password doesn't match the previous`
  String get passwordsDontMatch {
    return Intl.message(
      'Confirmed Password doesn\'t match the previous',
      name: 'passwordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPasswordBtn {
    return Intl.message(
      'Reset Password',
      name: 'resetPasswordBtn',
      desc: '',
      args: [],
    );
  }

  /// `OTP Verification`
  String get otpVerificationTitle {
    return Intl.message(
      'OTP Verification',
      name: 'otpVerificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code we just sent to:\n{email}`
  String enterVerificationCode(Object email) {
    return Intl.message(
      'Enter the verification code we just sent to:\n$email',
      name: 'enterVerificationCode',
      desc: '',
      args: [email],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Please enter the complete 4-digit code`
  String get enterCompleteOtp {
    return Intl.message(
      'Please enter the complete 4-digit code',
      name: 'enterCompleteOtp',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive code ?`
  String get didntReceiveCode {
    return Intl.message(
      'Didn\'t receive code ?',
      name: 'didntReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message('Resend', name: 'resend', desc: '', args: []);
  }

  /// `New verification code sent: {code}`
  String newOtpSent(Object code) {
    return Intl.message(
      'New verification code sent: $code',
      name: 'newOtpSent',
      desc: '',
      args: [code],
    );
  }

  /// `Password Changed!`
  String get passwordChangedTitle {
    return Intl.message(
      'Password Changed!',
      name: 'passwordChangedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been\nchanged successfully.`
  String get passwordChangedDesc {
    return Intl.message(
      'Your password has been\nchanged successfully.',
      name: 'passwordChangedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login`
  String get backToLogin {
    return Intl.message(
      'Back to Login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update favorite: {error}`
  String failedToUpdateFavorite(Object error) {
    return Intl.message(
      'Failed to update favorite: $error',
      name: 'failedToUpdateFavorite',
      desc: '',
      args: [error],
    );
  }

  /// `Failed to update quantity: {error}`
  String failedUpdateQuantity(Object error) {
    return Intl.message(
      'Failed to update quantity: $error',
      name: 'failedUpdateQuantity',
      desc: '',
      args: [error],
    );
  }

  /// `Reordered successfully! Redirecting to Cart...`
  String get reorderedSuccess {
    return Intl.message(
      'Reordered successfully! Redirecting to Cart...',
      name: 'reorderedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to reorder: {error}`
  String failedReorder(Object error) {
    return Intl.message(
      'Failed to reorder: $error',
      name: 'failedReorder',
      desc: '',
      args: [error],
    );
  }

  /// `Order History`
  String get orderHistory {
    return Intl.message(
      'Order History',
      name: 'orderHistory',
      desc: '',
      args: [],
    );
  }

  /// `Time: All`
  String get orderTimeAll {
    return Intl.message('Time: All', name: 'orderTimeAll', desc: '', args: []);
  }

  /// `Today`
  String get orderToday {
    return Intl.message('Today', name: 'orderToday', desc: '', args: []);
  }

  /// `This Week`
  String get orderThisWeek {
    return Intl.message('This Week', name: 'orderThisWeek', desc: '', args: []);
  }

  /// `Status: All`
  String get statusAll {
    return Intl.message('Status: All', name: 'statusAll', desc: '', args: []);
  }

  /// `Pending`
  String get statusPending {
    return Intl.message('Pending', name: 'statusPending', desc: '', args: []);
  }

  /// `Preparing`
  String get statusPreparing {
    return Intl.message(
      'Preparing',
      name: 'statusPreparing',
      desc: '',
      args: [],
    );
  }

  /// `On the way`
  String get statusOnTheWay {
    return Intl.message(
      'On the way',
      name: 'statusOnTheWay',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get statusDelivered {
    return Intl.message(
      'Delivered',
      name: 'statusDelivered',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get statusCancelled {
    return Intl.message(
      'Cancelled',
      name: 'statusCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Go to Menu`
  String get goToMenu {
    return Intl.message('Go to Menu', name: 'goToMenu', desc: '', args: []);
  }

  /// `Ingredients`
  String get ingredients {
    return Intl.message('Ingredients', name: 'ingredients', desc: '', args: []);
  }

  /// `Reviews`
  String get reviews {
    return Intl.message('Reviews', name: 'reviews', desc: '', args: []);
  }

  /// `Please login to view your cart`
  String get pleaseLoginCart {
    return Intl.message(
      'Please login to view your cart',
      name: 'pleaseLoginCart',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is empty`
  String get cartEmpty {
    return Intl.message(
      'Your cart is empty',
      name: 'cartEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Add a coupon`
  String get addCoupon {
    return Intl.message('Add a coupon', name: 'addCoupon', desc: '', args: []);
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Delivery Charges`
  String get deliveryCharges {
    return Intl.message(
      'Delivery Charges',
      name: 'deliveryCharges',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Please login first to complete your order.`
  String get loginRequiredText {
    return Intl.message(
      'Please login first to complete your order.',
      name: 'loginRequiredText',
      desc: '',
      args: [],
    );
  }

  /// `Burger King`
  String get burgerKing {
    return Intl.message('Burger King', name: 'burgerKing', desc: '', args: []);
  }

  /// `Healthy Taco Salad`
  String get healthyTacoSalad {
    return Intl.message(
      'Healthy Taco Salad',
      name: 'healthyTacoSalad',
      desc: '',
      args: [],
    );
  }

  /// `Japanese-style Pancakes`
  String get japanesePancakes {
    return Intl.message(
      'Japanese-style Pancakes',
      name: 'japanesePancakes',
      desc: '',
      args: [],
    );
  }

  /// `Beef Burger`
  String get beefBurger {
    return Intl.message('Beef Burger', name: 'beefBurger', desc: '', args: []);
  }

  /// `Chicken Wrap`
  String get chickenWrap {
    return Intl.message(
      'Chicken Wrap',
      name: 'chickenWrap',
      desc: '',
      args: [],
    );
  }

  /// `Golden Box`
  String get goldenBox {
    return Intl.message('Golden Box', name: 'goldenBox', desc: '', args: []);
  }

  /// `35% OFF on\nBurgers at\nOMG!`
  String get banner1 {
    return Intl.message(
      '35% OFF on\nBurgers at\nOMG!',
      name: 'banner1',
      desc: '',
      args: [],
    );
  }

  /// `20% OFF on\nPizza Today`
  String get banner2 {
    return Intl.message(
      '20% OFF on\nPizza Today',
      name: 'banner2',
      desc: '',
      args: [],
    );
  }

  /// `Buy 1 Get 1\nFree Desserts`
  String get banner3 {
    return Intl.message(
      'Buy 1 Get 1\nFree Desserts',
      name: 'banner3',
      desc: '',
      args: [],
    );
  }

  /// `Healthy Taco Salad with fresh mixed vegetables.`
  String get tacoSaladDesc {
    return Intl.message(
      'Healthy Taco Salad with fresh mixed vegetables.',
      name: 'tacoSaladDesc',
      desc: '',
      args: [],
    );
  }

  /// `Soft mini pancakes served with honey and fresh fruits.`
  String get pancakesDesc {
    return Intl.message(
      'Soft mini pancakes served with honey and fresh fruits.',
      name: 'pancakesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Creamy avocado slices with fresh bread and light seasoning.`
  String get avocadoDesc {
    return Intl.message(
      'Creamy avocado slices with fresh bread and light seasoning.',
      name: 'avocadoDesc',
      desc: '',
      args: [],
    );
  }

  /// `Fresh vegetables mixed with light dressing for a healthy and refreshing taste.`
  String get vegetablesDesc {
    return Intl.message(
      'Fresh vegetables mixed with light dressing for a healthy and refreshing taste.',
      name: 'vegetablesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Tender grilled chicken wrapped with fresh veggies and soft bread.`
  String get chickenWrapDesc {
    return Intl.message(
      'Tender grilled chicken wrapped with fresh veggies and soft bread.',
      name: 'chickenWrapDesc',
      desc: '',
      args: [],
    );
  }

  /// `Delicious meal prepared with fresh ingredients.`
  String get placeholderDesc {
    return Intl.message(
      'Delicious meal prepared with fresh ingredients.',
      name: 'placeholderDesc',
      desc: '',
      args: [],
    );
  }

  /// `Your Points`
  String get pointsTitle {
    return Intl.message('Your Points', name: 'pointsTitle', desc: '', args: []);
  }

  /// `Popular Today`
  String get popularToday {
    return Intl.message(
      'Popular Today',
      name: 'popularToday',
      desc: '',
      args: [],
    );
  }

  /// `Login required to view offers`
  String get loginRequiredOffers {
    return Intl.message(
      'Login required to view offers',
      name: 'loginRequiredOffers',
      desc: '',
      args: [],
    );
  }

  /// `No offers available now`
  String get noOffersAvailable {
    return Intl.message(
      'No offers available now',
      name: 'noOffersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Special Offer`
  String get specialOffer {
    return Intl.message(
      'Special Offer',
      name: 'specialOffer',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load offers: {error}`
  String failedLoadOffers(Object error) {
    return Intl.message(
      'Failed to load offers: $error',
      name: 'failedLoadOffers',
      desc: '',
      args: [error],
    );
  }

  /// `20 Min`
  String get twentyMin {
    return Intl.message('20 Min', name: 'twentyMin', desc: '', args: []);
  }

  /// `Buy now`
  String get buyNow {
    return Intl.message('Buy now', name: 'buyNow', desc: '', args: []);
  }

  /// `Reviews are unavailable right now.`
  String get reviewsUnavailable {
    return Intl.message(
      'Reviews are unavailable right now.',
      name: 'reviewsUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Rating must be between 1 and 5.`
  String get ratingRangeError {
    return Intl.message(
      'Rating must be between 1 and 5.',
      name: 'ratingRangeError',
      desc: '',
      args: [],
    );
  }

  /// `Rating submitted successfully.`
  String get ratingSuccess {
    return Intl.message(
      'Rating submitted successfully.',
      name: 'ratingSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit rating: {error}`
  String ratingSubmitFailed(Object error) {
    return Intl.message(
      'Failed to submit rating: $error',
      name: 'ratingSubmitFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Login Required`
  String get loginRequired {
    return Intl.message(
      'Login Required',
      name: 'loginRequired',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Added to Cart (Qty: {qty})`
  String addedToCartQty(Object qty) {
    return Intl.message(
      'Added to Cart (Qty: $qty)',
      name: 'addedToCartQty',
      desc: '',
      args: [qty],
    );
  }

  /// `Failed to add to cart: {error}`
  String failedAddToCart(Object error) {
    return Intl.message(
      'Failed to add to cart: $error',
      name: 'failedAddToCart',
      desc: '',
      args: [error],
    );
  }

  /// `Update your rating`
  String get updateYourRating {
    return Intl.message(
      'Update your rating',
      name: 'updateYourRating',
      desc: '',
      args: [],
    );
  }

  /// `Rate this meal`
  String get rateThisMeal {
    return Intl.message(
      'Rate this meal',
      name: 'rateThisMeal',
      desc: '',
      args: [],
    );
  }

  /// `Choose a score from 1 to 5 and add an optional review.`
  String get rateInstructions {
    return Intl.message(
      'Choose a score from 1 to 5 and add an optional review.',
      name: 'rateInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Optional review...`
  String get optionalReview {
    return Intl.message(
      'Optional review...',
      name: 'optionalReview',
      desc: '',
      args: [],
    );
  }

  /// `Update Rating`
  String get updateRating {
    return Intl.message(
      'Update Rating',
      name: 'updateRating',
      desc: '',
      args: [],
    );
  }

  /// `Submit Rating`
  String get submitRating {
    return Intl.message(
      'Submit Rating',
      name: 'submitRating',
      desc: '',
      args: [],
    );
  }

  /// `Reviews are only available for online menu meals.`
  String get reviewsOnlyOnline {
    return Intl.message(
      'Reviews are only available for online menu meals.',
      name: 'reviewsOnlyOnline',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with a user account to view & write reviews.`
  String get signInToReview {
    return Intl.message(
      'Sign in with a user account to view & write reviews.',
      name: 'signInToReview',
      desc: '',
      args: [],
    );
  }

  /// `No reviews yet for this dish.`
  String get noReviewsYet {
    return Intl.message(
      'No reviews yet for this dish.',
      name: 'noReviewsYet',
      desc: '',
      args: [],
    );
  }

  /// `No written review provided.`
  String get noWrittenReview {
    return Intl.message(
      'No written review provided.',
      name: 'noWrittenReview',
      desc: '',
      args: [],
    );
  }

  /// `Add To Cart`
  String get addToCart {
    return Intl.message('Add To Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Order Now`
  String get orderNow {
    return Intl.message('Order Now', name: 'orderNow', desc: '', args: []);
  }

  /// `Login required to view history`
  String get loginRequiredHistory {
    return Intl.message(
      'Login required to view history',
      name: 'loginRequiredHistory',
      desc: '',
      args: [],
    );
  }

  /// `No Orders Yet`
  String get noOrdersYet {
    return Intl.message(
      'No Orders Yet',
      name: 'noOrdersYet',
      desc: '',
      args: [],
    );
  }

  /// `Hungry? Explore our menu and place your first order!`
  String get hungryExplore {
    return Intl.message(
      'Hungry? Explore our menu and place your first order!',
      name: 'hungryExplore',
      desc: '',
      args: [],
    );
  }

  /// `All orders loaded`
  String get allOrdersLoaded {
    return Intl.message(
      'All orders loaded',
      name: 'allOrdersLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Order ID: #{id}`
  String orderIdLabel(Object id) {
    return Intl.message(
      'Order ID: #$id',
      name: 'orderIdLabel',
      desc: '',
      args: [id],
    );
  }

  /// `Total: `
  String get totalLabel {
    return Intl.message('Total: ', name: 'totalLabel', desc: '', args: []);
  }

  /// `Reorder`
  String get reorder {
    return Intl.message('Reorder', name: 'reorder', desc: '', args: []);
  }

  /// `Failed to load order history: {error}`
  String failedLoadHistory(Object error) {
    return Intl.message(
      'Failed to load order history: $error',
      name: 'failedLoadHistory',
      desc: '',
      args: [error],
    );
  }

  /// `Please fill in your delivery details!`
  String get fillDeliveryDetails {
    return Intl.message(
      'Please fill in your delivery details!',
      name: 'fillDeliveryDetails',
      desc: '',
      args: [],
    );
  }

  /// `You must be logged in to place an order`
  String get loginToPlaceOrder {
    return Intl.message(
      'You must be logged in to place an order',
      name: 'loginToPlaceOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order Failed`
  String get orderFailed {
    return Intl.message(
      'Order Failed',
      name: 'orderFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to place order. Please try again.\n\n{error}`
  String failedPlaceOrder(Object error) {
    return Intl.message(
      'Failed to place order. Please try again.\n\n$error',
      name: 'failedPlaceOrder',
      desc: '',
      args: [error],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Place Order (Cash)`
  String get placeOrderCash {
    return Intl.message(
      'Place Order (Cash)',
      name: 'placeOrderCash',
      desc: '',
      args: [],
    );
  }

  /// `Place Order (Card)`
  String get placeOrderCard {
    return Intl.message(
      'Place Order (Card)',
      name: 'placeOrderCard',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Details`
  String get deliveryDetails {
    return Intl.message(
      'Delivery Details',
      name: 'deliveryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Enter your name`
  String get enterName {
    return Intl.message(
      'Enter your name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhone {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Street name, Building, Apartment`
  String get addressPlaceholder {
    return Intl.message(
      'Street name, Building, Apartment',
      name: 'addressPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your address`
  String get pleaseEnterAddress {
    return Intl.message(
      'Please enter your address',
      name: 'pleaseEnterAddress',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Area`
  String get area {
    return Intl.message('Area', name: 'area', desc: '', args: []);
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message('Cash', name: 'cash', desc: '', args: []);
  }

  /// `Card`
  String get card {
    return Intl.message('Card', name: 'card', desc: '', args: []);
  }

  /// `Card Number`
  String get cardNumber {
    return Intl.message('Card Number', name: 'cardNumber', desc: '', args: []);
  }

  /// `Expiry`
  String get expiry {
    return Intl.message('Expiry', name: 'expiry', desc: '', args: []);
  }

  /// `CVV`
  String get cvv {
    return Intl.message('CVV', name: 'cvv', desc: '', args: []);
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Thank You!`
  String get thankYou {
    return Intl.message('Thank You!', name: 'thankYou', desc: '', args: []);
  }

  /// `Your delicious meal is on its way.\nOrder ID: #{id}`
  String orderOnTheWay(Object id) {
    return Intl.message(
      'Your delicious meal is on its way.\nOrder ID: #$id',
      name: 'orderOnTheWay',
      desc: '',
      args: [id],
    );
  }

  /// `Our driver is on the way to pick up your meal!`
  String get driverOnTheWay {
    return Intl.message(
      'Our driver is on the way to pick up your meal!',
      name: 'driverOnTheWay',
      desc: '',
      args: [],
    );
  }

  /// `Track Order`
  String get trackOrder {
    return Intl.message('Track Order', name: 'trackOrder', desc: '', args: []);
  }

  /// `Chatbot`
  String get chatbot {
    return Intl.message('Chatbot', name: 'chatbot', desc: '', args: []);
  }

  /// `Type a message...`
  String get typeMessage {
    return Intl.message(
      'Type a message...',
      name: 'typeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please log in first to use the chatbot.`
  String get loginToUseChatbot {
    return Intl.message(
      'Please log in first to use the chatbot.',
      name: 'loginToUseChatbot',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get authentication token. Please try again.`
  String get failedGetToken {
    return Intl.message(
      'Failed to get authentication token. Please try again.',
      name: 'failedGetToken',
      desc: '',
      args: [],
    );
  }

  /// `Chat service error ({code}): {body}`
  String chatServiceError(Object code, Object body) {
    return Intl.message(
      'Chat service error ($code): $body',
      name: 'chatServiceError',
      desc: '',
      args: [code, body],
    );
  }

  /// `Hello! Welcome to EAT2Beat! 🍽️ How can I help you today?`
  String get botGreeting1 {
    return Intl.message(
      'Hello! Welcome to EAT2Beat! 🍽️ How can I help you today?',
      name: 'botGreeting1',
      desc: '',
      args: [],
    );
  }

  /// `Hi there! I'm your EAT2Beat assistant. What can I do for you?`
  String get botGreeting2 {
    return Intl.message(
      'Hi there! I\'m your EAT2Beat assistant. What can I do for you?',
      name: 'botGreeting2',
      desc: '',
      args: [],
    );
  }

  /// `You can view our full menu by navigating to the Home tab. We have delicious organic meals! 🥗`
  String get botMenu1 {
    return Intl.message(
      'You can view our full menu by navigating to the Home tab. We have delicious organic meals! 🥗',
      name: 'botMenu1',
      desc: '',
      args: [],
    );
  }

  /// `Check out our Menu section for a variety of healthy, freshly prepared meals.`
  String get botMenu2 {
    return Intl.message(
      'Check out our Menu section for a variety of healthy, freshly prepared meals.',
      name: 'botMenu2',
      desc: '',
      args: [],
    );
  }

  /// `To place an order, browse our menu and add items to your cart, then proceed to checkout! 🛒`
  String get botOrder1 {
    return Intl.message(
      'To place an order, browse our menu and add items to your cart, then proceed to checkout! 🛒',
      name: 'botOrder1',
      desc: '',
      args: [],
    );
  }

  /// `Ordering is easy! Just add items to your cart and we'll deliver within 30 minutes.`
  String get botOrder2 {
    return Intl.message(
      'Ordering is easy! Just add items to your cart and we\'ll deliver within 30 minutes.',
      name: 'botOrder2',
      desc: '',
      args: [],
    );
  }

  /// `We deliver in 30 minutes or less! 🚀 Our delivery team works 24/7.`
  String get botDelivery1 {
    return Intl.message(
      'We deliver in 30 minutes or less! 🚀 Our delivery team works 24/7.',
      name: 'botDelivery1',
      desc: '',
      args: [],
    );
  }

  /// `Fast delivery is our specialty. Expect your food hot and fresh in about 30 minutes.`
  String get botDelivery2 {
    return Intl.message(
      'Fast delivery is our specialty. Expect your food hot and fresh in about 30 minutes.',
      name: 'botDelivery2',
      desc: '',
      args: [],
    );
  }

  /// `We partner with local NGOs to donate surplus food. Visit our Donation tab to learn more! 💝`
  String get botCharity1 {
    return Intl.message(
      'We partner with local NGOs to donate surplus food. Visit our Donation tab to learn more! 💝',
      name: 'botCharity1',
      desc: '',
      args: [],
    );
  }

  /// `EAT2Beat is committed to reducing food waste. Check out our Donation section.`
  String get botCharity2 {
    return Intl.message(
      'EAT2Beat is committed to reducing food waste. Check out our Donation section.',
      name: 'botCharity2',
      desc: '',
      args: [],
    );
  }

  /// `We accept all major credit cards, PayPal, and cash on delivery. 💳`
  String get botPayment1 {
    return Intl.message(
      'We accept all major credit cards, PayPal, and cash on delivery. 💳',
      name: 'botPayment1',
      desc: '',
      args: [],
    );
  }

  /// `Multiple payment options available: Credit Card, PayPal, or Cash on Delivery.`
  String get botPayment2 {
    return Intl.message(
      'Multiple payment options available: Credit Card, PayPal, or Cash on Delivery.',
      name: 'botPayment2',
      desc: '',
      args: [],
    );
  }

  /// `You can reach us at support@eat2beat.com or call 1-800-EAT2BEAT. 📞`
  String get botContact1 {
    return Intl.message(
      'You can reach us at support@eat2beat.com or call 1-800-EAT2BEAT. 📞',
      name: 'botContact1',
      desc: '',
      args: [],
    );
  }

  /// `Need help? Contact our support team via email or phone!`
  String get botContact2 {
    return Intl.message(
      'Need help? Contact our support team via email or phone!',
      name: 'botContact2',
      desc: '',
      args: [],
    );
  }

  /// `We're open 24/7! Order anytime, we're always here to serve you. ⏰`
  String get botHours1 {
    return Intl.message(
      'We\'re open 24/7! Order anytime, we\'re always here to serve you. ⏰',
      name: 'botHours1',
      desc: '',
      args: [],
    );
  }

  /// `EAT2Beat never sleeps! Place your order any time, day or night.`
  String get botHours2 {
    return Intl.message(
      'EAT2Beat never sleeps! Place your order any time, day or night.',
      name: 'botHours2',
      desc: '',
      args: [],
    );
  }

  /// `You're welcome! Is there anything else I can help with? 😊`
  String get botThanks1 {
    return Intl.message(
      'You\'re welcome! Is there anything else I can help with? 😊',
      name: 'botThanks1',
      desc: '',
      args: [],
    );
  }

  /// `Happy to help! Let me know if you need anything else!`
  String get botThanks2 {
    return Intl.message(
      'Happy to help! Let me know if you need anything else!',
      name: 'botThanks2',
      desc: '',
      args: [],
    );
  }

  /// `I'm not sure I understand. Try asking about our menu, orders, delivery, or charity work. 🤖`
  String get botDefault1 {
    return Intl.message(
      'I\'m not sure I understand. Try asking about our menu, orders, delivery, or charity work. 🤖',
      name: 'botDefault1',
      desc: '',
      args: [],
    );
  }

  /// `I can help with questions about menu, ordering, delivery, charity, and more. What would you like to know?`
  String get botDefault2 {
    return Intl.message(
      'I can help with questions about menu, ordering, delivery, charity, and more. What would you like to know?',
      name: 'botDefault2',
      desc: '',
      args: [],
    );
  }

  /// `The restaurant is currently closed or not accepting orders.`
  String get closedOrNotAccepting {
    return Intl.message(
      'The restaurant is currently closed or not accepting orders.',
      name: 'closedOrNotAccepting',
      desc: '',
      args: [],
    );
  }

  /// `Ordering is paused.`
  String get orderingPaused {
    return Intl.message(
      'Ordering is paused.',
      name: 'orderingPaused',
      desc: '',
      args: [],
    );
  }

  /// `Ordering is paused: {reason}.`
  String orderingPausedWithReason(Object reason) {
    return Intl.message(
      'Ordering is paused: $reason.',
      name: 'orderingPausedWithReason',
      desc: '',
      args: [reason],
    );
  }

  /// `This mock meal cannot be ordered.`
  String get mockMealError {
    return Intl.message(
      'This mock meal cannot be ordered.',
      name: 'mockMealError',
      desc: '',
      args: [],
    );
  }

  /// `Not orderable`
  String get notOrderable {
    return Intl.message(
      'Not orderable',
      name: 'notOrderable',
      desc: '',
      args: [],
    );
  }

  /// `Open Now`
  String get openNow {
    return Intl.message('Open Now', name: 'openNow', desc: '', args: []);
  }

  /// `Paused`
  String get paused {
    return Intl.message('Paused', name: 'paused', desc: '', args: []);
  }

  /// `Closed now`
  String get closedNow {
    return Intl.message('Closed now', name: 'closedNow', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
