import 'package:eat2beat/core/services/theme_notifier.dart';
import 'dart:convert';
import 'dart:math' show Random;
import 'package:eat2beat/core/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────
class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime time;

  const ChatMessage({
    required this.text,
    required this.isBot,
    required this.time,
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
  static const Map<String, List<String>> _responses = {
    'greeting': [
      'Hello! Welcome to EAT2Beat! 🍽️ How can I help you today?',
      'Hi there! I\'m your EAT2Beat assistant. What can I do for you?',
    ],
    'menu': [
      'You can view our full menu by navigating to the Home tab. We have delicious organic meals! 🥗',
      'Check out our Menu section for a variety of healthy, freshly prepared meals.',
    ],
    'order': [
      'To place an order, browse our menu and add items to your cart, then proceed to checkout! 🛒',
      'Ordering is easy! Just add items to your cart and we\'ll deliver within 30 minutes.',
    ],
    'delivery': [
      'We deliver in 30 minutes or less! 🚀 Our delivery team works 24/7.',
      'Fast delivery is our specialty. Expect your food hot and fresh in about 30 minutes.',
    ],
    'charity': [
      'We partner with local NGOs to donate surplus food. Visit our Donation tab to learn more! 💝',
      'EAT2Beat is committed to reducing food waste. Check out our Donation section.',
    ],
    'payment': [
      'We accept all major credit cards, PayPal, and cash on delivery. 💳',
      'Multiple payment options available: Credit Card, PayPal, or Cash on Delivery.',
    ],
    'contact': [
      'You can reach us at support@eat2beat.com or call 1-800-EAT2BEAT. 📞',
      'Need help? Contact our support team via email or phone!',
    ],
    'hours': [
      'We\'re open 24/7! Order anytime, we\'re always here to serve you. ⏰',
      'EAT2Beat never sleeps! Place your order any time, day or night.',
    ],
    'thanks': [
      'You\'re welcome! Is there anything else I can help with? 😊',
      'Happy to help! Let me know if you need anything else!',
    ],
    'default': [
      'I\'m not sure I understand. Try asking about our menu, orders, delivery, or charity work. 🤖',
      'I can help with questions about menu, ordering, delivery, charity, and more. What would you like to know?',
    ],
  };

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
    _addBotMessage(_randomResponse('greeting'));
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

    _getBotResponse(text).then((reply) {
      _addBotMessage(reply);
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
  Future<String> _getBotResponse(String input) async {
    // 1. Get Firebase ID token
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Please log in first to use the chatbot.';

    String idToken;
    try {
      idToken = await user.getIdToken() ?? '';
    } catch (_) {
      return 'Failed to get authentication token. Please try again.';
    }

    if (idToken.isEmpty) return 'Please log in first to use the chatbot.';

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
        return body.isNotEmpty
            ? 'Chat service error (${response.statusCode}): $body'
            : 'Chat service error (${response.statusCode}).';
      }

      // 3. Parse response
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('application/json')) {
        final payload = jsonDecode(response.body);
        _captureSessionId(payload);
        final chat = _extractReply(payload) ?? jsonEncode(payload);
        final deep = _extractDeepSearch(payload);
        return deep != null ? '$chat\n\n$deep' : chat;
      }

      final text = response.body.trim();
      return text.isNotEmpty ? text : _getLocalFallbackResponse(input);
    } catch (_) {
      return _getLocalFallbackResponse(input);
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
    final list = _responses[category] ?? _responses['default']!;
    return list[Random().nextInt(list.length)];
  }

  // ─────────────────────────────────────────────
  // Message list helpers
  // ─────────────────────────────────────────────
  void _addBotMessage(String text) {
    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isBot: true, time: DateTime.now()));
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
                  'Chatbot',
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
        child: Text(
          msg.text,
          style: TextStyle(
            color: isBot 
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark ? const Color(0xff45337D) : Colors.white),
            fontSize: 14,
            height: 1.5,
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
                hintText: 'Type a message...',
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
