import 'package:flutter/material.dart';
import 'package:kchat/utils/validator.dart';

class KTextFormField extends StatefulWidget {
  const KTextFormField({
    super.key,
    required this.labelText,
    required this.validator,
    required this.onErrorChanged,
    required this.controller,
    this.obscureText = false,
    this.oldValue,
    this.initialValue,
    this.maxLines = 1,
    this.maxSymbols = 24,
    this.showCounterText = false,
    this.height = 85
  }) : assert (
    (validator != ValidatorType.CONFIRM) ||
    (validator == ValidatorType.CONFIRM && oldValue != null),
    'If using validator.CONFIRM you must initialize oldValue.'
  );

  final int maxLines;
  final int maxSymbols;
  final double height;
  final String labelText;
  final ValidatorType validator;
  final Function(bool) onErrorChanged;
  final TextEditingController controller;
  final bool obscureText;
  final bool showCounterText;
  final String? oldValue;
  final String? initialValue;

  @override
  State<KTextFormField> createState() => _KTextFormFieldState();
}

class _KTextFormFieldState extends State<KTextFormField> {
  ({bool error, String? errorText}) _errorState = (error: true, errorText: null);

  Future<void> CheckAndUpdateErrorState(String value) async {
    if (widget.validator == ValidatorType.USERNAME)
      _errorState = await CheckUsername(value, curUsername: widget.initialValue);
    else if (widget.validator == ValidatorType.PASSWORD)
      _errorState = CheckPassword(value);
    else if (widget.validator == ValidatorType.CONFIRM)
      _errorState = CheckConfirmation(widget.oldValue!, value);
    else if (widget.validator == ValidatorType.GROUP_NAME)
      _errorState = CheckGroupName(value);
    else if (widget.validator == ValidatorType.BIO)
      _errorState = CheckBio(value, widget.initialValue);

    // notify process button about error status
    widget.onErrorChanged(_errorState.error);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.value = TextEditingValue(text: widget.initialValue ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: widget.height,
      child: TextFormField(
        maxLength: widget.maxSymbols,
        maxLines: widget.maxLines,
        controller: widget.controller,
        obscureText: widget.obscureText,
        onChanged: CheckAndUpdateErrorState,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          counterText: widget.showCounterText ? null : '',
          label: Text(widget.labelText),
          errorText: _errorState.errorText,
          errorStyle: TextStyle(
            color: _errorState.error ? Color(0xFFDE1010) : Color(0xFF20DE10),
            fontWeight: FontWeight.w700),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _errorState.error ? Color(0xFFDE1010) : Color(0xFF20DE10),
              width: 1.5)),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _errorState.error ? Color(0xFFDE1010) : Color(0xFF20DE10))),
          floatingLabelStyle: TextStyle(
            color: _errorState.errorText == null
                ? Color(0xFF1468c5)
                : (_errorState.error ? Color(0xFFDE1010) : Color(0xFF20DE10)),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
