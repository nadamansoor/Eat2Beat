import 'package:flutter/material.dart';

// ─── Colors ───────────────────────────────────────────────────────────
const _kBg      = Color(0xFFF5F7FA);
const _kCard    = Color(0xFFFFFFFF);
const _kBorder  = Color(0xFFEEF0F4);
const _kText    = Color(0xFF1A1D23);
const _kMuted   = Color(0xFF9499A5);
const _kPrimary = Color(0xFF6C63FF);
const _kRed     = Color(0xFFEF4444);

// ─── 1. Profile Avatar Section ────────────────────────────────────────
class ProfileAvatarSection extends StatelessWidget {
  final String? imagePath;
  final String restaurantName;
  final String email;
  final VoidCallback? onChangPhoto;

  const ProfileAvatarSection({
    super.key,
    this.imagePath,
    required this.restaurantName,
    required this.email,
    this.onChangPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      color: _kCard,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _kPrimary, width: 2.5),
                  color: const Color(0xFFDBEAFE),
                ),
                child: ClipOval(
                  child: imagePath != null
                      ? Image.asset(imagePath!, fit: BoxFit.cover)
                      : const Icon(Icons.store_rounded,
                          color: _kPrimary, size: 42),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onChangPhoto,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _kPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            restaurantName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _kText,
            ),
          ),
          const SizedBox(height: 4),
          Text(email,
              style: const TextStyle(fontSize: 13, color: _kMuted)),
        ],
      ),
    );
  }
}

// ─── 2. Settings Section Card ─────────────────────────────────────────
class SettingsSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _kMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// ─── 3. Settings Text Field Row ───────────────────────────────────────
class SettingsFieldRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color? iconColor;

  const SettingsFieldRow({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor ?? _kPrimary, size: 16),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _kText)),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 14, color: _kText),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: _kMuted),
              filled: true,
              fillColor: _kBg,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _kBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _kBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _kPrimary),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: _kBorder, height: 1),
        ],
      ),
    );
  }
}

// ─── 4. Settings Toggle Row ───────────────────────────────────────────
class SettingsToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;

  const SettingsToggleRow({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (iconColor ?? _kPrimary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon,
                    color: iconColor ?? _kPrimary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _kText)),
                    if (subtitle != null)
                      Text(subtitle!,
                          style: const TextStyle(
                              fontSize: 11, color: _kMuted)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: _kPrimary,
              ),
            ],
          ),
        ),
        const Divider(color: _kBorder, height: 1, indent: 16),
      ],
    );
  }
}

// ─── 5. Settings Tap Row (arrow) ──────────────────────────────────────
class SettingsTapRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  const SettingsTapRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (iconColor ?? _kPrimary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      color: iconColor ?? _kPrimary, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: labelColor ?? _kText,
                    ),
                  ),
                ),
                if (value != null)
                  Text(value!,
                      style: const TextStyle(
                          fontSize: 13, color: _kMuted)),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded,
                    color: _kMuted, size: 20),
              ],
            ),
          ),
        ),
        const Divider(color: _kBorder, height: 1, indent: 16),
      ],
    );
  }
}

// ─── 6. Save Button ───────────────────────────────────────────────────
class ProfileSaveButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const ProfileSaveButton({
    super.key,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9B8FFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _kPrimary.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                ),
              )
            : const Text(
                'حفظ التغييرات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ─── 7. Logout Button ─────────────────────────────────────────────────
class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ProfileLogoutButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: _kRed.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kRed.withOpacity(0.3)),
        ),
        child: const Text(
          'تسجيل الخروج',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _kRed,
          ),
        ),
      ),
    );
  }
}