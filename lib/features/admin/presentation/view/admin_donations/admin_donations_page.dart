import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eat2beat/features/admin/presentation/cubits/admin_donation_cubit/admin_donation_cubit.dart';
import 'package:eat2beat/features/admin/presentation/cubits/admin_donation_cubit/admin_donation_state.dart';
import 'package:eat2beat/features/admin/data/models/admin_donation_models.dart';
import 'package:eat2beat/features/admin/presentation/view/admin_home/const.dart';
import 'donation_details_page.dart';
import 'charity_profile_page.dart';

class AdminDonationPage extends StatefulWidget {
  const AdminDonationPage({super.key});

  @override
  State<AdminDonationPage> createState() => _AdminDonationPageState();
}

class _AdminDonationPageState extends State<AdminDonationPage> {
  int _activeSubTab = 0; // 0: Add Donation, 1: Pickup Requests, 2: Schedules, 3: History, 4: My Donations, 5: Charities, 6: Notifications

  final List<String> _subTabNames = [
    'Add Donation',
    'Pickup Requests',
    'Schedules',
    'History',
    'My Donations',
    'Charities',
    'Notifications'
  ];

  // Search controller for Charities search
  final TextEditingController _charitySearchController = TextEditingController();

  // Add Donation Form State
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String? _donationImgBase64;
  String? _donationImgPath;

