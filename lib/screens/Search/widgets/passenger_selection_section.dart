import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/features/passenger/models/passenger_model.dart';
import 'package:gobus_app/features/passenger/providers/passenger_provider.dart';
import 'package:gobus_app/screens/Passenger/add_edit_passenger_screen.dart';
import 'package:provider/provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PassengerSlot — one slot per booking passenger
// ─────────────────────────────────────────────────────────────────────────────

enum PassengerEntryMode { saved, guest }

class PassengerSlot {
  final int index;
  final String label;
  final bool isChild;

  PassengerModel? savedPassenger;
  String? guestName;
  String? guestPhone;
  String guestGender;
  PassengerEntryMode? mode;

  PassengerSlot({
    required this.index,
    required this.label,
    required this.isChild,
    this.savedPassenger,
    this.guestName,
    this.guestPhone,
    this.guestGender = 'male',
    this.mode,
  });

  bool get isFilled =>
      savedPassenger != null ||
      (guestName != null && guestName!.trim().isNotEmpty);

  String get displayName => savedPassenger?.name ?? guestName ?? 'Not assigned';
  String get displayPhone => savedPassenger?.phone ?? guestPhone ?? '';
  String get displayGender => savedPassenger?.gender ?? guestGender;
  bool get isSaved => mode == PassengerEntryMode.saved;

