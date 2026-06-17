// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(qty) => "تمت الإضافة للسلة (الكمية: ${qty})";

  static String m1(code, body) => "خطأ في خدمة المحادثة (${code}): ${body}";

  static String m2(email) => "أدخل رمز التحقق الذي أرسلناه للتو إلى:\n${email}";

  static String m3(error) => "فشل إضافة الوجبة للسلة: ${error}";

  static String m4(error) => "فشل تحميل سجل الطلبات: ${error}";

  static String m5(error) => "فشل تحميل العروض: ${error}";

  static String m6(error) =>
      "فشل وضع الطلب. يرجى المحاولة مرة أخرى.\n\n${error}";

  static String m7(error) => "فشل إعادة الطلب: ${error}";

  static String m8(error) => "فشل تحديث المفضلة: ${error}";

  static String m9(error) => "فشل تحديث الكمية: ${error}";

  static String m10(code) => "تم إرسال رمز تحقق جديد: ${code}";

  static String m11(query) => "لا توجد وجبات مفضلة تطابق \"${query}\".";

  static String m12(query) => "لم يتم العثور على وجبات تطابق \"${query}\".";

  static String m13(query) => "لم يتم العثور على توصيات تطابق \"${query}\".";

  static String m14(query) => "لم يتم العثور على مطاعم تطابق \"${query}\".";

  static String m15(id) => "رقم الطلب: #${id}";

  static String m16(id) => "وجبتك اللذيذة في الطريق.\nرقم الطلب: #${id}";

  static String m17(reason) => "الطلب متوقف مؤقتاً: ${reason}.";

  static String m18(error) => "فشل إرسال التقييم: ${error}";

  static String m19(email) =>
      "تم إرسال رابط إعادة تعيين كلمة المرور إلى ${email}. يرجى التحقق من بريدك الإلكتروني.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "acceptTermsFirst": MessageLookupByLibrary.simpleMessage(
      "يجب عليك قبول الشروط والأحكام",
    ),
    "addCoupon": MessageLookupByLibrary.simpleMessage("أضف كوبون"),
    "addToCart": MessageLookupByLibrary.simpleMessage("إضافة إلى السلة"),
    "addedToCartQty": m0,
    "addressPlaceholder": MessageLookupByLibrary.simpleMessage(
      "اسم الشارع، المبنى، الشقة",
    ),
    "adminRole": MessageLookupByLibrary.simpleMessage("مسؤول"),
    "allMeals": MessageLookupByLibrary.simpleMessage("جميع الوجبات"),
    "allOrdersLoaded": MessageLookupByLibrary.simpleMessage(
      "تم تحميل جميع الطلبات",
    ),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "هل لديك حساب بالفعل؟",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("إيت تو بيت"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية (Arabic)"),
    "area": MessageLookupByLibrary.simpleMessage("المنطقة"),
    "avocadoDesc": MessageLookupByLibrary.simpleMessage(
      "شرائح أفوكادو كريمية مع خبز طازج وتوابل خفيفة.",
    ),
    "backToLogin": MessageLookupByLibrary.simpleMessage("العودة لتسجيل الدخول"),
    "backToRestaurants": MessageLookupByLibrary.simpleMessage("العودة للمطاعم"),
    "banner1": MessageLookupByLibrary.simpleMessage(
      "خصم ٣٥٪ على\nالبرجر في\nOMG!",
    ),
    "banner2": MessageLookupByLibrary.simpleMessage(
      "خصم ٢٠٪ على\nالبيتزا اليوم",
    ),
    "banner3": MessageLookupByLibrary.simpleMessage(
      "اشترِ ١ واحصل\nعلى ١ مجاناً حلويات",
    ),
    "beefBurger": MessageLookupByLibrary.simpleMessage("برجر لحم"),
    "botCharity1": MessageLookupByLibrary.simpleMessage(
      "نتشارك مع الجمعيات الأهلية المحلية للتبرع بفائض الطعام. تفضل بزيارة صفحة التبرعات لمعرفة المزيد! 💝",
    ),
    "botCharity2": MessageLookupByLibrary.simpleMessage(
      "إيت تو بيت ملتزم بالحد من هدر الطعام. تفضل بزيارة قسم التبرعات.",
    ),
    "botContact1": MessageLookupByLibrary.simpleMessage(
      "يمكنك التواصل معنا عبر support@eat2beat.com أو الاتصال بـ 1-800-EAT2BEAT. 📞",
    ),
    "botContact2": MessageLookupByLibrary.simpleMessage(
      "تحتاج مساعدة؟ تواصل مع فريق الدعم الفني عبر البريد الإلكتروني أو الهاتف!",
    ),
    "botDefault1": MessageLookupByLibrary.simpleMessage(
      "عذراً، لم أفهمك تماماً. جرب السؤال عن المنيو، الطلبات، التوصيل، أو التبرع للجمعيات. 🤖",
    ),
    "botDefault2": MessageLookupByLibrary.simpleMessage(
      "بإمكاني مساعدتك في الأسئلة حول المنيو، الطلبات، التوصيل، التبرعات، وأكثر. ماذا تود أن تعرف؟",
    ),
    "botDelivery1": MessageLookupByLibrary.simpleMessage(
      "التوصيل لدينا يتم في غضون ٣٠ دقيقة أو أقل! 🚀 يعمل فريق التوصيل على مدار الساعة.",
    ),
    "botDelivery2": MessageLookupByLibrary.simpleMessage(
      "سرعة التوصيل هي ميزتنا. توقع وصول وجبتك ساخنة وطازجة في غضون ٣٠ دقيقة.",
    ),
    "botGreeting1": MessageLookupByLibrary.simpleMessage(
      "مرحباً! أهلاً بك في إيت تو بيت! 🍽️ كيف يمكنني مساعدتك اليوم؟",
    ),
    "botGreeting2": MessageLookupByLibrary.simpleMessage(
      "مرحباً بك! أنا مساعدك الذكي في إيت تو بيت. كيف يمكنني خدمتك؟",
    ),
    "botHours1": MessageLookupByLibrary.simpleMessage(
      "نعمل على مدار ٢٤ ساعة! اطلب في أي وقت، نحن متواجدون لخدمتك دائماً. ⏰",
    ),
    "botHours2": MessageLookupByLibrary.simpleMessage(
      "إيت تو بيت لا ينام! ضع طلبك في أي وقت بالليل أو النهار.",
    ),
    "botMenu1": MessageLookupByLibrary.simpleMessage(
      "يمكنك عرض قائمتنا الكاملة بالذهاب إلى صفحة الرئيسية. لدينا وجبات عضوية لذيذة للغاية! 🥗",
    ),
    "botMenu2": MessageLookupByLibrary.simpleMessage(
      "تصفح قسم المنيو لمشاهدة مجموعة متنوعة من الوجبات الصحية والطازجة.",
    ),
    "botOrder1": MessageLookupByLibrary.simpleMessage(
      "لإتمام الطلب، تصفح القائمة وأضف الوجبات المفضلة إلى السلة، ثم توجه لصفحة الدفع! 🛒",
    ),
    "botOrder2": MessageLookupByLibrary.simpleMessage(
      "الطلب سهل وبسيط! فقط أضف وجباتك إلى السلة وسنقوم بالتوصيل في غضون ٣٠ دقيقة.",
    ),
    "botPayment1": MessageLookupByLibrary.simpleMessage(
      "نقبل جميع بطاقات الائتمان الرئيسية، بالإضافة للدفع عند الاستلام. 💳",
    ),
    "botPayment2": MessageLookupByLibrary.simpleMessage(
      "خيارات الدفع المتعددة متاحة: البطاقات الائتمانية أو الدفع عند الاستلام.",
    ),
    "botThanks1": MessageLookupByLibrary.simpleMessage(
      "على الرحب والسعة! هل هناك أي شيء آخر يمكنني مساعدتك به؟ 😊",
    ),
    "botThanks2": MessageLookupByLibrary.simpleMessage(
      "سعيد بمساعدتك! أخبرني إذا كنت بحاجة لأي شيء آخر!",
    ),
    "burgerKing": MessageLookupByLibrary.simpleMessage("برجر كنج"),
    "buyNow": MessageLookupByLibrary.simpleMessage("اشترِ الآن"),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "card": MessageLookupByLibrary.simpleMessage("بطاقة"),
    "cardNumber": MessageLookupByLibrary.simpleMessage("رقم البطاقة"),
    "cart": MessageLookupByLibrary.simpleMessage("السلة"),
    "cartEmpty": MessageLookupByLibrary.simpleMessage("سلتك فارغة"),
    "cash": MessageLookupByLibrary.simpleMessage("نقداً"),
    "charityPortalSoon": MessageLookupByLibrary.simpleMessage(
      "بوابة الجمعيات الخيرية قريباً!",
    ),
    "charityRole": MessageLookupByLibrary.simpleMessage("جمعية خيرية"),
    "chatServiceError": m1,
    "chatbot": MessageLookupByLibrary.simpleMessage("المساعد الذكي"),
    "checkout": MessageLookupByLibrary.simpleMessage("الدفع"),
    "chickenWrap": MessageLookupByLibrary.simpleMessage("لفائف الدجاج"),
    "chickenWrapDesc": MessageLookupByLibrary.simpleMessage(
      "دجاج مشوي طري ملفوف بالخضار الطازج والخبز اللين.",
    ),
    "city": MessageLookupByLibrary.simpleMessage("المدينة"),
    "closedNow": MessageLookupByLibrary.simpleMessage("مغلق الآن"),
    "closedOrNotAccepting": MessageLookupByLibrary.simpleMessage(
      "المطعم مغلق حالياً أو لا يستقبل طلبات.",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage(
      "تأكيد كلمة المرور",
    ),
    "createNewPasswordDesc": MessageLookupByLibrary.simpleMessage(
      "يجب أن تكون كلمة المرور الجديدة فريدة ولم يتم استخدامها من قبل.",
    ),
    "createNewPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "إنشاء كلمة مرور جديدة",
    ),
    "cvv": MessageLookupByLibrary.simpleMessage("رمز التحقق (CVV)"),
    "darkTheme": MessageLookupByLibrary.simpleMessage("المظهر الداكن"),
    "deliveryAddress": MessageLookupByLibrary.simpleMessage("عنوان التوصيل"),
    "deliveryCharges": MessageLookupByLibrary.simpleMessage("رسوم التوصيل"),
    "deliveryDetails": MessageLookupByLibrary.simpleMessage("تفاصيل التوصيل"),
    "didntReceiveCode": MessageLookupByLibrary.simpleMessage("لم تتلق الرمز؟"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟"),
    "driverOnTheWay": MessageLookupByLibrary.simpleMessage(
      "سائقنا في الطريق لاستلام وجبتك!",
    ),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterCompleteOtp": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رمز التحقق كاملاً المكون من 4 أرقام",
    ),
    "enterEmail": MessageLookupByLibrary.simpleMessage("أدخل بريدك الإلكتروني"),
    "enterName": MessageLookupByLibrary.simpleMessage("أدخل اسمك بالكامل"),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage("أدخل رقم الهاتف"),
    "enterVerificationCode": m2,
    "expiry": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
    "failedAddToCart": m3,
    "failedGetToken": MessageLookupByLibrary.simpleMessage(
      "فشل الحصول على رمز المصادقة. يرجى المحاولة مرة أخرى.",
    ),
    "failedLoadHistory": m4,
    "failedLoadOffers": m5,
    "failedPlaceOrder": m6,
    "failedReorder": m7,
    "failedToUpdateFavorite": m8,
    "failedUpdateQuantity": m9,
    "favorites": MessageLookupByLibrary.simpleMessage("المفضلة"),
    "fillDeliveryDetails": MessageLookupByLibrary.simpleMessage(
      "يرجى ملء تفاصيل التوصيل!",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
    "forgotPasswordDesc": MessageLookupByLibrary.simpleMessage(
      "لا تقلق! هذا يحدث. يرجى إدخال البريد الإلكتروني المرتبط بحسابك.",
    ),
    "forgotPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "نسيت كلمة المرور؟",
    ),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم بالكامل"),
    "goToMenu": MessageLookupByLibrary.simpleMessage("الذهاب للمنيو"),
    "goldenBox": MessageLookupByLibrary.simpleMessage("العلبة الذهبية"),
    "googleLoginUserOnly": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول بجوجل متاح للمستخدمين فقط",
    ),
    "healthyTacoSalad": MessageLookupByLibrary.simpleMessage("سلطة تاكو صحية"),
    "hello": MessageLookupByLibrary.simpleMessage("مرحباً"),
    "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "hungryExplore": MessageLookupByLibrary.simpleMessage(
      "جائع؟ استكشف قائمتنا وضع طلبك الأول!",
    ),
    "ingredients": MessageLookupByLibrary.simpleMessage("المكونات"),
    "japanesePancakes": MessageLookupByLibrary.simpleMessage("بانكيك ياباني"),
    "language": MessageLookupByLibrary.simpleMessage("اللغة"),
    "languageSelection": MessageLookupByLibrary.simpleMessage("تحديد اللغة"),
    "lightTheme": MessageLookupByLibrary.simpleMessage("المظهر الفاتح"),
    "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginNow": MessageLookupByLibrary.simpleMessage(" سجل دخول الآن"),
    "loginRequired": MessageLookupByLibrary.simpleMessage("تسجيل الدخول مطلوب"),
    "loginRequiredHistory": MessageLookupByLibrary.simpleMessage(
      "يجب تسجيل الدخول لعرض السجل",
    ),
    "loginRequiredOffers": MessageLookupByLibrary.simpleMessage(
      "يجب تسجيل الدخول لعرض العروض",
    ),
    "loginRequiredText": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول أولاً لإتمام طلبك.",
    ),
    "loginToPlaceOrder": MessageLookupByLibrary.simpleMessage(
      "يجب تسجيل الدخول لوضع الطلب",
    ),
    "loginToUseChatbot": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول أولاً لاستخدام المساعد الذكي.",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "mockMealError": MessageLookupByLibrary.simpleMessage(
      "لا يمكن طلب هذه الوجبة التجريبية.",
    ),
    "myAccount": MessageLookupByLibrary.simpleMessage("حسابي"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "nationalId": MessageLookupByLibrary.simpleMessage("الرقم القومي"),
    "newOtpSent": m10,
    "newPassword": MessageLookupByLibrary.simpleMessage("كلمة المرور الجديدة"),
    "noFavsFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على مفضلة",
    ),
    "noFavsMatch": m11,
    "noFavsYet": MessageLookupByLibrary.simpleMessage("لا توجد مفضلة بعد"),
    "noMealsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد وجبات متاحة في هذا المطعم.",
    ),
    "noMealsFound": m12,
    "noOffersAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد عروض متاحة حالياً",
    ),
    "noOrdersYet": MessageLookupByLibrary.simpleMessage("لا توجد طلبات بعد"),
    "noRecsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد توصيات متاحة.",
    ),
    "noRecsFound": m13,
    "noRestAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد مطاعم متاحة.",
    ),
    "noRestFound": m14,
    "noReviewsYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد تقييمات لهذه الوجبة بعد.",
    ),
    "noWrittenReview": MessageLookupByLibrary.simpleMessage(
      "لم يتم تقديم تعليق مكتوب.",
    ),
    "notOrderable": MessageLookupByLibrary.simpleMessage("غير قابل للطلب"),
    "offers": MessageLookupByLibrary.simpleMessage("العروض"),
    "ok": MessageLookupByLibrary.simpleMessage("موافق"),
    "onboardingDesc1": MessageLookupByLibrary.simpleMessage(
      "معاً، يمكننا إحداث تأثير حقيقي.\nتحويل بقايا الطعام إلى وجبات ذات معنى\nتطعم الناس، وليس مكبات النفايات.",
    ),
    "onboardingDesc2": MessageLookupByLibrary.simpleMessage(
      "استمتع بوجبات لذيذة بسعر أقل مع\nمساعدة المطاعم في تقليل هدر الطعام،\nإنه فوز للطرفين.",
    ),
    "onboardingDesc3": MessageLookupByLibrary.simpleMessage(
      "قلل من هدر الطعام عن طريق ربط الفائض\nمن الوجبات بالجمعيات الخيرية. فكل عمل عطاء\nيجلب الأمل ليوم شخص ما.",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "حوّل بقايا الطعام\nإلى فرص",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
      "وفر الوجبة، ووفر المال",
    ),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage(
      "أطعم القلوب، لا النفايات",
    ),
    "openNow": MessageLookupByLibrary.simpleMessage("مفتوح الآن"),
    "optionalReview": MessageLookupByLibrary.simpleMessage("تعليق اختياري..."),
    "orLoginWith": MessageLookupByLibrary.simpleMessage(
      "أو تسجيل الدخول بواسطة",
    ),
    "orderFailed": MessageLookupByLibrary.simpleMessage("فشل الطلب"),
    "orderHistory": MessageLookupByLibrary.simpleMessage("سجل الطلبات"),
    "orderIdLabel": m15,
    "orderNow": MessageLookupByLibrary.simpleMessage("اطلب الآن"),
    "orderOnTheWay": m16,
    "orderSummary": MessageLookupByLibrary.simpleMessage("ملخص الطلب"),
    "orderThisWeek": MessageLookupByLibrary.simpleMessage("هذا الأسبوع"),
    "orderTimeAll": MessageLookupByLibrary.simpleMessage("الوقت: الكل"),
    "orderToday": MessageLookupByLibrary.simpleMessage("اليوم"),
    "orderingPaused": MessageLookupByLibrary.simpleMessage(
      "الطلب متوقف مؤقتاً.",
    ),
    "orderingPausedWithReason": m17,
    "orders": MessageLookupByLibrary.simpleMessage("الطلبات"),
    "otpVerificationTitle": MessageLookupByLibrary.simpleMessage(
      "التحقق من رمز OTP",
    ),
    "ownerFullName": MessageLookupByLibrary.simpleMessage("اسم المالك بالكامل"),
    "pancakesDesc": MessageLookupByLibrary.simpleMessage(
      "بانكيك صغير ناعم يقدم مع العسل والفواكه الطازجة.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "passwordChangedDesc": MessageLookupByLibrary.simpleMessage(
      "تم تغيير كلمة المرور الخاصة بك\nبنجاح.",
    ),
    "passwordChangedTitle": MessageLookupByLibrary.simpleMessage(
      "تم تغيير كلمة المرور!",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "يجب أن تتكون كلمة المرور من 6 أحرف على الأقل",
    ),
    "passwordRequired": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور مطلوبة",
    ),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور المؤكدة لا تطابق السابقة",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("متوقف مؤقتاً"),
    "paymentMethod": MessageLookupByLibrary.simpleMessage("طريقة الدفع"),
    "phone": MessageLookupByLibrary.simpleMessage("الهاتف"),
    "phone2": MessageLookupByLibrary.simpleMessage("الهاتف 2"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "placeOrderCard": MessageLookupByLibrary.simpleMessage(
      "اتمام الطلب (بالبطاقة)",
    ),
    "placeOrderCash": MessageLookupByLibrary.simpleMessage(
      "اتمام الطلب (نقداً)",
    ),
    "placeholderDesc": MessageLookupByLibrary.simpleMessage(
      "وجبة لذيذة محضرة بمكونات طازجة.",
    ),
    "pleaseEnterAddress": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال العنوان",
    ),
    "pleaseEnterPhone": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رقم الهاتف",
    ),
    "pleaseLoginCart": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول لعرض سلة التسوق الخاصة بك",
    ),
    "pleaseLoginRecs": MessageLookupByLibrary.simpleMessage(
      "يرجى تسجيل الدخول لعرض التوصيات.",
    ),
    "pointsTitle": MessageLookupByLibrary.simpleMessage("نقاطك"),
    "popularToday": MessageLookupByLibrary.simpleMessage("الشائع اليوم"),
    "profileSaved": MessageLookupByLibrary.simpleMessage(
      "تم حفظ الملف الشخصي بنجاح!",
    ),
    "rateInstructions": MessageLookupByLibrary.simpleMessage(
      "اختر درجة من ١ إلى ٥ وأضف تعليقاً اختيارياً.",
    ),
    "rateThisMeal": MessageLookupByLibrary.simpleMessage("قيّم هذه الوجبة"),
    "ratingRangeError": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون التقييم بين ١ و ٥.",
    ),
    "ratingSubmitFailed": m18,
    "ratingSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إرسال التقييم بنجاح.",
    ),
    "recommended": MessageLookupByLibrary.simpleMessage("موصى به"),
    "register": MessageLookupByLibrary.simpleMessage("تسجيل"),
    "registerHeader": MessageLookupByLibrary.simpleMessage("مرحباً! سجل للبدء"),
    "registerNow": MessageLookupByLibrary.simpleMessage(" سجل الآن"),
    "rememberPassword": MessageLookupByLibrary.simpleMessage(
      "تذكر كلمة المرور؟",
    ),
    "reorder": MessageLookupByLibrary.simpleMessage("إعادة الطلب"),
    "reorderedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إعادة الطلب بنجاح! جاري تحويلك للسلة...",
    ),
    "resend": MessageLookupByLibrary.simpleMessage("إعادة إرسال"),
    "resetLinkSent": m19,
    "resetPasswordBtn": MessageLookupByLibrary.simpleMessage(
      "إعادة تعيين كلمة المرور",
    ),
    "restaurantAddress": MessageLookupByLibrary.simpleMessage("عنوان المطعم"),
    "restaurantName": MessageLookupByLibrary.simpleMessage("اسم المطعم"),
    "restaurants": MessageLookupByLibrary.simpleMessage("المطاعم"),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "reviews": MessageLookupByLibrary.simpleMessage("التقييمات"),
    "reviewsOnlyOnline": MessageLookupByLibrary.simpleMessage(
      "التقييمات متاحة فقط لوجبات المنيو عبر الإنترنت.",
    ),
    "reviewsUnavailable": MessageLookupByLibrary.simpleMessage(
      "التقييمات غير متاحة حالياً.",
    ),
    "save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "search": MessageLookupByLibrary.simpleMessage("بحث"),
    "sendResetLink": MessageLookupByLibrary.simpleMessage(
      "إرسال رابط إعادة التعيين",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signInToReview": MessageLookupByLibrary.simpleMessage(
      "سجل الدخول بحساب مستخدم لعرض وكتابة التقييمات.",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "specialOffer": MessageLookupByLibrary.simpleMessage("عرض خاص"),
    "startExploring": MessageLookupByLibrary.simpleMessage(
      "ابدأ في استكشاف قائمتنا وضع قلباً على الأطباق التي تحبها!",
    ),
    "statusAll": MessageLookupByLibrary.simpleMessage("الحالة: الكل"),
    "statusCancelled": MessageLookupByLibrary.simpleMessage("تم الإلغاء"),
    "statusDelivered": MessageLookupByLibrary.simpleMessage("تم التوصيل"),
    "statusOnTheWay": MessageLookupByLibrary.simpleMessage("في الطريق"),
    "statusPending": MessageLookupByLibrary.simpleMessage("قيد الانتظار"),
    "statusPreparing": MessageLookupByLibrary.simpleMessage("قيد التحضير"),
    "submitRating": MessageLookupByLibrary.simpleMessage("إرسال التقييم"),
    "subtotal": MessageLookupByLibrary.simpleMessage("المجموع الفرعي"),
    "tacoSaladDesc": MessageLookupByLibrary.simpleMessage(
      "سلطة تاكو صحية مع خضار مشكل طازج.",
    ),
    "termsAgreementAnd": MessageLookupByLibrary.simpleMessage(" و "),
    "termsAgreementConditions": MessageLookupByLibrary.simpleMessage(
      " الشروط ",
    ),
    "termsAgreementPolicy": MessageLookupByLibrary.simpleMessage(
      "سياسة الخصوصية للتطبيق",
    ),
    "termsAgreementPrefix": MessageLookupByLibrary.simpleMessage(
      "من خلال التسجيل، فإنك توافق على",
    ),
    "thankYou": MessageLookupByLibrary.simpleMessage("شكراً لك!"),
    "theme": MessageLookupByLibrary.simpleMessage("المظهر"),
    "themeSelection": MessageLookupByLibrary.simpleMessage("تحديد المظهر"),
    "topRated": MessageLookupByLibrary.simpleMessage("الأعلى تقييماً"),
    "total": MessageLookupByLibrary.simpleMessage("الإجمالي"),
    "totalLabel": MessageLookupByLibrary.simpleMessage("الإجمالي: "),
    "trackOrder": MessageLookupByLibrary.simpleMessage("تتبع الطلب"),
    "twentyMin": MessageLookupByLibrary.simpleMessage("٢٠ دقيقة"),
    "typeMessage": MessageLookupByLibrary.simpleMessage("اكتب رسالة..."),
    "updateRating": MessageLookupByLibrary.simpleMessage("تحديث التقييم"),
    "updateYourRating": MessageLookupByLibrary.simpleMessage("تحديث تقييمك"),
    "userRole": MessageLookupByLibrary.simpleMessage("مستخدم"),
    "username": MessageLookupByLibrary.simpleMessage("اسم المستخدم"),
    "vegetablesDesc": MessageLookupByLibrary.simpleMessage(
      "خضار طازج مخلوط مع تتبيلة خفيفة لمذاق صحي ومنعش.",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("التحقق"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage(
      "مرحباً بعودتك! يسعدنا\nرؤيتك مجدداً!",
    ),
  };
}
