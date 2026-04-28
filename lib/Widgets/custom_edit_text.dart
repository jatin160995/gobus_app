import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gobus_app/core/theme.dart';

class CustomEditText extends StatefulWidget {
  bool isActive;
  TextEditingController textEditingController;
  double fontSize;
  TextInputType textInputType;
  String placeholder;
  FontWeight fontWeight;
  Color backgroundColor;
  bool isPassword;
  int length;
  double width;
  TextInputAction textInputAction;
  ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  IconData? icon;
  CustomEditText(
    this.isActive,
    this.fontSize,
    this.textEditingController,
    this.textInputType,
    this.placeholder, {
    this.fontWeight = FontWeight.normal,
    this.backgroundColor = const Color(0xFFF1F1F1),
    this.isPassword = false,
    this.length = 1000,
    this.width = double.infinity,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.icon,
  });

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(12),
      child: CupertinoTextField(
        prefix:
            widget.icon == null
                ? Container()
                : Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(widget.icon, color: Colors.grey),
                ),
        obscureText: widget.isPassword,
        enabled: widget.isActive,
        keyboardType: widget.textInputType,
        controller: widget.textEditingController,
        maxLength: widget.length,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        inputFormatters: <TextInputFormatter>[
          // widget.placeholder == "Full Name"
          //     ? UpperCaseTextFormatter()
          //     : TextInputFormatter.withFunction(
          //       (oldValue, newValue) => newValue,
          //     ),
        ],
        onChanged: (t) {
          //validateEmail(t);
        },
        placeholderStyle: TextStyle(
          color: AppColors.lightText,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          fontFamily: "poppins",
        ),
        placeholder: widget.placeholder,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          // border: Border.all(color: transparent),
          // color: transparent,
        ),
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          fontFamily: "poppins",
          color: AppColors.darkText,
        ),
      ),
    );
  }
}

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     return TextEditingValue(
//       text: capitalize(newValue.text),
//       selection: newValue.selection,
//     );
//   }
// }

// String capitalize(String value) {
//   if (value.trim().isEmpty) return "";
//   var tem = value.split(" ");
//   List finalValues = [];
//   for (var temp in tem) {
//     finalValues.add(temp.capitalize());
//   }
//   print(finalValues);

//   return finalValues.join(" ");
// }
