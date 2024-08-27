import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({
    super.key,
    this.focusNode,
    this.autoFocus = false,
    this.textEditingController,
    this.isObscureText = false,
    this.obscureCharacter = ' ',
    this.textCapitalization = TextCapitalization.none,
    this.isFilled,
    this.contentPadding = EdgeInsets.zero,
    this.fillColor,
    this.hintText,
    this.hintStyle,
    this.errorStyle,
    this.formBorder,
    this.focusedBorder,
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputAction = TextInputAction.done,
    this.textInputType = TextInputType.text,
    this.formStyle,
    required this.onChange,
    this.isReadOnly = false,
    this.onTap,
    this.errorBorder,
    this.inputFormatters,
    this.maxLength = TextField.noMaxLength,
    this.onEditingComplete,
    this.initialValue,
    this.cursorColor,
    this.maxlines = 1,
    this.enabled = true,
    this.validator,
    this.textAlign,
    this.onFieldSubmitted,
  });

  final FocusNode? focusNode;
  final bool autoFocus;
  final TextEditingController? textEditingController;
  final bool isObscureText;
  final String obscureCharacter;
  final TextCapitalization textCapitalization;
  final bool? isFilled;
  final EdgeInsets contentPadding;
  final Color? fillColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final OutlineInputBorder? formBorder;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final TextStyle? formStyle;
  final void Function(String value) onChange;
  final bool isReadOnly;
  final Function()? onTap;
  final InputBorder? errorBorder;
  final List<TextInputFormatter>? inputFormatters;
  final OutlineInputBorder? focusedBorder;
  final Function()? onEditingComplete;
  final int? maxLength;
  final String? initialValue;
  final Color? cursorColor;
  final int? maxlines;
  final bool? enabled;
  final String? Function(String?)? validator;
  final TextAlign? textAlign;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => TextFormField(
        key: const Key('text-form-field'),
        readOnly: isReadOnly,
        maxLength: maxLength,
        validator: validator,
        autofocus: autoFocus,
        focusNode: focusNode,
        textAlign: textAlign ?? TextAlign.left,
        controller: textEditingController,
        obscureText: isObscureText,
        obscuringCharacter: obscureCharacter,
        textCapitalization: textCapitalization,
        onTap: onTap,
        inputFormatters: inputFormatters,
        cursorColor: cursorColor,
        decoration: InputDecoration(
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            filled: true,
            contentPadding: contentPadding,
            fillColor: fillColor,
            border: formBorder,
            enabledBorder: formBorder,
            hintText: hintText,
            hintStyle: hintStyle,
            errorText: errorText,
            errorStyle: errorStyle,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorMaxLines: 3,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 25,
              minHeight: 25,
            ),
            counter: Dimens.box0),
        onChanged: onChange,
        maxLines: maxlines,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        style: formStyle,
        onEditingComplete: onEditingComplete,
        initialValue: initialValue,
        enabled: enabled,
        onFieldSubmitted: onFieldSubmitted,
      );
}
