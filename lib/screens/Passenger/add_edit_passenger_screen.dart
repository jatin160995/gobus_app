import 'package:flutter/material.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/features/passenger/models/passenger_model.dart';
import 'package:gobus_app/features/passenger/providers/passenger_provider.dart';
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:provider/provider.dart';

class AddEditPassengerScreen extends StatefulWidget {
  /// Pass [passenger] to edit an existing one; null = add new
  final PassengerModel? passenger;

  const AddEditPassengerScreen({super.key, this.passenger});

  @override
  State<AddEditPassengerScreen> createState() => _AddEditPassengerScreenState();
}

class _AddEditPassengerScreenState extends State<AddEditPassengerScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _idCtrl;

  String _gender = 'male';
  bool _isDefault = false;

  bool get _isEditing => widget.passenger != null;

  @override
  void initState() {
    super.initState();
    final p = widget.passenger;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _phoneCtrl = TextEditingController(text: p?.phone ?? '');
    _idCtrl = TextEditingController(text: p?.idNumber ?? '');
    _gender = p?.gender ?? 'male';
    _isDefault = p?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<PassengerProvider>();

    String? error;

    if (_isEditing) {
      error = await provider.update(
        id: widget.passenger!.id,
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        gender: _gender,
        idNumber: _idCtrl.text.trim().isEmpty ? null : _idCtrl.text.trim(),
        isDefault: _isDefault,
      );
    } else {
      error = await provider.create(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        gender: _gender,
        idNumber: _idCtrl.text.trim().isEmpty ? null : _idCtrl.text.trim(),
        isDefault: _isDefault,
      );
    }

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Passenger updated successfully'
                : 'Passenger added successfully',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PassengerProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: AppColors.darkText),
        title: Text(
          _isEditing ? 'Edit Passenger' : 'Add Passenger',
          style: const TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // ── Avatar preview ──────────────────────────────────────────
                Center(
                  child: ValueListenableBuilder(
                    valueListenable: _nameCtrl,
                    builder: (_, __, ___) {
                      final name = _nameCtrl.text.trim();
                      final parts = name.split(' ');
                      final initials =
                          parts.length >= 2
                              ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
                              : name.isNotEmpty
                              ? name[0].toUpperCase()
                              : '?';
                      final color =
                          _gender == 'female'
                              ? const Color(0xFFE91E8C)
                              : _gender == 'other'
                              ? AppColors.secondary
                              : AppColors.primary;

                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: color,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ── Full Name ───────────────────────────────────────────────
                _label('Full Name *'),
                const SizedBox(height: 6),
                _textField(
                  controller: _nameCtrl,
                  hint: 'Enter passenger full name',
                  icon: Icons.person_outline,
                  validator:
                      (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Name is required'
                              : null,
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 16),

                // ── Phone ───────────────────────────────────────────────────
                _label('Phone Number'),
                const SizedBox(height: 6),
                _textField(
                  controller: _phoneCtrl,
                  hint: 'e.g. +237 612 345 678',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 16),

                // ── Gender ──────────────────────────────────────────────────
                _label('Gender'),
                const SizedBox(height: 8),
                _GenderSelector(
                  value: _gender,
                  onChanged: (v) => setState(() => _gender = v),
                ),

                const SizedBox(height: 16),

                // ── ID Number ───────────────────────────────────────────────
                _label('ID / Passport Number'),
                const SizedBox(height: 6),
                _textField(
                  controller: _idCtrl,
                  hint: 'Optional',
                  icon: Icons.badge_outlined,
                  textCapitalization: TextCapitalization.characters,
                ),

                const SizedBox(height: 20),

                // ── Set as default ──────────────────────────────────────────
                _DefaultToggle(
                  value: _isDefault,
                  onChanged: (v) => setState(() => _isDefault = v),
                ),

                const SizedBox(height: 36),

                // ── Submit button ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child:
                        provider.isSaving
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              _isEditing ? 'Update Passenger' : 'Add Passenger',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.mediumText,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: AppColors.darkText,
        fontFamily: 'poppins',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.lightText,
          fontSize: 14,
          fontFamily: 'poppins',
        ),
        prefixIcon: Icon(icon, color: AppColors.lightText, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
      ),
    );
  }
}

// ─── Gender Selector ──────────────────────────────────────────────────────────

class _GenderSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _GenderSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('male', 'Male', Icons.male, AppColors.primary),
        const SizedBox(width: 10),
        _chip('female', 'Female', Icons.female, const Color(0xFFE91E8C)),
        const SizedBox(width: 10),
        _chip('other', 'Other', Icons.transgender, AppColors.secondary),
      ],
    );
  }

  Widget _chip(String val, String label, IconData icon, Color color) {
    final selected = value == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(val),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
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

// ─── Default Toggle ───────────────────────────────────────────────────────────

class _DefaultToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DefaultToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:
              value
                  ? AppColors.primaryBackground
                  : AppColors.dividerColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                value
                    ? AppColors.primary.withOpacity(0.4)
                    : AppColors.dividerColor,
          ),
        ),
        child: Row(
          children: [
            Icon(
              value ? Icons.star : Icons.star_border,
              color: value ? AppColors.primary : AppColors.lightText,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set as default passenger',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: value ? AppColors.primary : AppColors.darkText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Auto-filled when booking a trip',
                    style: TextStyle(fontSize: 12, color: AppColors.lightText),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
