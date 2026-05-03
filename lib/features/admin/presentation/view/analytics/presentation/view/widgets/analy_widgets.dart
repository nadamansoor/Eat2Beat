import 'package:eat2beat/features/admin/presentation/view/analytics/domain/entities/analytics_entity.dart';
import 'package:flutter/material.dart';

// ─── Design tokens ────────────────────────────────────────────────────
const _kBg         = Color(0xFF0F0E1A);
const _kSurface    = Color(0xFF1A1830);
const _kSurface2   = Color(0xFF221F38);
const _kPrimary    = Color(0xFF7C6FFF);
const _kAccent     = Color(0xFFFFC542);
const _kGreen      = Color(0xFF2ECC71);
const _kRed        = Color(0xFFFF5E5E);
const _kTextMain   = Color(0xFFEEECFF);
const _kTextSub    = Color(0xFF8B87B8);
const _kBorder     = Color(0xFF2E2B4A);

// ─── Helpers ──────────────────────────────────────────────────────────
Color demandColor(DemandLevel d) {
  switch (d) {
    case DemandLevel.high:   return _kRed;
    case DemandLevel.medium: return _kAccent;
    case DemandLevel.low:    return _kGreen;
  }
}

String demandLabel(DemandLevel d) {
  switch (d) {
    case DemandLevel.high:   return 'مرتفع';
    case DemandLevel.medium: return 'متوسط';
    case DemandLevel.low:    return 'منخفض';
  }
}

// ─── 1. Header ────────────────────────────────────────────────────────
class AnalyticsHeader extends StatelessWidget {
  final String restaurantId;
  final VoidCallback? onNotification;
  final VoidCallback? onRefresh;

  const AnalyticsHeader({
    super.key,
    required this.restaurantId,
    this.onNotification,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _kPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant_menu_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EAT2Beat — لوحة المطعم',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _kTextMain,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                Row(
                  children: [
                    Container(
                      width: 7, height: 7,
                      decoration: const BoxDecoration(
                        color: _kGreen, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'قوة إقع الطلب الذكي — تلقاني 100',
                      style: const TextStyle(
                          fontSize: 11, color: _kTextSub),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: onNotification,
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: _kSurface2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kBorder),
                  ),
                  child: const Icon(Icons.notifications_none_rounded,
                      color: _kTextMain, size: 20),
                ),
              ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                      color: _kRed, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── 2. Restaurant selector bar ───────────────────────────────────────
class RestaurantSelectorBar extends StatelessWidget {
  final String restaurantId;
  final VoidCallback? onRefresh;

  const RestaurantSelectorBar({
    super.key,
    required this.restaurantId,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _kPrimary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.refresh_rounded, color: _kPrimary, size: 16),
                  SizedBox(width: 6),
                  Text('تحديث',
                      style: TextStyle(
                          color: _kPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.keyboard_arrow_down_rounded,
              color: _kTextSub, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              restaurantId,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: _kTextSub, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _kSurface2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.grid_view_rounded,
                color: _kPrimary, size: 16),
          ),
        ],
      ),
    );
  }
}

// ─── 3. Date info bar ─────────────────────────────────────────────────
class DateInfoBar extends StatelessWidget {
  final String dateLabel;
  final String dayName;
  final String dayType;
  final bool isOfficialHoliday;

  const DateInfoBar({
    super.key,
    required this.dateLabel,
    required this.dayName,
    required this.dayType,
    required this.isOfficialHoliday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoChip(
            icon: Icons.calendar_today_rounded,
            label: 'التاريخ',
            value: dateLabel,
            iconColor: _kPrimary,
          ),
          _divider(),
          _InfoChip(
            icon: Icons.calendar_month_rounded,
            label: 'اليوم',
            value: dayName,
            iconColor: _kAccent,
          ),
          _divider(),
          _InfoChip(
            icon: Icons.nights_stay_rounded,
            label: 'نوع اليوم',
            value: dayType,
            valueColor: _kGreen,
            iconColor: _kGreen,
          ),
          _divider(),
          _InfoChip(
            icon: Icons.beach_access_rounded,
            label: 'إجازة رسمية',
            value: isOfficialHoliday ? 'نعم' : 'لا',
            valueColor: isOfficialHoliday ? _kRed : _kTextSub,
            iconColor: _kTextSub,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
      width: 1, height: 32, color: _kBorder);
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color? valueColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 9, color: _kTextSub)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: valueColor ?? _kTextMain)),
      ],
    );
  }
}

// ─── 4. Section title ─────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: (iconColor ?? _kPrimary).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor ?? _kPrimary, size: 18),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _kTextMain)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: const TextStyle(
                          fontSize: 11, color: _kTextSub)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 5. Stat Card (2-per-row grid) ────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String sublabel;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.label,
    required this.sublabel,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Text(
                sublabel,
                style: const TextStyle(fontSize: 10, color: _kTextSub),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: _kTextSub),
          ),
        ],
      ),
    );
  }
}

// ─── 6. Demand Badge (inside stat grid) ──────────────────────────────
class DemandBadgeCard extends StatelessWidget {
  final DemandLevel level;

  const DemandBadgeCard({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = demandColor(level);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.speed_rounded, color: color, size: 18),
              ),
              Text('التصنيف التلقاني',
                  style:
                      const TextStyle(fontSize: 10, color: _kTextSub)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Text(
              demandLabel(level),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color),
            ),
          ),
          const SizedBox(height: 4),
          const Text('مستوى الطلب',
              style: TextStyle(fontSize: 11, color: _kTextSub)),
        ],
      ),
    );
  }
}

