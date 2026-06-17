import 'package:eat2beat/core/services/theme_notifier.dart';
import 'dart:convert';
import 'dart:math' show Random;
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eat2beat/features/models/home_model.dart';
import 'package:eat2beat/core/utils/app_routes.dart';
import 'package:eat2beat/generated/l10n.dart';

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────
class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime time;
  final List<HomeFoodModel>? products;

  const ChatMessage({
    required this.text,
    required this.isBot,
    required this.time,
    this.products,
  });
}

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  static const String _chatEndpoint =
      'https://e.eat2beatt.workers.dev/deepsearch/chat';
  static const String _sessionPrefKey = 'deepsearch_session_id';

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<ChatMessage> _messages = [];
  bool _isSending = false;
  String? _sessionId;

  // ── Local fallback responses ──


  static const Map<String, List<String>> _keywords = {
    'greeting': ['hello', 'hi', 'hey', 'good morning', 'good evening', 'good afternoon'],
    'menu': ['menu', 'food', 'meals', 'dishes', 'options', 'what to eat', 'eat'],
    'order': ['order', 'buy', 'purchase', 'get', 'how to order'],
    'delivery': ['delivery', 'deliver', 'shipping', 'time', 'how long', 'arrive', 'when'],
    'charity': ['charity', 'donate', 'donation', 'help', 'ngo', 'give', 'support'],
    'payment': ['pay', 'payment', 'card', 'credit', 'cash', 'money', 'price', 'cost'],
    'contact': ['contact', 'email', 'phone', 'call', 'reach', 'speak', 'talk'],
    'hours': ['open', 'hours', 'time', 'when', 'available', 'close', 'closing'],
    'thanks': ['thank', 'thanks', 'appreciate', 'thx'],
  };

  // ─────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadSessionId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _addBotMessage(_randomResponse('greeting'));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // Session helpers
  // ─────────────────────────────────────────────
  Future<void> _loadSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    _sessionId = prefs.getString(_sessionPrefKey);
  }

  Future<void> _saveSessionId(String sid) async {
    _sessionId = sid;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionPrefKey, sid);
  }

  // ─────────────────────────────────────────────
  // Send message
  // ─────────────────────────────────────────────
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    _controller.clear();
    _addUserMessage(text);
    setState(() => _isSending = true);
    _scrollToBottom();

    _getBotResponse(text).then((responseObj) {
      _addBotMessage(responseObj.text, products: responseObj.products);
    }).catchError((_) {
      _addBotMessage(_getLocalFallbackResponse(text));
    }).whenComplete(() {
      if (mounted) setState(() => _isSending = false);
      _scrollToBottom();
    });
  }

  // ─────────────────────────────────────────────
  // API call — mirrors Angular getBotResponse()
  // ─────────────────────────────────────────────
  Future<_BotResponse> _getBotResponse(String input) async {
    // 1. Get Firebase ID token
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _BotResponse(text: S.of(context).loginToUseChatbot);
    }

    String idToken;
    try {
      idToken = await user.getIdToken() ?? '';
    } catch (_) {
      return _BotResponse(text: S.of(context).failedGetToken);
    }

    if (idToken.isEmpty) {
      return _BotResponse(text: S.of(context).loginToUseChatbot);
    }

    // 2. POST to /deepsearch/chat
    try {
      final response = await http.post(
        Uri.parse(_chatEndpoint),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'session_id': _sessionId,
          'message': input,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        final body = response.body.trim();
        final errorMsg = body.isNotEmpty
            ? S.of(context).chatServiceError(response.statusCode.toString(), body)
            : S.of(context).chatServiceError(response.statusCode.toString(), '');
        return _BotResponse(text: errorMsg);
      }

      // 3. Parse response
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('application/json')) {
        final payload = jsonDecode(response.body);
        _captureSessionId(payload);
        final chat = _extractReply(payload) ?? jsonEncode(payload);
        final deep = _extractDeepSearch(payload);
        final parsedProducts = _extractProducts(payload);
        final fullText = deep != null ? '$chat\n\n$deep' : chat;
        return _BotResponse(text: fullText, products: parsedProducts);
      }

      final text = response.body.trim();
      final finalMsg = text.isNotEmpty ? text : _getLocalFallbackResponse(input);
      return _BotResponse(text: finalMsg);
    } catch (_) {
      return _BotResponse(text: _getLocalFallbackResponse(input));
    }
  }

  // ─────────────────────────────────────────────
  // Payload parsers — mirrors Angular extractReply()
  // ─────────────────────────────────────────────
  String? _extractReply(dynamic payload) {
    if (payload is String) return payload;
    if (payload is! Map) return null;

    final obj = payload as Map<String, dynamic>;
    const keys = [
      'chat_output', 'reply', 'response', 'text',
      'message', 'answer', 'content', 'output', 'detail',
    ];
    for (final key in keys) {
      if (obj[key] is String) return obj[key] as String;
    }
    for (final key in ['data', 'result']) {
      final extracted = _extractReply(obj[key]);
      if (extracted != null) return extracted;
    }
    return null;
  }

  void _captureSessionId(dynamic payload) {
    if (payload is! Map) return;
    final sid = (payload as Map<String, dynamic>)['session_id'];
    if (sid is String && sid.trim().isNotEmpty) _saveSessionId(sid.trim());
  }

  String? _extractDeepSearch(dynamic payload) {
    if (payload is! Map) return null;
    final deep = (payload as Map<String, dynamic>)['deep_search'];
    if (deep is! Map) return null;

    final deepObj = deep as Map<String, dynamic>;
    final products = deepObj['products'];
    if (products is List && products.isNotEmpty) {
      final lines = <String>[];
      for (final p in products.take(6)) {
        if (p is! Map) continue;
        final po = p as Map<String, dynamic>;
        final title = po['title']?.toString() ?? '';
        final price = po['price']?.toString() ?? '';
        final link  = po['link']?.toString() ?? '';
        final rating = po['rating'];
        final meta = [price, if (rating != null) 'rating $rating']
            .where((s) => s.isNotEmpty)
            .join(' • ');
        lines.add([title, meta, link].where((s) => s.isNotEmpty).join('\n'));
      }
      if (lines.isNotEmpty) return lines.join('\n\n');
    }

    final resultsText = deepObj['results_text'];
    if (resultsText is String && resultsText.trim().isNotEmpty) {
      return resultsText.trim();
    }
    return null;
  }

  // ─────────────────────────────────────────────
  // Local fallback — mirrors Angular getLocalFallbackResponse()
  // ─────────────────────────────────────────────
  String _getLocalFallbackResponse(String input) {
    final normalized = input.toLowerCase();
    for (final entry in _keywords.entries) {
      if (entry.value.any((word) => normalized.contains(word))) {
        return _randomResponse(entry.key);
      }
    }
    return _randomResponse('default');
  }

  String _randomResponse(String category) {
    final responsesMap = {
      'greeting': [
        S.of(context).botGreeting1,
        S.of(context).botGreeting2,
      ],
      'menu': [
        S.of(context).botMenu1,
        S.of(context).botMenu2,
      ],
      'order': [
        S.of(context).botOrder1,
        S.of(context).botOrder2,
      ],
      'delivery': [
        S.of(context).botDelivery1,
        S.of(context).botDelivery2,
      ],
      'charity': [
        S.of(context).botCharity1,
        S.of(context).botCharity2,
      ],
      'payment': [
        S.of(context).botPayment1,
        S.of(context).botPayment2,
      ],
      'contact': [
        S.of(context).botContact1,
        S.of(context).botContact2,
      ],
      'hours': [
        S.of(context).botHours1,
        S.of(context).botHours2,
      ],
      'thanks': [
        S.of(context).botThanks1,
        S.of(context).botThanks2,
      ],
      'default': [
        S.of(context).botDefault1,
        S.of(context).botDefault2,
      ],
    };
    final list = responsesMap[category] ?? responsesMap['default']!;
    return list[Random().nextInt(list.length)];
  }

  // ─────────────────────────────────────────────
  // Message list helpers
  // ─────────────────────────────────────────────
  void _addBotMessage(String text, {List<HomeFoodModel>? products}) {
    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isBot: true, time: DateTime.now(), products: products));
    });
  }

  void _addUserMessage(String text) {
    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isBot: false, time: DateTime.now()));
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeNotifier(),
      builder: (context, child) {
        final isDark = ThemeNotifier().isDarkMode;
        return Scaffold(
          backgroundColor: isDark ? const Color(0xff45337D) : const Color(0xffFDF0EE),
          body: Stack(
            children: [
              Opacity(
                opacity: 0.07,
                child: Image.asset(
                  'assets/images/Pattern.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(isDark),
                    Expanded(child: _buildMessageList(isDark)),
                    if (_isSending) _buildTypingIndicator(isDark),
                    _buildInputBar(isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff8966FA) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.chevron_left_rounded,
                  color: isDark ? Colors.white : Colors.black87, size: 24),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.smart_toy_rounded,
                    color: isDark ? Colors.white : AppColors.purple, size: 24),
                const SizedBox(width: 8),
                Text(
                  S.of(context).chatbot,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMessageList(bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) => _buildBubble(_messages[index], isDark),
    );
  }

  Widget _buildBubble(ChatMessage msg, bool isDark) {
    final isBot = msg.isBot;
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isBot 
              ? (isDark ? const Color(0xff8966FA) : const Color(0xffEDE8FF))
              : (isDark ? Colors.white : AppColors.purple),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isBot ? 4 : 18),
            bottomRight: Radius.circular(isBot ? 18 : 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: _buildBubbleContent(msg, isDark),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Rich Message Parsing and Rendering Helpers
  // ─────────────────────────────────────────────

  bool _isImageUrl(String url) {
    final cleanUrl = url.split('?').first.toLowerCase();
    return cleanUrl.endsWith('.png') ||
        cleanUrl.endsWith('.jpg') ||
        cleanUrl.endsWith('.jpeg') ||
        cleanUrl.endsWith('.gif') ||
        cleanUrl.endsWith('.webp') ||
        cleanUrl.endsWith('.bmp');
  }

  Future<void> _launchURL(String urlString) async {
    final Uri? uri = Uri.tryParse(urlString);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        try {
          await launchUrl(uri);
        } catch (err) {
          debugPrint('Could not launch $urlString: $err');
        }
      }
    }
  }

  HomeFoodModel _parseProductMap(Map<String, dynamic> po) {
    final id = po['id']?.toString() ?? po['meal_id']?.toString() ?? po['product_id']?.toString();
    final restaurantId = po['restaurant_id']?.toString() ?? 
                         po['restaurants_id']?.toString() ?? 
                         po['restaurantId']?.toString() ?? 
                         po['restaurant']?['id']?.toString() ?? 
                         po['restaurant']?['restaurant_id']?.toString() ?? 
                         '';
    final title = po['title']?.toString() ?? po['name']?.toString() ?? 'Meal';
    
    double price = 0.0;
    final rawPrice = po['price'];
    if (rawPrice is num) {
      price = rawPrice.toDouble();
    } else if (rawPrice != null) {
      price = double.tryParse(rawPrice.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    }
    
    double rate = 4.0;
    final rawRate = po['rating'] ?? po['rate'] ?? po['stars'];
    if (rawRate is num) {
      rate = rawRate.toDouble();
    } else if (rawRate != null) {
      rate = double.tryParse(rawRate.toString()) ?? 4.0;
    }
    
    String image = po['image']?.toString() ?? 
                   po['image_url']?.toString() ?? 
                   po['img_url']?.toString() ?? 
                   po['thumbnail']?.toString() ?? 
                   '';
                   
    final link = po['link']?.toString() ?? '';
    if (image.isEmpty && link.isNotEmpty && _isImageUrl(link)) {
      image = link;
    }
    
    final description = po['description']?.toString() ?? po['details']?.toString() ?? 'Delicious meal from Eat2Beat';
    final size = po['size']?.toString() ?? 'M';
    final restName = po['restaurant_name']?.toString() ?? 
                     po['rest_name']?.toString() ?? 
                     po['restaurant']?['name']?.toString() ?? 
                     po['restaurant']?['restaurant_name']?.toString() ?? 
                     'Restaurant';
    final restIcon = po['restaurant_icon']?.toString() ?? 
                     po['rest_icon']?.toString() ?? 
                     po['restaurant']?['logo_url']?.toString() ?? 
                     po['restaurant']?['img_url']?.toString() ?? 
                     po['restaurant']?['rest_img_url']?.toString() ?? 
                     '';
    final time = po['time']?.toString() ?? po['prep_time']?.toString() ?? po['delivery_time']?.toString() ?? '20 Min';

    return HomeFoodModel(
      id: id,
      restaurantId: restaurantId.isNotEmpty ? restaurantId : null,
      title: title,
      price: price,
      rate: rate,
      image: image.isNotEmpty ? image : 'assets/images/food.png',
      description: description,
      size: size,
      restName: restName,
      restIcon: restIcon.isNotEmpty ? restIcon : 'assets/images/burger_king.png',
      time: time,
    );
  }

  List<HomeFoodModel>? _extractProducts(dynamic payload) {
    if (payload is! Map) return null;
    final deep = (payload as Map<String, dynamic>)['deep_search'];
    if (deep is! Map) return null;

    final deepObj = deep as Map<String, dynamic>;
    final products = deepObj['products'];
    if (products is List && products.isNotEmpty) {
      final List<HomeFoodModel> list = [];
      for (final p in products) {
        if (p is! Map) continue;
        list.add(_parseProductMap(Map<String, dynamic>.from(p)));
      }
      return list;
    }
    return null;
  }

  HomeFoodModel? _getMatchingProduct(String url, List<HomeFoodModel>? products) {
    if (products == null) return null;
    final cleanUrl = url.trim().toLowerCase();
    for (final p in products) {
      final cleanImg = p.image.trim().toLowerCase();
      if (cleanImg.isNotEmpty && (cleanUrl.contains(cleanImg) || cleanImg.contains(cleanUrl))) {
        return p;
      }
    }
    return null;
  }

  List<_MessageContent> _parseMessageText(String text) {
    final List<_MessageContent> contents = [];
    final RegExp exp = RegExp(
      r'(!\[[^\]]*\]\([^\s)]+\))|(\[[^\]]+\]\([^\s)]+\))|(https?://[^\s)]+)',
      caseSensitive: false,
    );

    final matches = exp.allMatches(text);
    if (matches.isEmpty) {
      contents.add(_TextContent(text));
      return contents;
    }

    int lastMatchEnd = 0;
    for (final match in matches) {
      final beforeText = text.substring(lastMatchEnd, match.start);
      if (beforeText.isNotEmpty) {
        contents.add(_TextContent(beforeText));
      }

      final matchText = match.group(0)!;
      if (matchText.startsWith('![')) {
        final altStart = matchText.indexOf('[') + 1;
        final altEnd = matchText.indexOf(']');
        final urlStart = matchText.indexOf('(') + 1;
        final urlEnd = matchText.lastIndexOf(')');
        if (altEnd > altStart && urlEnd > urlStart) {
          final alt = matchText.substring(altStart, altEnd);
          final url = matchText.substring(urlStart, urlEnd);
          contents.add(_ImageContent(url, alt: alt));
        } else {
          contents.add(_TextContent(matchText));
        }
      } else if (matchText.startsWith('[')) {
        final textStart = matchText.indexOf('[') + 1;
        final textEnd = matchText.indexOf(']');
        final urlStart = matchText.indexOf('(') + 1;
        final urlEnd = matchText.lastIndexOf(')');
        if (textEnd > textStart && urlEnd > urlStart) {
          final linkText = matchText.substring(textStart, textEnd);
          final url = matchText.substring(urlStart, urlEnd);
          contents.add(_LinkContent(linkText, url));
        } else {
          contents.add(_TextContent(matchText));
        }
      } else {
        String url = matchText;
        String trailing = '';
        while (url.isNotEmpty && (url.endsWith('.') || url.endsWith(',') || url.endsWith('?') || url.endsWith(')'))) {
          trailing = url.substring(url.length - 1) + trailing;
          url = url.substring(0, url.length - 1);
        }

        if (_isImageUrl(url)) {
          contents.add(_ImageContent(url));
        } else {
          contents.add(_LinkContent(url, url));
        }

        if (trailing.isNotEmpty) {
          contents.add(_TextContent(trailing));
        }
      }

      lastMatchEnd = match.end;
    }

    final afterText = text.substring(lastMatchEnd);
    if (afterText.isNotEmpty) {
      contents.add(_TextContent(afterText));
    }

    return contents;
  }

  List<Widget> _buildBubbleContent(ChatMessage msg, bool isDark) {
    final contents = _parseMessageText(msg.text);
    final List<Widget> widgets = [];
    List<_MessageContent> inlineGroup = [];

    void flushInlineGroup() {
      if (inlineGroup.isEmpty) return;

      final List<InlineSpan> spans = [];
      for (final content in inlineGroup) {
        if (content is _TextContent) {
          spans.add(
            TextSpan(
              text: content.text,
              style: TextStyle(
                color: msg.isBot 
                    ? (isDark ? Colors.white : Colors.black87)
                    : (isDark ? const Color(0xff45337D) : Colors.white),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          );
        } else if (content is _LinkContent) {
          final matchingProd = _getMatchingProduct(content.url, msg.products);
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {
                  if (matchingProd != null) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailsRouteName,
                      arguments: matchingProd,
                    );
                  } else {
                    _launchURL(content.url);
                  }
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    content.text,
                    style: TextStyle(
                      color: msg.isBot
                          ? (isDark ? Colors.cyanAccent : const Color(0xff573BB0))
                          : (isDark ? const Color(0xff8966FA) : Colors.cyanAccent),
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }

      widgets.add(
        Text.rich(
          TextSpan(children: spans),
        ),
      );
      inlineGroup.clear();
    }

    for (final content in contents) {
      if (content is _ImageContent) {
        flushInlineGroup();
        widgets.add(_buildImageWidget(content.url, isBot: msg.isBot, isDark: isDark, alt: content.alt, products: msg.products));
      } else {
        inlineGroup.add(content);
      }
    }

    flushInlineGroup();

    if (widgets.length == 1) {
      return [widgets.first];
    } else {
      return widgets.map((w) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: w,
      )).toList();
    }
  }

  Widget _buildImageWidget(String url, {required bool isBot, required bool isDark, String alt = '', List<HomeFoodModel>? products}) {
    final matchingProd = _getMatchingProduct(url, products);
    return GestureDetector(
      onTap: () {
        if (matchingProd != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.detailsRouteName,
            arguments: matchingProd,
          );
        } else {
          _launchURL(url);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 150,
                  width: double.infinity,
                  color: isDark ? const Color(0xff5B429A) : const Color(0xffE6DFFF),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff5B429A) : const Color(0xffE6DFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.broken_image, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          alt.isNotEmpty ? alt : url,
                          style: TextStyle(
                            color: isBot 
                                ? (isDark ? Colors.white70 : Colors.black54)
                                : (isDark ? const Color(0xff45337D) : Colors.white70),
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff8966FA) : const Color(0xffEDE8FF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => _TypingDot(
              delay: Duration(milliseconds: i * 200),
              isDark: isDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff8966FA) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.attach_file_rounded,
              color: isDark ? Colors.white70 : AppColors.purple.withOpacity(0.7), size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: S.of(context).typeMessage,
                hintStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? Colors.white : AppColors.purple,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send_rounded, 
                  color: isDark ? const Color(0xff45337D) : Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated typing dot
// ─────────────────────────────────────────────
class _TypingDot extends StatefulWidget {
  final Duration delay;
  final bool isDark;
  const _TypingDot({required this.delay, required this.isDark});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = Tween(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: widget.isDark ? Colors.white : AppColors.purple,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Content Models
// ─────────────────────────────────────────────
abstract class _MessageContent {}

class _TextContent extends _MessageContent {
  final String text;
  _TextContent(this.text);
}

class _ImageContent extends _MessageContent {
  final String url;
  final String alt;
  _ImageContent(this.url, {this.alt = ''});
}

class _LinkContent extends _MessageContent {
  final String text;
  final String url;
  _LinkContent(this.text, this.url);
}

// ─────────────────────────────────────────────
// Bot Response Class
// ─────────────────────────────────────────────
class _BotResponse {
  final String text;
  final List<HomeFoodModel>? products;

  _BotResponse({required this.text, this.products});
}