  // List of added donation items
  final List<Map<String, dynamic>> _addedItems = [];

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load all data on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminDonationCubit>().loadAll();
    });
  }

  @override
  void dispose() {
    _charitySearchController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String _mimeTypeFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }

  Future<void> _pickDonationImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        final mimeType = _mimeTypeFromPath(image.path);
        final rawBase64 = base64Encode(bytes);
        setState(() {
          _donationImgBase64 = 'data:$mimeType;base64,$rawBase64';
          _donationImgPath = image.path;
        });
      }
    } catch (e) {
      _showSnackbar('Failed to pick image: $e', isError: true);
    }
  }

  Future<void> _pickItemImage(int index) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        final mimeType = _mimeTypeFromPath(image.path);
        final rawBase64 = base64Encode(bytes);
        setState(() {
          _addedItems[index]['donation_item_img_base64'] = 'data:$mimeType;base64,$rawBase64';
          _addedItems[index]['image_path'] = image.path;
        });
      }
    } catch (e) {
      _showSnackbar('Failed to pick image: $e', isError: true);
    }
  }

  void _addItemForm() {
    setState(() {
      _addedItems.add({
        'name_controller': TextEditingController(),
        'qty_controller': TextEditingController(text: '1'),
        'desc_controller': TextEditingController(),
        'donation_item_img_base64': '',
        'image_path': null,
      });
    });
  }

  void _removeItemForm(int index) {
    setState(() {
      _addedItems[index]['name_controller'].dispose();
      _addedItems[index]['qty_controller'].dispose();
      _addedItems[index]['desc_controller'].dispose();
      _addedItems.removeAt(index);
    });
  }

  void _clearAddDonationForm() {
    setState(() {
      _descriptionController.clear();
      _locationController.clear();
      _donationImgBase64 = null;
      _donationImgPath = null;
      for (var item in _addedItems) {
        item['name_controller'].dispose();
        item['qty_controller'].dispose();
        item['desc_controller'].dispose();
      }
      _addedItems.clear();
    });
  }

  void _submitDonation() {
    if (!_formKey.currentState!.validate()) return;
    if (_donationImgBase64 == null) {
      _showSnackbar('Please select an image for the donation post.', isError: true);
      return;
    }

    final items = <Map<String, dynamic>>[];
    for (var item in _addedItems) {
      final name = item['name_controller'].text.trim();
      final qtyStr = item['qty_controller'].text.trim();
      final desc = item['desc_controller'].text.trim();
      final img = item['donation_item_img_base64'];

      if (name.isEmpty) {
        _showSnackbar('Please specify a name for all items.', isError: true);
        return;
      }
      final qty = int.tryParse(qtyStr) ?? 0;
      if (qty <= 0) {
        _showSnackbar('Quantity must be greater than 0.', isError: true);
        return;
      }
      if (img.isEmpty) {
        _showSnackbar('Please select an image for item: $name', isError: true);
        return;
      }

      items.add({
        'item_name': name,
        'quantity': qty,
        'description': desc.isNotEmpty ? desc : null,
        'donation_item_img_base64': img,
      });
    }

    context.read<AdminDonationCubit>().addDonation(
          description: _descriptionController.text.trim(),
          pickupLocation: _locationController.text.trim(),
          donationImgBase64: _donationImgBase64!,
          items: items,
        );
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? kRed : kGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Date and Time picker dialog logic for Scheduling / Rescheduling
  Future<void> _showScheduleBottomSheet({
    required BuildContext context,
    required String title,
    String? pickupId,
    String? scheduleId,
    String? existingNotes,
  }) async {
    final notesController = TextEditingController(text: existingNotes);
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (stContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(stContext).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kText),
                  ),
                  const SizedBox(height: 20),

                  // Date Picker Trigger
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: kPrimary),
                    title: Text(
                      selectedDate == null
                          ? 'Select Date'
                          : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: stContext,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) {
                        setSheetState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const Divider(),

                  // Time Picker Trigger
                  ListTile(
                    leading: const Icon(Icons.access_time, color: kPrimary),
                    title: Text(
                      selectedTime == null ? 'Select Time' : selectedTime!.format(stContext),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: stContext,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setSheetState(() => selectedTime = picked);
                      }
                    },
                  ),
                  const Divider(),

                  // Optional Notes
                  const SizedBox(height: 10),
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Additional notes / instructions...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedDate == null || selectedTime == null) {
                          ScaffoldMessenger.of(stContext).showSnackBar(
                            const SnackBar(content: Text('Please choose date & time.')),
                          );
                          return;
                        }

                        // Combine date and time
                        final combinedDateTime = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );

                        final dateString = combinedDateTime.toIso8601String();
                        final notes = notesController.text.trim();

                        final cubit = context.read<AdminDonationCubit>();
                        if (pickupId != null) {
                          cubit.schedulePickup(pickupId, dateString, notes.isNotEmpty ? notes : null);
                        } else if (scheduleId != null) {
                          cubit.reschedulePickup(scheduleId, dateString, notes.isNotEmpty ? notes : null);
                        }

                        Navigator.pop(sheetContext);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Save Details', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: BlocConsumer<AdminDonationCubit, AdminDonationState>(
        listener: (context, state) {
          if (state is AdminDonationLoaded) {
            if (state.errorMessage != null) {
              _showSnackbar(state.errorMessage!, isError: true);
              context.read<AdminDonationCubit>().clearAlerts();
            }
            if (state.successMessage != null) {
              _showSnackbar(state.successMessage!);
              context.read<AdminDonationCubit>().clearAlerts();

              // If add donation succeeds, switch back to 'My Donations' sub-tab
              if (_activeSubTab == 0 && state.successMessage!.contains('Donation created')) {
                _clearAddDonationForm();
                setState(() => _activeSubTab = 4);
              }
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Custom Header
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Donations Portal',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kText),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _subTabNames[_activeSubTab],
                            style: const TextStyle(fontSize: 14, color: kMuted),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: kPrimary),
                        onPressed: () => context.read<AdminDonationCubit>().loadAll(),
                      )
                    ],
                  ),
                ),

                // Sub-Tab Horizontal Bar
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _subTabNames.length,
                    itemBuilder: (context, index) {
                      final isSelected = _activeSubTab == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_subTabNames[index]),
                          selected: isSelected,
                          selectedColor: kPrimary,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : kText,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: isSelected ? kPrimary : kBorder),
                          ),
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                _activeSubTab = index;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Main Render Content
                Expanded(
                  child: _buildSubTabContent(state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubTabContent(AdminDonationState state) {
    if (state is AdminDonationLoading) {
      return const Center(child: CircularProgressIndicator(color: kPrimary));
    }
    if (state is AdminDonationError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, style: const TextStyle(color: kRed, fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<AdminDonationCubit>().loadAll(),
              style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (state is! AdminDonationLoaded) {
      return const Center(child: Text('No donation data loaded.'));
    }

    switch (_activeSubTab) {
      case 0:
        return _buildAddDonationForm(state);
      case 1:
        return _buildPickupRequests(state);
      case 2:
        return _buildSchedules(state);
      case 3:
        return _buildHistory(state);
      case 4:
        return _buildMyDonations(state);
      case 5:
        return _buildCharities(state);
      case 6:
        return _buildNotifications(state);
      default:
        return const SizedBox();
    }
  }

  // 1. Pickup Requests UI
  Widget _buildPickupRequests(AdminDonationLoaded state) {
    final list = state.pickupRequests;
    if (list.isEmpty) {
      return _buildEmptyState(
        icon: Icons.volunteer_activism_outlined,
        title: 'No Pickup Requests',
        subtitle: 'When charities request to pick up your food, they will appear here.',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final pr = list[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: kBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pr.charityName ?? 'Charity Request',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kText),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: pr.status == 'pending'
                            ? kPreparingBg
                            : pr.status == 'approved'
                                ? kGreenBg
                                : kRedBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        pr.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: pr.status == 'pending'
                              ? kPreparing
                              : pr.status == 'approved'
                                  ? kGreen
                                  : kRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Donation ID: ${pr.donationId}',
                  style: const TextStyle(color: kMuted, fontSize: 12),
                ),
                if (pr.description != null && pr.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    pr.description!,
                    style: const TextStyle(fontSize: 13, color: kText),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: kMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pr.pickupLocation ?? 'Not specified',
                        style: const TextStyle(fontSize: 12, color: kMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (pr.status == 'pending') ...[
                      TextButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () => context.read<AdminDonationCubit>().rejectRequest(pr.id),
                        child: const Text('Reject', style: TextStyle(color: kRed)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () => context.read<AdminDonationCubit>().approveRequest(pr.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Approve', style: TextStyle(color: Colors.white)),
                      ),
                    ] else if (pr.status == 'approved') ...[
                      ElevatedButton.icon(
                        onPressed: () => _showScheduleBottomSheet(
                          context: context,
                          title: 'Schedule Pickup',
                          pickupId: pr.id,
                        ),
                        icon: const Icon(Icons.schedule, size: 16, color: Colors.white),
                        label: const Text('Schedule', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 2. Schedules UI
  Widget _buildSchedules(AdminDonationLoaded state) {
    final list = state.schedules;
    if (list.isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today_outlined,
        title: 'No Upcoming Schedules',
        subtitle: 'Schedules approved by you for pickup appear here.',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final sc = list[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: kBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sc.charityName ?? 'Scheduled Pickup',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kText),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: sc.status == 'pending'
                            ? kPreparingBg
                            : sc.status == 'confirmed'
                                ? kGreenBg
                                : kRedBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        sc.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: sc.status == 'pending'
                              ? kPreparing
                              : sc.status == 'confirmed'
                                  ? kGreen
                                  : kRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: kPrimary),
                    const SizedBox(width: 8),
                    Text(
                      sc.scheduledAt.split('.').first.replaceFirst('T', ' at '),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kText),
                    ),
                  ],
                ),
                if (sc.notes != null && sc.notes!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Notes: ${sc.notes!}',
                    style: const TextStyle(fontSize: 13, color: kMuted),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: kMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        sc.pickupLocation ?? 'Not specified',
                        style: const TextStyle(fontSize: 12, color: kMuted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showScheduleBottomSheet(
                        context: context,
                        title: 'Reschedule Pickup',
                        scheduleId: sc.id,
                        existingNotes: sc.notes,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Reschedule', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 3. History UI
  Widget _buildHistory(AdminDonationLoaded state) {
    final list = state.history;
    if (list.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'Empty History Log',
        subtitle: 'Past donation records will be listed here.',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final d = list[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: kBorder),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Hero(
              tag: 'donation-img-${d.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: d.donationImgUrl.isNotEmpty
                    ? Image.network(d.donationImgUrl, width: 50, height: 50, fit: BoxFit.cover)
                    : Container(
                        width: 50,
                        height: 50,
                        color: kPrimary.withOpacity(0.1),
                        child: const Icon(Icons.volunteer_activism, color: kPrimary, size: 24),
                      ),
              ),
            ),
            title: Text(
              d.description ?? 'Donation Entry',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Date: ${d.createdAt.split('T').first}', style: const TextStyle(fontSize: 12, color: kMuted)),
              ],
            ),
            trailing: Text(
              d.pickedUp.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: d.pickedUp.toLowerCase() == 'completed' ? kGreen : kMuted,
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DonationDetailsPage(donation: d)),
            ),
          ),
        );
      },
    );
  }

  // 4. My Donations UI
  Widget _buildMyDonations(AdminDonationLoaded state) {
    final list = state.donations;
    if (list.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No Donations Found',
        subtitle: 'You haven\'t posted any active donations yet.',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final d = list[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: kBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        d.description ?? 'Donation Post',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: d.isAvailable ? kGreenBg : kRedBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        d.isAvailable ? 'Available' : 'Claimed',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: d.isAvailable ? kGreen : kRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: kMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        d.pickupLocation ?? 'Not specified',
                        style: const TextStyle(fontSize: 12, color: kMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DonationDetailsPage(donation: d)),
                      ),
                      child: const Text('View Items', style: TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: kRed),
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (c) => AlertDialog(
                                  title: const Text('Delete Donation?'),
                                  content: const Text('Are you sure you want to remove this active donation?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(c),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(c);
                                        context.read<AdminDonationCubit>().deleteDonation(d.id);
                                      },
                                      child: const Text('Delete', style: TextStyle(color: kRed)),
                                    ),
                                  ],
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 5. Add Donation UI
  Widget _buildAddDonationForm(AdminDonationLoaded state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Post New Donation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kText)),
            const SizedBox(height: 16),

            // Description Input
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: kText),
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the food items, storage info, etc.',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 3,
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a description.' : null,
            ),
            const SizedBox(height: 16),

            // Location Input
            TextFormField(
              controller: _locationController,
              style: const TextStyle(color: kText),
              decoration: InputDecoration(
                labelText: 'Pickup Location',
                hintText: 'Address/Location where the charity will pick it up',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.location_on, color: kPrimary),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Please specify a pickup location.' : null,
            ),
            const SizedBox(height: 20),

            // Donation Image Picker
            const Text('Donation Banner Image', style: TextStyle(fontWeight: FontWeight.bold, color: kText)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDonationImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kBorder),
                ),
                child: _donationImgPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_donationImgPath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 40, color: kMuted),
                          SizedBox(height: 8),
                          Text('Pick Gallery Image', style: TextStyle(color: kMuted)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Items Sub-Form Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Donation Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kText)),
                TextButton.icon(
                  onPressed: _addItemForm,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Item Cards list
            if (_addedItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kPrimary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kPrimary.withOpacity(0.1)),
                ),
                child: const Center(
                  child: Text(
                    'No items added yet. Click "Add Item" above to attach food items.',
                    style: TextStyle(color: kPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _addedItems.length,
                itemBuilder: (context, index) {
                  final item = _addedItems[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: kBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Item #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: kRed, size: 18),
                                onPressed: () => _removeItemForm(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: item['name_controller'],
                            style: const TextStyle(color: kText),
                            decoration: const InputDecoration(labelText: 'Item Name (e.g. Rice meal)'),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: item['qty_controller'],
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: kText),
                                  decoration: const InputDecoration(labelText: 'Quantity'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: item['desc_controller'],
                                  style: const TextStyle(color: kText),
                                  decoration: const InputDecoration(labelText: 'Notes/Expiry (optional)'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Item Photo picker
                          GestureDetector(
                            onTap: () => _pickItemImage(index),
                            child: Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: kBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kBorder),
                              ),
                              child: item['image_path'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(item['image_path']!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt_outlined, color: kMuted, size: 20),
                                        SizedBox(width: 8),
                                        Text('Pick Item Image', style: TextStyle(color: kMuted, fontSize: 13)),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: state.isSubmitting ? null : _submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: state.isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Post Donation', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 6. Charities Search UI
  Widget _buildCharities(AdminDonationLoaded state) {
    return Column(
      children: [
        // Search textfield
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: TextField(
            controller: _charitySearchController,
            decoration: InputDecoration(
              hintText: 'Search charities by name...',
              prefixIcon: const Icon(Icons.search, color: kMuted),
              suffixIcon: _charitySearchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: kMuted),
                      onPressed: () {
                        _charitySearchController.clear();
                        context.read<AdminDonationCubit>().searchCharities('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (val) {
              context.read<AdminDonationCubit>().searchCharities(val);
            },
          ),
        ),

        // List
        Expanded(
          child: state.charities.isEmpty
              ? _buildEmptyState(
                  icon: Icons.business_outlined,
                  title: 'No Charities Found',
                  subtitle: 'Try searching for another charity organization.',
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: state.charities.length,
                  itemBuilder: (context, index) {
                    final ch = state.charities[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: kBorder),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: ch.logoUrl != null && ch.logoUrl!.isNotEmpty
                              ? Image.network(ch.logoUrl!, width: 50, height: 50, fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) =>
                                      Container(color: kPrimary.withOpacity(0.1), width: 50, height: 50))
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: kPrimary.withOpacity(0.1),
                                  child: const Icon(Icons.business, color: kPrimary),
                                ),
                        ),
                        title: Text(ch.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          ch.description ?? 'No description',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: kMuted, fontSize: 12),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: kMuted),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CharityProfilePage(charityId: ch.id, initialProfile: ch),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // 7. Notifications UI
  Widget _buildNotifications(AdminDonationLoaded state) {
    final list = state.notifications;
    final unread = list.where((n) => n.readAt == null).toList();

    return Column(
      children: [
        if (unread.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${unread.length} Unread Notifications',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kMuted),
                ),
                TextButton(
                  onPressed: () => context.read<AdminDonationCubit>().markNotificationsRead(),
                  child: const Text('Mark all as read'),
                ),
              ],
            ),
          ),
        Expanded(
          child: list.isEmpty
              ? _buildEmptyState(
                  icon: Icons.notifications_none,
                  title: 'No Notifications Yet',
                  subtitle: 'You will receive updates here about charity activities.',
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final n = list[index];
                    final isUnread = n.readAt == null;
                    return Card(
                      color: isUnread ? kPrimary.withOpacity(0.04) : Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isUnread ? kPrimary.withOpacity(0.2) : kBorder),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: isUnread ? kPrimary : kBorder,
                          radius: 20,
                          child: Icon(
                            isUnread ? Icons.notifications_active : Icons.notifications_none,
                            color: isUnread ? Colors.white : kMuted,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          n.title,
                          style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal, fontSize: 14),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(n.body, style: const TextStyle(fontSize: 13, color: kText)),
                            const SizedBox(height: 4),
                            Text(
                              n.createdAt.split('.').first.replaceFirst('T', ' '),
                              style: const TextStyle(fontSize: 11, color: kMuted),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (isUnread) {
                            context.read<AdminDonationCubit>().markNotificationsRead(ids: [n.id]);
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: kMuted.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kText)),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: kMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