// ─── 7. Demand Alert Banner ───────────────────────────────────────────
class DemandAlertBanner extends StatelessWidget {
  final DemandLevel level;
  final String dateLabel;

  const DemandAlertBanner(
      {super.key, required this.level, required this.dateLabel});

  @override
  Widget build(BuildContext context) {
    final color = demandColor(level);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(dateLabel,
                  style:
                      const TextStyle(fontSize: 11, color: _kTextSub)),
              const SizedBox(width: 6),
              const Icon(Icons.calendar_today_rounded,
                  color: _kTextSub, size: 13),
              const Spacer(),
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                    color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                'الطلب ${demandLabel(level)} اليوم',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'إقبال معقول متوقع. حافظ على التجهيز الاعتيادي وناهد من كفاءة الفريق في وقت الذروة.',
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: 12, color: _kTextSub, height: 1.5),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: [
                _ActionBtn('تجهز اعتيادي', _kPrimary),
                const SizedBox(width: 8),
                _ActionBtn('راقب التدفق', _kAccent),
                const SizedBox(width: 8),
                _ActionBtn('جهز فريق احتياطي', _kGreen),
                const SizedBox(width: 8),
                _ActionBtn('تابع الطلبات', _kSurface2,
                    textColor: _kTextMain),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const _ActionBtn(this.label, this.color, {this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(textColor != null ? 1 : 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor ?? color),
      ),
    );
  }
}

// ─── 8. Day Forecast Card (horizontal carousel) ───────────────────────
class DayForecastCard extends StatelessWidget {
  final DayForecast day;

  const DayForecastCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final color = demandColor(day.demand);
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: day.isToday
            ? _kPrimary.withOpacity(0.2)
            : _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: day.isToday ? _kPrimary : _kBorder,
          width: day.isToday ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          if (day.isToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _kPrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('اليوم',
                  style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          if (day.isToday) const SizedBox(height: 6),
          Text(day.dayName,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: day.isToday ? _kPrimary : _kTextSub)),
          const SizedBox(height: 2),
          Text(day.dateLabel,
              style: const TextStyle(fontSize: 9, color: _kTextSub)),
          const SizedBox(height: 10),
          Text(
            '${day.visitors}',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: day.isToday ? _kTextMain : _kTextMain),
          ),
          const SizedBox(height: 8),
          Container(
            width: 8, height: 8,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: 3),
          Text(demandLabel(day.demand),
              style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── 9. Historical bar row ────────────────────────────────────────────
class HistoricalBarRow extends StatelessWidget {
  final HistoricalDay day;
  final int maxVisitors;

  const HistoricalBarRow(
      {super.key, required this.day, required this.maxVisitors});

  @override
  Widget build(BuildContext context) {
    final ratio = maxVisitors > 0 ? day.visitors / maxVisitors : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              day.dateLabel,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 11, color: _kTextSub),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 10,
                backgroundColor: _kSurface2,
                valueColor: AlwaysStoppedAnimation(
                  Color.lerp(_kPrimary, const Color(0xFFB060FF), ratio) ?? _kPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${day.visitors}',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _kTextMain),
          ),
        ],
      ),
    );
  }
}

// ─── 10. Summary card ─────────────────────────────────────────────────
class SummaryCard extends StatelessWidget {
  final String restaurantId;
  final String dayNumber;
  final int lag7;
  final double rollingMean7;
  final int visitorsToday;
  final DemandLevel demandLevel;

  const SummaryCard({
    super.key,
    required this.restaurantId,
    required this.dayNumber,
    required this.lag7,
    required this.rollingMean7,
    required this.visitorsToday,
    required this.demandLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        children: [
          _Row('المطعم', restaurantId, _kPrimary),
          _Row('رقم اليوم', dayNumber, _kAccent),
          _Row('lag_7', '$lag7 راتر', _kTextMain),
          _Row('rolling_mean_7', '${rollingMean7.toStringAsFixed(1)} راتر', _kTextMain),
          _Row('زوار المتوقعون', '$visitorsToday راتر', _kTextMain),
          _Row('مستوى الطلب', demandLabel(demandLevel),
              demandColor(demandLevel)),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _Row(this.label, this.value, this.valueColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: valueColor)),
          Text(label,
              style: const TextStyle(fontSize: 12, color: _kTextSub)),
        ],
      ),
    );
  }
}

// ─── Loading skeleton ─────────────────────────────────────────────────
class AnalyticsSkeleton extends StatefulWidget {
  const AnalyticsSkeleton({super.key});

  @override
  State<AnalyticsSkeleton> createState() => _AnalyticsSkeletonState();
}

class _AnalyticsSkeletonState extends State<AnalyticsSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(_ctrl);
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
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _skeletonBox(height: 56, radius: 14),
              const SizedBox(height: 12),
              _skeletonBox(height: 72, radius: 14),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _skeletonBox(height: 100, radius: 14)),
                const SizedBox(width: 12),
                Expanded(child: _skeletonBox(height: 100, radius: 14)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _skeletonBox(height: 100, radius: 14)),
                const SizedBox(width: 12),
                Expanded(child: _skeletonBox(height: 100, radius: 14)),
              ]),
              const SizedBox(height: 12),
              _skeletonBox(height: 130, radius: 14),
              const SizedBox(height: 12),
              _skeletonBox(height: 160, radius: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _skeletonBox({required double height, double radius = 8}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: _kSurface2,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────
class AnalyticsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AnalyticsErrorView(
      {super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: _kRed, size: 48),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _kTextSub, fontSize: 13)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _kPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('إعادة المحاولة',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}