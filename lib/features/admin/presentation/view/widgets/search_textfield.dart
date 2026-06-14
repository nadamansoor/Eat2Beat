import 'package:eat2beat/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchTextField({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _showClearButton = widget.controller!.text.isNotEmpty;
      widget.controller!.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = widget.controller!.text.isNotEmpty;
    if (hasText != _showClearButton) {
      setState(() {
        _showClearButton = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _showClearButton
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.controller?.clear();
                    widget.onChanged?.call('');
                  },
                )
              : null,
          hintStyle: AppStyles.black16Bold.copyWith(
            color: const Color.fromARGB(255, 202, 201, 201),
          ),
          hintText: 'Search',
          filled: true,
          fillColor: const Color(0xFFF9FAFA),
          border: buildBorder(),
          enabledBorder: buildBorder(),
          focusedBorder: buildBorder(),
        ),
      ),
    );
  }
}

OutlineInputBorder buildBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color(0xFFE6E9E9),
      width: 1,
    ),
  );
}