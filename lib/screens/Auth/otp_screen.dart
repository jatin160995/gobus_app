import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gobus_app/core/storage/local_storage.dart';
import 'package:gobus_app/core/theme.dart';
import 'package:gobus_app/core/utils.dart';
import 'package:gobus_app/features/auth/services/auth_api.dart';
// Import the generated localizations file
import 'package:gobus_app/l10n/gen/app_localizations.dart';
import 'package:gobus_app/screens/home/home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final int userId;
  final String token;
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.userId,
    required this.token,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  // Controllers for the 6 OTP digits (Updated from 4 to 6)
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  // Timer state
  Timer? _timer;
  int _start = 48; // 48 seconds as per design
  bool _isResendAvailable = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _isResendAvailable = false;
    _start = 48;
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isResendAvailable = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void onDigitEntered(int index, String value) {
    if (value.isNotEmpty) {
      // If digit entered, move to next field (up to index 5 for 6 digits)
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Backspacing on an empty field: move to previous field
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((e) => e.text).join();

    if (otp.length != 6) {
      showError("Enter valid 6-digit OTP", context);
      return;
    }

    setState(() => _isLoading = true);

    final response = await AuthApi.verifyOtp(
      userId: widget.userId,
      otp: otp,
      token: widget.token,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (response.status) {
      await LocalStorage.saveToken(widget.token);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } else {
      showError(response.message ?? "OTP verification failed", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the localization object
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.mediumText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // --- ILLUSTRATION ---
              SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/images/otp-screen.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),

              // --- TITLE ---
              Text(
                l10n.otpHeading,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  fontFamily: 'poppins',
                ),
              ),
              Text(
                l10n.otpSubHeading,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'poppins',
                ),
              ),
              const SizedBox(height: 16),

              // --- DESCRIPTION ---
              Text(
                '${l10n.otpSentMessage}\n${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // --- OTP INPUT FIELDS (FIXED: Set to 6) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width:
                        45, // Reduced width slightly to fit 6 boxes comfortably
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                      decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.mediumText,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => onDigitEntered(index, value),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),

              // --- RESEND TIMER ---
              Text(
                l10n.didNotReceiveEmail,
                style: const TextStyle(color: AppColors.mediumText),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.resendCodeIn,
                    style: const TextStyle(color: AppColors.mediumText),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _isResendAvailable ? startTimer : null,
                    child: Text(
                      _isResendAvailable ? l10n.resendNow : "${_start}s",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // --- SUBMIT BUTTON ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : _verifyOtp,
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            l10n.submitBtn,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