  /// Build the payload this slot contributes to booking_passengers.
  ///
  ///   saved  → passenger_id set, name/phone/gender null
  ///   guest  → passenger_id null, name/phone/gender filled
  Map<String, dynamic> toBookingPayload(String seatNumber) {
    if (savedPassenger != null) {
      return {
        'passenger_id': savedPassenger!.id,
        'name': null,
        'phone': null,
        'gender': null,
        'seat_number': seatNumber,
      };
    }
    return {
      'passenger_id': null,
      'name': guestName,
      'phone': guestPhone,
      'gender': guestGender,
      'seat_number': seatNumber,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PassengerSelectionSection
// ─────────────────────────────────────────────────────────────────────────────

class PassengerSelectionSection extends StatefulWidget {
  final int adults;
  final int children;
  final ValueChanged<List<PassengerSlot>> onSlotsChanged;

  const PassengerSelectionSection({
    super.key,
    required this.adults,
    required this.children,
    required this.onSlotsChanged,
  });

  @override
  State<PassengerSelectionSection> createState() =>
      _PassengerSelectionSectionState();
}

class _PassengerSelectionSectionState extends State<PassengerSelectionSection> {
  late List<PassengerSlot> _slots;
  bool _expanded = true;

  @override
  void initState() {
    super.initState();
    _buildSlots();
    Future.microtask(() => context.read<PassengerProvider>().fetchAll());
  }

  void _buildSlots() {
    _slots = [];
    for (int i = 0; i < widget.adults; i++) {
      _slots.add(
        PassengerSlot(
          index: i,
          label: widget.adults > 1 ? 'Adult ${i + 1}' : 'Adult',
          isChild: false,
        ),
      );
    }
    for (int i = 0; i < widget.children; i++) {
      _slots.add(
        PassengerSlot(
          index: widget.adults + i,
          label: widget.children > 1 ? 'Child ${i + 1}' : 'Child',
          isChild: true,
        ),
      );
    }
  }

  void _notify() => widget.onSlotsChanged(List.from(_slots));

  bool get allFilled => _slots.every((s) => s.isFilled);
  int get filledCount => _slots.where((s) => s.isFilled).length;

  void _openAssignSheet(int i) {
    final provider = context.read<PassengerProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => ChangeNotifierProvider.value(
            value: provider,
            child: _AssignPassengerSheet(
              slot: _slots[i],
              onSaved: (slot) {
                setState(() => _slots[i] = slot);
                _notify();
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Passengers',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                _badge(filledCount, _slots.length),
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.lightText,
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: 14),
            ..._slots.asMap().entries.map(
              (e) => _SlotTile(
                slot: e.value,
                onTap: () => _openAssignSheet(e.key),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge(int filled, int total) {
    final done = filled == total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color:
            done ? Colors.green.withOpacity(0.1) : AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              done
                  ? Colors.green.withOpacity(0.4)
                  : AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Text(
        '$filled / $total',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: done ? Colors.green : AppColors.primary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Slot tile
// ─────────────────────────────────────────────────────────────────────────────

class _SlotTile extends StatelessWidget {
  final PassengerSlot slot;
  final VoidCallback onTap;
  const _SlotTile({required this.slot, required this.onTap});

  Color get _typeColor =>
      slot.isChild ? AppColors.secondary : AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              slot.isFilled
                  ? Colors.white
                  : AppColors.primaryBackground.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                slot.isFilled
                    ? _typeColor.withOpacity(0.3)
                    : AppColors.dividerColor,
            width: slot.isFilled ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color:
                    slot.isFilled
                        ? _typeColor.withOpacity(0.12)
                        : AppColors.dividerColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child:
                  slot.isFilled
                      ? Center(
                        child: Text(
                          _initials(slot.displayName),
                          style: TextStyle(
                            color: _typeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      )
                      : Icon(
                        Icons.person_add_outlined,
                        color: AppColors.lightText,
                        size: 20,
                      ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          slot.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _typeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          slot.isFilled ? slot.displayName : 'Tap to assign',
                          style: TextStyle(
                            fontWeight:
                                slot.isFilled
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                            color:
                                slot.isFilled
                                    ? AppColors.darkText
                                    : AppColors.lightText,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (slot.isFilled) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _sub(
                          Icons.person_outline,
                          _genderLabel(slot.displayGender),
                        ),
                        if (slot.displayPhone.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          _sub(Icons.phone_outlined, slot.displayPhone),
                        ],
                        const SizedBox(width: 6),
                        _entryModeBadge(slot),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Icon(
              slot.isFilled ? Icons.edit_outlined : Icons.chevron_right,
              color: AppColors.lightText,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryModeBadge(PassengerSlot slot) {
    if (!slot.isFilled || slot.mode == null) return const SizedBox.shrink();
    final isSaved = slot.isSaved;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color:
            isSaved
                ? AppColors.primaryBackground
                : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color:
              isSaved
                  ? AppColors.primary.withOpacity(0.3)
                  : Colors.orange.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSaved ? Icons.bookmark : Icons.person_outline,
            size: 10,
            color: isSaved ? AppColors.primary : Colors.orange,
          ),
          const SizedBox(width: 3),
          Text(
            isSaved ? 'Saved' : 'Guest',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isSaved ? AppColors.primary : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sub(IconData icon, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: AppColors.lightText),
      const SizedBox(width: 3),
      Text(
        text,
        style: const TextStyle(fontSize: 11, color: AppColors.mediumText),
      ),
    ],
  );

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _genderLabel(String g) {
    switch (g) {
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return 'Male';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Assign bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _AssignPassengerSheet extends StatefulWidget {
  final PassengerSlot slot;
  final ValueChanged<PassengerSlot> onSaved;
  const _AssignPassengerSheet({required this.slot, required this.onSaved});

  @override
  State<_AssignPassengerSheet> createState() => _AssignPassengerSheetState();
}

class _AssignPassengerSheetState extends State<_AssignPassengerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _gender = 'male';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    if (widget.slot.savedPassenger == null) {
      _nameCtrl.text = widget.slot.guestName ?? '';
      _phoneCtrl.text = widget.slot.guestPhone ?? '';
      _gender = widget.slot.guestGender;
      if (widget.slot.guestName != null) _tab.index = 1;
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _selectSaved(PassengerModel p) {
    widget.onSaved(
      PassengerSlot(
        index: widget.slot.index,
        label: widget.slot.label,
        isChild: widget.slot.isChild,
        savedPassenger: p,
        mode: PassengerEntryMode.saved,
      ),
    );
    Navigator.pop(context);
  }

  /// Called when user taps "Confirm" on manual tab.
  /// Closes the sheet, then shows the save-or-guest dialog.
  Future<void> _confirmManual() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameCtrl.text.trim();
    final phone =
        _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim();
    final gender = _gender;

    Navigator.pop(context); // close sheet first

    if (!mounted) return;
    await _showSaveOrGuestDialog(name: name, phone: phone, gender: gender);
  }

  Future<void> _showSaveOrGuestDialog({
    required String name,
    String? phone,
    required String gender,
  }) async {
    final provider = context.read<PassengerProvider>();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Save this passenger?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Save "$name" to your passenger list so you can reuse them on future trips without re-entering their details.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mediumText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              // ── Continue as guest (no DB record) ─────────────────────────────
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  widget.onSaved(
                    PassengerSlot(
                      index: widget.slot.index,
                      label: widget.slot.label,
                      isChild: widget.slot.isChild,
                      guestName: name,
                      guestPhone: phone,
                      guestGender: gender,
                      mode: PassengerEntryMode.guest,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.mediumText,
                  side: const BorderSide(color: AppColors.dividerColor),
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Continue as Guest'),
              ),
              const SizedBox(height: 10),
              // ── Save to passenger list, then assign ───────────────────────────
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final error = await provider.create(
                    name: name,
                    phone: phone,
                    gender: gender,
                  );
                  if (error != null) {
                    // API failed → silently fall back to guest
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Could not save passenger: $error. Using as guest.',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                    widget.onSaved(
                      PassengerSlot(
                        index: widget.slot.index,
                        label: widget.slot.label,
                        isChild: widget.slot.isChild,
                        guestName: name,
                        guestPhone: phone,
                        guestGender: gender,
                        mode: PassengerEntryMode.guest,
                      ),
                    );
                  } else {
                    // Find newly created record — last one matching name
                    final newP = provider.passengers.lastWhere(
                      (p) => p.name == name,
                      orElse: () => provider.passengers.last,
                    );
                    widget.onSaved(
                      PassengerSlot(
                        index: widget.slot.index,
                        label: widget.slot.label,
                        isChild: widget.slot.isChild,
                        savedPassenger: newP,
                        mode: PassengerEntryMode.saved,
                      ),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"$name" saved to your passengers.'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save & Use',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _clear() {
    widget.onSaved(
      PassengerSlot(
        index: widget.slot.index,
        label: widget.slot.label,
        isChild: widget.slot.isChild,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PassengerProvider>();
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder:
          (_, scrollCtrl) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Assign ${widget.slot.label}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkText,
                        ),
                      ),
                      const Spacer(),
                      if (widget.slot.isFilled)
                        TextButton(
                          onPressed: _clear,
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tab,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.mediumText,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'Saved Passengers'),
                      Tab(text: 'Enter Manually'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      _SavedPassengerTab(
                        provider: provider,
                        selectedId: widget.slot.savedPassenger?.id,
                        scrollController: scrollCtrl,
                        onSelect: _selectSaved,
                        onAddNew: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ChangeNotifierProvider.value(
                                    value: provider,
                                    child: const AddEditPassengerScreen(),
                                  ),
                            ),
                          );
                          if (context.mounted) await provider.fetchAll();
                        },
                      ),
                      _ManualEntryTab(
                        formKey: _formKey,
                        nameCtrl: _nameCtrl,
                        phoneCtrl: _phoneCtrl,
                        gender: _gender,
                        onGenderChanged: (v) => setState(() => _gender = v),
                        onConfirm: _confirmManual,
                        scrollController: scrollCtrl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1 — Saved list
// ─────────────────────────────────────────────────────────────────────────────

class _SavedPassengerTab extends StatelessWidget {
  final PassengerProvider provider;
  final int? selectedId;
  final ScrollController scrollController;
  final ValueChanged<PassengerModel> onSelect;
  final VoidCallback onAddNew;

  const _SavedPassengerTab({
    required this.provider,
    required this.selectedId,
    required this.scrollController,
    required this.onSelect,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    final passengers = provider.sorted;
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        OutlinedButton.icon(
          onPressed: onAddNew,
          icon: const Icon(Icons.person_add_alt_1, size: 18),
          label: const Text('Add New Passenger'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (passengers.isEmpty) ...[
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 48,
                  color: AppColors.dividerColor,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No saved passengers yet.\nAdd one above or enter manually.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.mediumText, height: 1.5),
                ),
              ],
            ),
          ),
        ] else ...[
          const SizedBox(height: 16),
          const Text(
            'Your passengers',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.mediumText,
            ),
          ),
          const SizedBox(height: 8),
          ...passengers.map((p) {
            final isSelected = p.id == selectedId;
            final avatarColor =
                p.gender == 'female'
                    ? const Color(0xFFE91E8C)
                    : p.gender == 'other'
                    ? AppColors.secondary
                    : AppColors.primary;
            return GestureDetector(
              onTap: () => onSelect(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.dividerColor,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: avatarColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          p.initials,
                          style: TextStyle(
                            color: avatarColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkText,
                                ),
                              ),
                              if (p.isDefault) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Default',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${p.genderLabel}${p.phone != null ? ' • ${p.phone}' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.mediumText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          isSelected
                              ? AppColors.primary
                              : AppColors.dividerColor,
                      size: 22,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2 — Manual form
// ─────────────────────────────────────────────────────────────────────────────

class _ManualEntryTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final String gender;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onConfirm;
  final ScrollController scrollController;

  const _ManualEntryTab({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.gender,
    required this.onGenderChanged,
    required this.onConfirm,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.orange, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "After confirming, you'll be asked whether to save this passenger for future trips.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _label('Full Name *'),
            const SizedBox(height: 6),
            TextFormField(
              controller: nameCtrl,
              textCapitalization: TextCapitalization.words,
              validator:
                  (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
              decoration: _deco(
                hint: 'Enter passenger name',
                icon: Icons.person_outline,
              ),
            ),
            const SizedBox(height: 16),
            _label('Phone Number'),
            const SizedBox(height: 6),
            TextFormField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: _deco(hint: 'Optional', icon: Icons.phone_outlined),
            ),
            const SizedBox(height: 16),
            _label('Gender'),
            const SizedBox(height: 8),
            Row(
              children: [
                _genderChip(
                  context,
                  'male',
                  'Male',
                  Icons.male,
                  AppColors.primary,
                ),
                const SizedBox(width: 8),
                _genderChip(
                  context,
                  'female',
                  'Female',
                  Icons.female,
                  const Color(0xFFE91E8C),
                ),
                const SizedBox(width: 8),
                _genderChip(
                  context,
                  'other',
                  'Other',
                  Icons.transgender,
                  AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirm Passenger',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _label(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.mediumText,
    ),
  );

  static InputDecoration _deco({
    required String hint,
    required IconData icon,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: AppColors.lightText,
      fontSize: 14,
      fontFamily: 'poppins',
    ),
    prefixIcon: Icon(icon, color: AppColors.lightText, size: 20),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.dividerColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );

  Widget _genderChip(
    BuildContext context,
    String val,
    String label,
    IconData icon,
    Color color,
  ) {
    final selected = gender == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => onGenderChanged(val),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? color : AppColors.dividerColor,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? color : AppColors.lightText,
                size: 20,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? color : AppColors.mediumText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
