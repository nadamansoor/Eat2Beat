import 'package:eat2beat/core/services/theme_notifier.dart';
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../../../../models/home_model.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/leading_widget.dart';
import 'package:eat2beat/core/services/get_it_services.dart';
import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/screens/home/tabs/cart/checkout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 1;
  late HomeFoodModel model;

  // New variables for reviews and ratings
  bool _isInitialized = false;
  User? currentUser;
  String? token;

  bool reviewsLoading = false;
  List<dynamic> reviews = [];
  double? avgRating;
  int ratingCount = 0;
  String? reviewsErrorMessage;

  bool myRatingLoading = false;
  bool hasExistingRating = false;
  int mySelectedRating = 0;
  final TextEditingController reviewTextController = TextEditingController();

  bool ratingSubmitting = false;
  String? ratingSuccessMessage;
  String? ratingErrorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      model = ModalRoute.of(context)?.settings.arguments as HomeFoodModel;
      _initMealReviewsAndRatings();
    }
  }

  @override
  void dispose() {
    reviewTextController.dispose();
    super.dispose();
  }

  Future<void> _initMealReviewsAndRatings() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && model.id != null) {
      try {
        final fetchedToken = await currentUser!.getIdToken();
        if (fetchedToken != null) {
          setState(() {
            token = fetchedToken;
          });
          await Future.wait([
            _loadReviews(fetchedToken, model.id!),
            _loadMyRating(fetchedToken, model.id!),
          ]);
        }
      } catch (e) {
        debugPrint('Error loading reviews/rating: $e');
      }
    }
  }

  Future<void> _loadReviews(String token, String mealId) async {
    setState(() {
      reviewsLoading = true;
      reviewsErrorMessage = null;
    });
    try {
      final apiService = getIt<ApiService>();
      final data = await apiService.getMealReviews(token, mealId);
      final List<dynamic> loadedReviews = data['reviews'] is List ? data['reviews'] : [];
      final dynamic avg = data['avg_rating'];
      final dynamic count = data['rating_count'];

      setState(() {
        reviews = loadedReviews;
        avgRating = avg is num ? avg.toDouble() : null;
        ratingCount = count is int ? count : (int.tryParse(count?.toString() ?? '') ?? loadedReviews.length);
        reviewsLoading = false;
      });
    } catch (e) {
      setState(() {
        reviewsLoading = false;
        reviewsErrorMessage = 'Reviews are unavailable right now.';
      });
    }
  }

  Future<void> _loadMyRating(String token, String mealId) async {
    setState(() {
      myRatingLoading = true;
    });
    try {
      final apiService = getIt<ApiService>();
      final data = await apiService.getMyMealRating(token, mealId);
      if (data != null) {
        final dynamic rating = data['rating'];
        final String text = data['review_text']?.toString() ?? '';
        setState(() {
          myRatingLoading = false;
          final parsedRating = rating is num ? rating.toDouble() : null;
          if (parsedRating != null) {
            mySelectedRating = parsedRating.round();
            hasExistingRating = true;
          } else {
            hasExistingRating = false;
          }
          reviewTextController.text = text;
        });
      } else {
        setState(() {
          hasExistingRating = false;
          myRatingLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasExistingRating = false;
        myRatingLoading = false;
      });
    }
  }

  Future<void> _submitRating() async {
    if (model.id == null) return;
    if (mySelectedRating < 1 || mySelectedRating > 5) {
      setState(() {
        ratingErrorMessage = 'Rating must be between 1 and 5.';
      });
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      ratingSubmitting = true;
      ratingErrorMessage = null;
      ratingSuccessMessage = null;
    });

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        await apiService.rateMeal(
          token,
          mealId: model.id!,
          rating: mySelectedRating.toDouble(),
          reviewText: reviewTextController.text,
        );
        setState(() {
          ratingSuccessMessage = 'Rating submitted successfully.';
          hasExistingRating = true;
          ratingSubmitting = false;
        });
        await _loadReviews(token, model.id!);
        await _loadMyRating(token, model.id!);
      }
    } catch (e) {
      setState(() {
        ratingErrorMessage = 'Failed to submit rating: $e';
        ratingSubmitting = false;
      });
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) {
        return DateFormat.yMMMd().format(parsed.toLocal());
      }
    } catch (_) {}
    return dateStr;
  }

  Future<void> _addToCart({bool navigateToCheckout = false}) async {
    final bool canOrder = model.isOrderableNow ?? model.isCurrentlyOpen;
    if (!canOrder) {
      String errMsg = 'The restaurant is currently closed or not accepting orders.';
      if (model.isAcceptingOrders == false) {
        final reason = model.pauseReason?.trim() ?? '';
        errMsg = 'Ordering is paused${reason.isNotEmpty ? ": $reason" : ""}.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errMsg),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (model.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This mock meal cannot be ordered',
          ),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Login Required'),
          content: const Text(
            'Please login first to complete your order.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.loginRouteName);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.purple800),
      ),
    );

    try {
      final token = await user.getIdToken();
      if (token != null) {
        final apiService = getIt<ApiService>();
        final cart = await apiService.getCart(token);
        int currentQty = 0;
        for (final row in cart) {
          if (row['meal_id'] == model.id) {
            currentQty = row['quantity'] is int 
                ? row['quantity'] 
                : int.tryParse(row['quantity']?.toString() ?? '') ?? 0;
            break;
          }
        }
        final targetQty = currentQty + quantity;
        await apiService.setCartItem(token, model.id!, targetQty);

        if (!mounted) return;

        Navigator.pop(context); // Pop loading dialog

        if (navigateToCheckout) {
          final double subtotal = model.price * targetQty;
          final double deliveryCharges = 3.99;
          final double total = subtotal + deliveryCharges;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                subtotal: subtotal,
                deliveryCharges: deliveryCharges,
                total: total,
                deliveryAddress: "Home",
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Added to Cart (Qty: $quantity)',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pop loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  Widget _buildImage(String imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            Assets.imagesFood,
            width: width,
            height: height,
            fit: fit,
          );
        },
      );
    } else {
      final path = imagePath.trim().isEmpty ? Assets.imagesFood : imagePath.trim();
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            Assets.imagesFood,
            width: width,
            height: height,
            fit: fit,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // 375
    double screenHeight = MediaQuery.of(context).size.height; // 812

    model = ModalRoute.of(context)?.settings.arguments as HomeFoodModel;
    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: ThemeNotifier().isDarkMode ? const Color(0xff1D1030) : AppColors.lightPurple,
          body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    _buildImage(
                      model.image,
                      height: screenHeight * 0.4,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.08,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LeadingWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.title, style: AppStyles.black20Bold),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: _buildImage(
                              model.restIcon,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02,),
                          Text(model.restName, style: AppStyles.black16w500,),
                          SizedBox(width: screenWidth * 0.02,),
                          Builder(
                            builder: (context) {
                              Color statusColor = const Color(0xFF9499A5);
                              String statusText = 'Not orderable';
                              if (model.isOrderableNow == true) {
                                statusText = 'Open Now';
                                statusColor = const Color(0xFF10B981);
                              } else if (model.isAcceptingOrders == false) {
                                final reason = model.pauseReason?.trim() ?? '';
                                statusText = 'Paused${reason.isNotEmpty ? " ($reason)" : ""}';
                                statusColor = const Color(0xFFEF4444);
                              } else if (model.isOpenNow == false) {
                                statusText = 'Closed now';
                                statusColor = const Color(0xFFF59E0B);
                              } else {
                                statusText = model.isCurrentlyOpen ? 'Open Now' : 'Closed now';
                                statusColor = model.isCurrentlyOpen ? const Color(0xFF10B981) : const Color(0xFFEF4444);
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: screenWidth * 0.04,
                        runSpacing: 8.0,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(Assets.imagesRateIcon, width: 20, height: 20),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                "${(avgRating ?? model.rate).toStringAsFixed(1)}${ratingCount > 0 ? " ($ratingCount)" : ""}",
                                style: AppStyles.grey16w400,
                              ),
                            ],
                          ),
                          Image.asset(Assets.imagesDotIcon, color: AppColors.grey),
                          Text("\$ ${model.price}", style: AppStyles.grey16w400),
                          Image.asset(Assets.imagesDotIcon, color: AppColors.grey),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.watch_later_outlined, color: AppColors.grey, size: 20),
                              SizedBox(width: screenWidth * 0.01),
                              Text(model.time, style: AppStyles.grey16w400),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        children: [
                          Text("Size ", style: AppStyles.black16w500,),
                          SizedBox(width: screenWidth * 0.01,),
                          Container(
                            alignment: Alignment.center,
                            width: screenWidth * 0.085,
                            height: screenHeight*0.044,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.purple50,
                              borderRadius: BorderRadius.circular(110),
                            ),
                            child: Text(model.size , style: AppStyles.black16w500,),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Text("Ingredients", style: AppStyles.black16Bold,),
                      SizedBox(height: screenHeight * 0.01),
                      Text(model.description, style: AppStyles.grey13w400,),
                      SizedBox(height: screenHeight * 0.03),
                      Divider(color: ThemeNotifier().isDarkMode ? Colors.white10 : Colors.black12, thickness: 1),
                      SizedBox(height: screenHeight * 0.02),
                      
                      // Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Reviews", style: AppStyles.black16Bold),
                          if (avgRating != null || ratingCount > 0)
                            Text(
                              "${(avgRating ?? model.rate).toStringAsFixed(1)} average from $ratingCount review${ratingCount == 1 ? '' : 's'}",
                              style: AppStyles.grey13w400,
                            )
                          else
                            Text("No reviews yet", style: AppStyles.grey13w400),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Rating & Review Form (for Logged-in Users)
                      if (currentUser != null && model.id != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ThemeNotifier().isDarkMode 
                                ? Colors.white.withOpacity(0.03) 
                                : Colors.black.withOpacity(0.02),
                            border: Border.all(
                              color: ThemeNotifier().isDarkMode 
                                  ? Colors.white.withOpacity(0.08) 
                                  : Colors.black.withOpacity(0.05),
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hasExistingRating ? "Update your rating" : "Rate this meal", 
                                style: AppStyles.black16w500
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Choose a score from 1 to 5 and add an optional review.",
                                style: AppStyles.grey13w400,
                              ),
                              const SizedBox(height: 12),
                              
                              if (myRatingLoading)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: AppColors.purple800, strokeWidth: 2),
                                    ),
                                  ),
                                )
                              else ...[
                                // Star Selection
                                Row(
                                  children: List.generate(5, (index) {
                                    final starIndex = index + 1;
                                    return GestureDetector(
                                      onTap: ratingSubmitting 
                                          ? null 
                                          : () {
                                              setState(() {
                                                mySelectedRating = starIndex;
                                                ratingErrorMessage = null;
                                                ratingSuccessMessage = null;
                                              });
                                            },
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: AnimatedScale(
                                          scale: mySelectedRating == starIndex ? 1.15 : 1.0,
                                          duration: const Duration(milliseconds: 150),
                                          child: Icon(
                                            Icons.star,
                                            size: 34,
                                            color: starIndex <= mySelectedRating
                                                ? const Color(0xFFFFC833)
                                                : (ThemeNotifier().isDarkMode 
                                                    ? Colors.white.withOpacity(0.15) 
                                                    : Colors.black.withOpacity(0.1)),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 12),
                                
                                // Text Input Field
                                TextField(
                                  controller: reviewTextController,
                                  maxLines: 3,
                                  enabled: !ratingSubmitting,
                                  style: TextStyle(
                                    color: ThemeNotifier().isDarkMode ? Colors.white : Colors.black87,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Optional review...",
                                    hintStyle: TextStyle(
                                      color: ThemeNotifier().isDarkMode ? Colors.white54 : Colors.black45,
                                    ),
                                    filled: true,
                                    fillColor: ThemeNotifier().isDarkMode 
                                        ? Colors.white.withOpacity(0.02) 
                                        : Colors.black.withOpacity(0.01),
                                    contentPadding: const EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: ThemeNotifier().isDarkMode 
                                            ? Colors.white.withOpacity(0.1) 
                                            : Colors.black.withOpacity(0.1),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Feedback Messages
                                if (ratingErrorMessage != null)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1FEF4444),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      ratingErrorMessage!,
                                      style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                if (ratingSuccessMessage != null)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1F10B981),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      ratingSuccessMessage!,
                                      style: const TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                // Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: ratingSubmitting ? null : _submitRating,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.purple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      elevation: 0,
                                    ),
                                    child: ratingSubmitting
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                          )
                                        : Text(
                                            hasExistingRating ? 'Update Rating' : 'Submit Rating',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ] else ...[
                        // Unauthorized User / Mock Meal Prompt
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ThemeNotifier().isDarkMode 
                                ? Colors.white.withOpacity(0.03) 
                                : Colors.black.withOpacity(0.02),
                            border: Border.all(
                              color: ThemeNotifier().isDarkMode 
                                  ? Colors.white.withOpacity(0.08) 
                                  : Colors.black.withOpacity(0.05),
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Text(
                                model.id == null
                                    ? "Reviews are only available for online menu meals."
                                    : "Sign in with a user account to view & write reviews.",
                                style: AppStyles.black13w400,
                                textAlign: TextAlign.center,
                              ),
                              if (model.id != null) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: 140,
                                  height: 38,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.loginRouteName);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.purple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      elevation: 0,
                                    ),
                                    child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: screenHeight * 0.02),

                      // Reviews List Section
                      if (reviewsLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: CircularProgressIndicator(color: AppColors.purple800),
                          ),
                        )
                      else if (reviewsErrorMessage != null)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(reviewsErrorMessage!, style: AppStyles.grey13w400),
                          ),
                        )
                      else if (reviews.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Text(
                              "No reviews yet for this dish.",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: ThemeNotifier().isDarkMode ? Colors.white54 : Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: reviews.map((rev) {
                            final String userName = rev['user_name']?.toString() ?? 'User';
                            final double userRate = rev['rating'] is num 
                                ? (rev['rating'] as num).toDouble() 
                                : (double.tryParse(rev['rating']?.toString() ?? '') ?? 0.0);
                            final String? reviewText = rev['review_text']?.toString();
                            final String dateText = _formatDate(rev['updated_at']?.toString() ?? rev['created_at']?.toString());
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: ThemeNotifier().isDarkMode 
                                    ? Colors.white.withOpacity(0.025) 
                                    : Colors.black.withOpacity(0.015),
                                border: Border.all(
                                  color: ThemeNotifier().isDarkMode 
                                      ? Colors.white.withOpacity(0.05) 
                                      : Colors.black.withOpacity(0.03),
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        userName, 
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: ThemeNotifier().isDarkMode ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      if (dateText.isNotEmpty)
                                        Text(
                                          dateText, 
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ThemeNotifier().isDarkMode ? Colors.white38 : Colors.black38,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            Icons.star,
                                            size: 15,
                                            color: (index + 1) <= userRate 
                                                ? const Color(0xFFFFC833) 
                                                : (ThemeNotifier().isDarkMode 
                                                    ? Colors.white.withOpacity(0.12) 
                                                    : Colors.black.withOpacity(0.08)),
                                          );
                                        }),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${userRate.toStringAsFixed(1)}/5.0",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFC833),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (reviewText != null && reviewText.trim().isNotEmpty)
                                    Text(
                                      reviewText,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: ThemeNotifier().isDarkMode ? Colors.white70 : Colors.black87,
                                      ),
                                    )
                                  else
                                    Text(
                                      "No written review provided.",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: ThemeNotifier().isDarkMode ? Colors.white30 : Colors.black38,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02
          ),
          decoration: BoxDecoration(
            color: Color(0xd9c4b2fc),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("\$ ${model.price * quantity}" , style: AppStyles.white25Bold,),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth*0.03,
                      vertical: screenHeight * 0.015
                    ),
                    decoration: BoxDecoration(
                      color: Color(0x1a1b1432),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            if(quantity > 1){
                              quantity--;
                            }
                            setState(() {

                            });
                          },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0x33f9f7ff),
                                  shape: BoxShape.circle
                                ),
                                child: Icon(Icons.remove, color: Colors.white,))),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,

                          ),
                          child: Text("$quantity", style: AppStyles.white16Bold,),
                        ),
                        InkWell(
                            onTap: (){

                              setState(() {
                                quantity++;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0x33f9f7ff),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.add, color: Colors.white,))),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.02,),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                        text: "Add To Cart",
                        backgroundColor: ThemeNotifier().isDarkMode ? const Color(0xff45337D) : AppColors.lightPurple,
                        textColor: ThemeNotifier().isDarkMode ? Colors.white : AppColors.purple,
                        onPressed: () => _addToCart(navigateToCheckout: false),
                    ),
                  ),

                  SizedBox(width: screenWidth * 0.06,),

                  Expanded(
                    child: CustomButton(
                        text: "Order Now",
                        backgroundColor: ThemeNotifier().isDarkMode ? AppColors.purple800 : AppColors.purple,
                        onPressed: () => _addToCart(navigateToCheckout: true),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
