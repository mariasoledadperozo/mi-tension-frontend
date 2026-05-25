import 'package:flutter/material.dart';
import 'package:mi_tension/features/theme/app_theme.dart';

class AtomoInputPrincipal extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isPassword;
  final double? width;

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const AtomoInputPrincipal({
    super.key,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
    this.width,
    this.controller,
    this.onChanged,
    this.errorText,
  });

  @override
  State<AtomoInputPrincipal> createState() => _AtomoInputPrincipalState();
}

class _AtomoInputPrincipalState extends State<AtomoInputPrincipal> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: AppTheme.descriptionGray,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            obscureText: widget.isPassword && _obscure,
            style: const TextStyle(
              color: AppTheme.mainTitleBlack,
            ), // texto al escribir
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: const TextStyle(color: AppTheme.descriptionGray),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.descriptionGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.descriptionGray),
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.descriptionGray,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
