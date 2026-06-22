import 'package:eat2beat/features/charity/charity_resturants/widgets/colors_res.dart';
import 'package:eat2beat/features/charity/data/models/charity_models.dart';
import 'package:eat2beat/features/charity/presentation/cubit/charity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HistoryCharity extends StatefulWidget {
  const HistoryCharity({super.key});

  @override
  State<HistoryCharity> createState() => _HistoryCharityState();
}

class _HistoryCharityState extends State<HistoryCharity> {
  int _activeFilter = 0; // 0 = Today, 1 = This Week, 2 = Custom
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<String> _filterLabels = ['Today', 'This Week', 'Custom'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilter();
    });
  }

  void _applyFilter() {
    final cubit = context.read<CharityCubit>();
    if (_activeFilter == 0) {
      cubit.loadHistoryFiltered(time: 'today');
    } else if (_activeFilter == 1) {
      cubit.loadHistoryFiltered(time: 'thisweek');
    } else {
      if (_fromDate != null && _toDate != null) {
        // Adjust to date to include the entire day
        final adjustedTo = DateTime(
          _toDate!.year,
          _toDate!.month,
          _toDate!.day,
          23,
          59,
          59,
        );
        cubit.loadHistoryFiltered(
          time: 'custom',
          from: _fromDate!.toIso8601String(),
          to: adjustedTo.toIso8601String(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CharityCubit, CharityState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 8),
              _buildFilterChips(),
              if (_activeFilter == 2) ...[
                const SizedBox(height: 12),
                _buildDateRangeSelector(),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: state is CharityLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : state is CharityError
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'Error loading history: ${state.message}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red, fontSize: 13),
                              ),
                            ),
                          )
                        : state is CharityLoaded
                            ? RefreshIndicator(
                                color: AppColors.primary,
                                onRefresh: () async => _applyFilter(),
                                child: state.history.isEmpty
                                    ? ListView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.5,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.history_toggle_off_rounded,
                                                    size: 48,
                                                    color: AppColors.textSecondary.withOpacity(0.4),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    _activeFilter == 2 && (_fromDate == null || _toDate == null)
                                                        ? 'Please select a date range'
                                                        : 'No history records found',
                                                    style: const TextStyle(
                                                      color: AppColors.textSecondary,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.builder(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(bottom: 24),
                                        itemCount: state.history.length,
                                        itemBuilder: (context, idx) {
                                          final request = state.history[idx];
                                          return _buildHistoryCard(request);
                                        },
                                      ),
                              )
                            : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filterLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final isSelected = _activeFilter == idx;
          return GestureDetector(
            onTap: () {
              setState(() {
                _activeFilter = idx;
                if (idx != 2) {
                  _fromDate = null;
                  _toDate = null;
                  _applyFilter();
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _filterLabels[idx],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primaryChipText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _fromDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _fromDate = date;
                    if (_toDate != null && _fromDate!.isAfter(_toDate!)) {
                      _toDate = null;
                    }
                  });
                  _applyFilter();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      _fromDate == null
                          ? 'From'
                          : dateFormat.format(_fromDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: _fromDate == null ? AppColors.textSecondary : AppColors.textPrimary,
                        fontWeight: _fromDate == null ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _toDate ?? DateTime.now(),
                  firstDate: _fromDate ?? DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() {
                    _toDate = date;
                  });
                  _applyFilter();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      _toDate == null
                          ? 'To'
                          : dateFormat.format(_toDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: _toDate == null ? AppColors.textSecondary : AppColors.textPrimary,
                        fontWeight: _toDate == null ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(PickupRequest entry) {
    final code = entry.id.length > 6
        ? entry.id.substring(entry.id.length - 6)
        : entry.id;

    Color statusColor = entry.status == 'approved'
        ? AppColors.statusActive
        : entry.status == 'pending'
            ? AppColors.statusPending
            : AppColors.statusInactive;

    String dateStr = '';
    try {
      final parsed = DateTime.parse(entry.createdAt);
      dateStr = DateFormat('MMM dd, yyyy').format(parsed);
    } catch (_) {
      dateStr = entry.createdAt;
    }

    final isPickedUp = entry.pickedUp == 'picked_up' || entry.status == 'confirmed';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.donationImgUrl != null && entry.donationImgUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Image.network(
                entry.donationImgUrl!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Donation #$code',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        entry.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (entry.description != null) ...[
                  Text(
                    entry.description!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (entry.pickupLocation != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          entry.pickupLocation!,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
                Row(
                  children: [
                    const Icon(Icons.flag_outlined, size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Status: ',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    Text(
                      entry.status[0].toUpperCase() + entry.status.substring(1),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, size: 13, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Picked Up: ',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    Text(
                      isPickedUp ? 'Yes' : 'No',
                      style: TextStyle(
                        color: isPickedUp ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      dateStr,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
