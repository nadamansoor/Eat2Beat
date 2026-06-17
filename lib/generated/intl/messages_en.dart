// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(qty) => "Added to Cart (Qty: ${qty})";

  static String m1(code, body) => "Chat service error (${code}): ${body}";

  static String m2(email) =>
      "Enter the verification code we just sent to:\n${email}";

  static String m3(error) => "Failed to add to cart: ${error}";

  static String m4(error) => "Failed to load order history: ${error}";

  static String m5(error) => "Failed to load offers: ${error}";

  static String m6(error) =>
      "Failed to place order. Please try again.\n\n${error}";

  static String m7(error) => "Failed to reorder: ${error}";

  static String m8(error) => "Failed to update favorite: ${error}";

  static String m9(error) => "Failed to update quantity: ${error}";

  static String m10(code) => "New verification code sent: ${code}";

  static String m11(query) => "No favorite meals match \"${query}\".";

  static String m12(query) => "No meals found matching \"${query}\".";

  static String m13(query) => "No recommendations found matching \"${query}\".";

  static String m14(query) => "No restaurants found matching \"${query}\".";

  static String m15(id) => "Order ID: #${id}";

  static String m16(id) =>
      "Your delicious meal is on its way.\nOrder ID: #${id}";

  static String m17(reason) => "Ordering is paused: ${reason}.";

  static String m18(error) => "Failed to submit rating: ${error}";

  static String m19(email) =>
      "A password reset link has been sent to ${email}. Please check your Gmail.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "acceptTermsFirst": MessageLookupByLibrary.simpleMessage(
      "you must accept the terms and conditions",
    ),
    "addCoupon": MessageLookupByLibrary.simpleMessage("Add a coupon"),
    "addToCart": MessageLookupByLibrary.simpleMessage("Add To Cart"),
    "addedToCartQty": m0,
    "addressPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Street name, Building, Apartment",
    ),
    "adminRole": MessageLookupByLibrary.simpleMessage("Admin"),
    "allMeals": MessageLookupByLibrary.simpleMessage("All Meals"),
    "allOrdersLoaded": MessageLookupByLibrary.simpleMessage(
      "All orders loaded",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Eat2Beat"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية (Arabic)"),
    "area": MessageLookupByLibrary.simpleMessage("Area"),
    "avocadoDesc": MessageLookupByLibrary.simpleMessage(
      "Creamy avocado slices with fresh bread and light seasoning.",
    ),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to Login"),
    "backToRestaurants": MessageLookupByLibrary.simpleMessage(
      "Back to restaurants",
    ),
    "banner1": MessageLookupByLibrary.simpleMessage(
      "35% OFF on\nBurgers at\nOMG!",
    ),
    "banner2": MessageLookupByLibrary.simpleMessage("20% OFF on\nPizza Today"),
    "banner3": MessageLookupByLibrary.simpleMessage(
      "Buy 1 Get 1\nFree Desserts",
    ),
    "beefBurger": MessageLookupByLibrary.simpleMessage("Beef Burger"),
    "botCharity1": MessageLookupByLibrary.simpleMessage(
      "We partner with local NGOs to donate surplus food. Visit our Donation tab to learn more! 💝",
    ),
    "botCharity2": MessageLookupByLibrary.simpleMessage(
      "EAT2Beat is committed to reducing food waste. Check out our Donation section.",
    ),
    "botContact1": MessageLookupByLibrary.simpleMessage(
      "You can reach us at support@eat2beat.com or call 1-800-EAT2BEAT. 📞",
    ),
    "botContact2": MessageLookupByLibrary.simpleMessage(
      "Need help? Contact our support team via email or phone!",
    ),
    "botDefault1": MessageLookupByLibrary.simpleMessage(
      "I\'m not sure I understand. Try asking about our menu, orders, delivery, or charity work. 🤖",
    ),
    "botDefault2": MessageLookupByLibrary.simpleMessage(
      "I can help with questions about menu, ordering, delivery, charity, and more. What would you like to know?",
    ),
    "botDelivery1": MessageLookupByLibrary.simpleMessage(
      "We deliver in 30 minutes or less! 🚀 Our delivery team works 24/7.",
    ),
    "botDelivery2": MessageLookupByLibrary.simpleMessage(
      "Fast delivery is our specialty. Expect your food hot and fresh in about 30 minutes.",
    ),
    "botGreeting1": MessageLookupByLibrary.simpleMessage(
      "Hello! Welcome to EAT2Beat! 🍽️ How can I help you today?",
    ),
    "botGreeting2": MessageLookupByLibrary.simpleMessage(
      "Hi there! I\'m your EAT2Beat assistant. What can I do for you?",
    ),
    "botHours1": MessageLookupByLibrary.simpleMessage(
      "We\'re open 24/7! Order anytime, we\'re always here to serve you. ⏰",
    ),
    "botHours2": MessageLookupByLibrary.simpleMessage(
      "EAT2Beat never sleeps! Place your order any time, day or night.",
    ),
    "botMenu1": MessageLookupByLibrary.simpleMessage(
      "You can view our full menu by navigating to the Home tab. We have delicious organic meals! 🥗",
    ),
    "botMenu2": MessageLookupByLibrary.simpleMessage(
      "Check out our Menu section for a variety of healthy, freshly prepared meals.",
    ),
    "botOrder1": MessageLookupByLibrary.simpleMessage(
      "To place an order, browse our menu and add items to your cart, then proceed to checkout! 🛒",
    ),
    "botOrder2": MessageLookupByLibrary.simpleMessage(
      "Ordering is easy! Just add items to your cart and we\'ll deliver within 30 minutes.",
    ),
    "botPayment1": MessageLookupByLibrary.simpleMessage(
      "We accept all major credit cards, PayPal, and cash on delivery. 💳",
    ),
    "botPayment2": MessageLookupByLibrary.simpleMessage(
      "Multiple payment options available: Credit Card, PayPal, or Cash on Delivery.",
    ),
    "botThanks1": MessageLookupByLibrary.simpleMessage(
      "You\'re welcome! Is there anything else I can help with? 😊",
    ),
    "botThanks2": MessageLookupByLibrary.simpleMessage(
      "Happy to help! Let me know if you need anything else!",
    ),
    "burgerKing": MessageLookupByLibrary.simpleMessage("Burger King"),
    "buyNow": MessageLookupByLibrary.simpleMessage("Buy now"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "card": MessageLookupByLibrary.simpleMessage("Card"),
    "cardNumber": MessageLookupByLibrary.simpleMessage("Card Number"),
    "cart": MessageLookupByLibrary.simpleMessage("Cart"),
    "cartEmpty": MessageLookupByLibrary.simpleMessage("Your cart is empty"),
    "cash": MessageLookupByLibrary.simpleMessage("Cash"),
    "charityPortalSoon": MessageLookupByLibrary.simpleMessage(
      "Charity portal coming soon!",
    ),
    "charityRole": MessageLookupByLibrary.simpleMessage("Charity"),
    "chatServiceError": m1,
    "chatbot": MessageLookupByLibrary.simpleMessage("Chatbot"),
    "checkout": MessageLookupByLibrary.simpleMessage("Checkout"),
    "chickenWrap": MessageLookupByLibrary.simpleMessage("Chicken Wrap"),
    "chickenWrapDesc": MessageLookupByLibrary.simpleMessage(
      "Tender grilled chicken wrapped with fresh veggies and soft bread.",
    ),
    "city": MessageLookupByLibrary.simpleMessage("City"),
    "closedNow": MessageLookupByLibrary.simpleMessage("Closed now"),
    "closedOrNotAccepting": MessageLookupByLibrary.simpleMessage(
      "The restaurant is currently closed or not accepting orders.",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "createNewPasswordDesc": MessageLookupByLibrary.simpleMessage(
      "Your new password must be unique from those previously used.",
    ),
    "createNewPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Create New Password",
    ),
    "cvv": MessageLookupByLibrary.simpleMessage("CVV"),
    "darkTheme": MessageLookupByLibrary.simpleMessage("Dark Theme"),
    "deliveryAddress": MessageLookupByLibrary.simpleMessage("Delivery Address"),
    "deliveryCharges": MessageLookupByLibrary.simpleMessage("Delivery Charges"),
    "deliveryDetails": MessageLookupByLibrary.simpleMessage("Delivery Details"),
    "didntReceiveCode": MessageLookupByLibrary.simpleMessage(
      "Didn\'t receive code ?",
    ),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don’t have an account?",
    ),
    "driverOnTheWay": MessageLookupByLibrary.simpleMessage(
      "Our driver is on the way to pick up your meal!",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterCompleteOtp": MessageLookupByLibrary.simpleMessage(
      "Please enter the complete 4-digit code",
    ),
    "enterEmail": MessageLookupByLibrary.simpleMessage("Enter your Email"),
    "enterName": MessageLookupByLibrary.simpleMessage("Enter your name"),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Enter phone number",
    ),
    "enterVerificationCode": m2,
    "expiry": MessageLookupByLibrary.simpleMessage("Expiry"),
    "failedAddToCart": m3,
    "failedGetToken": MessageLookupByLibrary.simpleMessage(
      "Failed to get authentication token. Please try again.",
    ),
    "failedLoadHistory": m4,
    "failedLoadOffers": m5,
    "failedPlaceOrder": m6,
    "failedReorder": m7,
    "failedToUpdateFavorite": m8,
    "failedUpdateQuantity": m9,
    "favorites": MessageLookupByLibrary.simpleMessage("Favorites"),
    "fillDeliveryDetails": MessageLookupByLibrary.simpleMessage(
      "Please fill in your delivery details!",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "forgotPasswordDesc": MessageLookupByLibrary.simpleMessage(
      "Don\'t worry! It occurs. Please enter the email address linked with your account.",
    ),
    "forgotPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Forgot Password?",
    ),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "goToMenu": MessageLookupByLibrary.simpleMessage("Go to Menu"),
    "goldenBox": MessageLookupByLibrary.simpleMessage("Golden Box"),
    "googleLoginUserOnly": MessageLookupByLibrary.simpleMessage(
      "Google Login is available for User role only",
    ),
    "healthyTacoSalad": MessageLookupByLibrary.simpleMessage(
      "Healthy Taco Salad",
    ),
    "hello": MessageLookupByLibrary.simpleMessage("Hello"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "hungryExplore": MessageLookupByLibrary.simpleMessage(
      "Hungry? Explore our menu and place your first order!",
    ),
    "ingredients": MessageLookupByLibrary.simpleMessage("Ingredients"),
    "japanesePancakes": MessageLookupByLibrary.simpleMessage(
      "Japanese-style Pancakes",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "languageSelection": MessageLookupByLibrary.simpleMessage(
      "Language Selection",
    ),
    "lightTheme": MessageLookupByLibrary.simpleMessage("Light Theme"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginNow": MessageLookupByLibrary.simpleMessage(" Login Now"),
    "loginRequired": MessageLookupByLibrary.simpleMessage("Login Required"),
    "loginRequiredHistory": MessageLookupByLibrary.simpleMessage(
      "Login required to view history",
    ),
    "loginRequiredOffers": MessageLookupByLibrary.simpleMessage(
      "Login required to view offers",
    ),
    "loginRequiredText": MessageLookupByLibrary.simpleMessage(
      "Please login first to complete your order.",
    ),
    "loginToPlaceOrder": MessageLookupByLibrary.simpleMessage(
      "You must be logged in to place an order",
    ),
    "loginToUseChatbot": MessageLookupByLibrary.simpleMessage(
      "Please log in first to use the chatbot.",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "mockMealError": MessageLookupByLibrary.simpleMessage(
      "This mock meal cannot be ordered.",
    ),
    "myAccount": MessageLookupByLibrary.simpleMessage("My Account"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nationalId": MessageLookupByLibrary.simpleMessage("National ID"),
    "newOtpSent": m10,
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "noFavsFound": MessageLookupByLibrary.simpleMessage("No Favorites Found"),
    "noFavsMatch": m11,
    "noFavsYet": MessageLookupByLibrary.simpleMessage("No Favorites Yet"),
    "noMealsAvailable": MessageLookupByLibrary.simpleMessage(
      "No meals available in this restaurant.",
    ),
    "noMealsFound": m12,
    "noOffersAvailable": MessageLookupByLibrary.simpleMessage(
      "No offers available now",
    ),
    "noOrdersYet": MessageLookupByLibrary.simpleMessage("No Orders Yet"),
    "noRecsAvailable": MessageLookupByLibrary.simpleMessage(
      "No recommendations available.",
    ),
    "noRecsFound": m13,
    "noRestAvailable": MessageLookupByLibrary.simpleMessage(
      "No restaurants available.",
    ),
    "noRestFound": m14,
    "noReviewsYet": MessageLookupByLibrary.simpleMessage(
      "No reviews yet for this dish.",
    ),
    "noWrittenReview": MessageLookupByLibrary.simpleMessage(
      "No written review provided.",
    ),
    "notOrderable": MessageLookupByLibrary.simpleMessage("Not orderable"),
    "offers": MessageLookupByLibrary.simpleMessage("Offers"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "onboardingDesc1": MessageLookupByLibrary.simpleMessage(
      "Together, we can make a real impact.\nTurning leftover food into meaningful meals\nthat feed people, not landfills.",
    ),
    "onboardingDesc2": MessageLookupByLibrary.simpleMessage(
      "Enjoy delicious meals at a lower price while\nhelping restaurants reduce food waste,\nIt\'s a win win.",
    ),
    "onboardingDesc3": MessageLookupByLibrary.simpleMessage(
      "Reduce food waste by connecting surplus\nmeals with charities. Every act of giving\nbrings hope to someone\'s day.",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Turn Leftovers into\nOpportunities",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
      "Save Meal, Save Money",
    ),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Feed Hearts, Not Waste",
    ),
    "openNow": MessageLookupByLibrary.simpleMessage("Open Now"),
    "optionalReview": MessageLookupByLibrary.simpleMessage(
      "Optional review...",
    ),
    "orLoginWith": MessageLookupByLibrary.simpleMessage("Or Login with"),
    "orderFailed": MessageLookupByLibrary.simpleMessage("Order Failed"),
    "orderHistory": MessageLookupByLibrary.simpleMessage("Order History"),
    "orderIdLabel": m15,
    "orderNow": MessageLookupByLibrary.simpleMessage("Order Now"),
    "orderOnTheWay": m16,
    "orderSummary": MessageLookupByLibrary.simpleMessage("Order Summary"),
    "orderThisWeek": MessageLookupByLibrary.simpleMessage("This Week"),
    "orderTimeAll": MessageLookupByLibrary.simpleMessage("Time: All"),
    "orderToday": MessageLookupByLibrary.simpleMessage("Today"),
    "orderingPaused": MessageLookupByLibrary.simpleMessage(
      "Ordering is paused.",
    ),
    "orderingPausedWithReason": m17,
    "orders": MessageLookupByLibrary.simpleMessage("Orders"),
    "otpVerificationTitle": MessageLookupByLibrary.simpleMessage(
      "OTP Verification",
    ),
    "ownerFullName": MessageLookupByLibrary.simpleMessage("Owner Full Name"),
    "pancakesDesc": MessageLookupByLibrary.simpleMessage(
      "Soft mini pancakes served with honey and fresh fruits.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordChangedDesc": MessageLookupByLibrary.simpleMessage(
      "Your password has been\nchanged successfully.",
    ),
    "passwordChangedTitle": MessageLookupByLibrary.simpleMessage(
      "Password Changed!",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "passwordRequired": MessageLookupByLibrary.simpleMessage(
      "Password Required",
    ),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "Confirmed Password doesn\'t match the previous",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("Paused"),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment Method"),
    "phone": MessageLookupByLibrary.simpleMessage("Phone"),
    "phone2": MessageLookupByLibrary.simpleMessage("Phone 2"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "placeOrderCard": MessageLookupByLibrary.simpleMessage(
      "Place Order (Card)",
    ),
    "placeOrderCash": MessageLookupByLibrary.simpleMessage(
      "Place Order (Cash)",
    ),
    "placeholderDesc": MessageLookupByLibrary.simpleMessage(
      "Delicious meal prepared with fresh ingredients.",
    ),
    "pleaseEnterAddress": MessageLookupByLibrary.simpleMessage(
      "Please enter your address",
    ),
    "pleaseEnterPhone": MessageLookupByLibrary.simpleMessage(
      "Please enter your phone number",
    ),
    "pleaseLoginCart": MessageLookupByLibrary.simpleMessage(
      "Please login to view your cart",
    ),
    "pleaseLoginRecs": MessageLookupByLibrary.simpleMessage(
      "Please log in to view recommendations.",
    ),
    "pointsTitle": MessageLookupByLibrary.simpleMessage("Your Points"),
    "popularToday": MessageLookupByLibrary.simpleMessage("Popular Today"),
    "profileSaved": MessageLookupByLibrary.simpleMessage(
      "Profile saved successfully!",
    ),
    "rateInstructions": MessageLookupByLibrary.simpleMessage(
      "Choose a score from 1 to 5 and add an optional review.",
    ),
    "rateThisMeal": MessageLookupByLibrary.simpleMessage("Rate this meal"),
    "ratingRangeError": MessageLookupByLibrary.simpleMessage(
      "Rating must be between 1 and 5.",
    ),
    "ratingSubmitFailed": m18,
    "ratingSuccess": MessageLookupByLibrary.simpleMessage(
      "Rating submitted successfully.",
    ),
    "recommended": MessageLookupByLibrary.simpleMessage("Recommended"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registerHeader": MessageLookupByLibrary.simpleMessage(
      "Hello! Register to get\nstarted",
    ),
    "registerNow": MessageLookupByLibrary.simpleMessage(" Register Now"),
    "rememberPassword": MessageLookupByLibrary.simpleMessage(
      "Remember Password ?",
    ),
    "reorder": MessageLookupByLibrary.simpleMessage("Reorder"),
    "reorderedSuccess": MessageLookupByLibrary.simpleMessage(
      "Reordered successfully! Redirecting to Cart...",
    ),
    "resend": MessageLookupByLibrary.simpleMessage("Resend"),
    "resetLinkSent": m19,
    "resetPasswordBtn": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "restaurantAddress": MessageLookupByLibrary.simpleMessage(
      "Restaurant Address",
    ),
    "restaurantName": MessageLookupByLibrary.simpleMessage("Restaurant Name"),
    "restaurants": MessageLookupByLibrary.simpleMessage("Restaurants"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "reviews": MessageLookupByLibrary.simpleMessage("Reviews"),
    "reviewsOnlyOnline": MessageLookupByLibrary.simpleMessage(
      "Reviews are only available for online menu meals.",
    ),
    "reviewsUnavailable": MessageLookupByLibrary.simpleMessage(
      "Reviews are unavailable right now.",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "sendResetLink": MessageLookupByLibrary.simpleMessage("Send Reset Link"),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "signInToReview": MessageLookupByLibrary.simpleMessage(
      "Sign in with a user account to view & write reviews.",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "specialOffer": MessageLookupByLibrary.simpleMessage("Special Offer"),
    "startExploring": MessageLookupByLibrary.simpleMessage(
      "Start exploring our menu and heart the dishes you love!",
    ),
    "statusAll": MessageLookupByLibrary.simpleMessage("Status: All"),
    "statusCancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "statusDelivered": MessageLookupByLibrary.simpleMessage("Delivered"),
    "statusOnTheWay": MessageLookupByLibrary.simpleMessage("On the way"),
    "statusPending": MessageLookupByLibrary.simpleMessage("Pending"),
    "statusPreparing": MessageLookupByLibrary.simpleMessage("Preparing"),
    "submitRating": MessageLookupByLibrary.simpleMessage("Submit Rating"),
    "subtotal": MessageLookupByLibrary.simpleMessage("Subtotal"),
    "tacoSaladDesc": MessageLookupByLibrary.simpleMessage(
      "Healthy Taco Salad with fresh mixed vegetables.",
    ),
    "termsAgreementAnd": MessageLookupByLibrary.simpleMessage(" and "),
    "termsAgreementConditions": MessageLookupByLibrary.simpleMessage(
      " conditions ",
    ),
    "termsAgreementPolicy": MessageLookupByLibrary.simpleMessage(
      "privacy policy of the app",
    ),
    "termsAgreementPrefix": MessageLookupByLibrary.simpleMessage(
      "by signing up, you agree to our",
    ),
    "thankYou": MessageLookupByLibrary.simpleMessage("Thank You!"),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeSelection": MessageLookupByLibrary.simpleMessage("Theme Selection"),
    "topRated": MessageLookupByLibrary.simpleMessage("Top Rated"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalLabel": MessageLookupByLibrary.simpleMessage("Total: "),
    "trackOrder": MessageLookupByLibrary.simpleMessage("Track Order"),
    "twentyMin": MessageLookupByLibrary.simpleMessage("20 Min"),
    "typeMessage": MessageLookupByLibrary.simpleMessage("Type a message..."),
    "updateRating": MessageLookupByLibrary.simpleMessage("Update Rating"),
    "updateYourRating": MessageLookupByLibrary.simpleMessage(
      "Update your rating",
    ),
    "userRole": MessageLookupByLibrary.simpleMessage("User"),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "vegetablesDesc": MessageLookupByLibrary.simpleMessage(
      "Fresh vegetables mixed with light dressing for a healthy and refreshing taste.",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("Verify"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage(
      "Welcome back! Glad\nto see you, Again!",
    ),
  };
}
