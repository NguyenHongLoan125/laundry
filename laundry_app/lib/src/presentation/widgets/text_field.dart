import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLength;
  final TextAlign textAlign;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? errorText;
  final FocusNode? focusNode; // THÊM focus node

  const CustomTextField({
    Key? key,
    required this.controller,
    this.label,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.validator,
    this.errorText,
    this.focusNode, // THÊM parameter
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _isObscure = true;
//   bool _hasInteracted = false; // Kiểm tra user đã tương tác chưa
//   String? _localError; // Lưu lỗi local
//   late FocusNode _internalFocusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     _isObscure = widget.obscureText;
//     _internalFocusNode = widget.focusNode ?? FocusNode();
//
//     // Lắng nghe khi user blur (rời khỏi field)
//     _internalFocusNode.addListener(_onFocusChange);
//   }
//
//   @override
//   void dispose() {
//     if (widget.focusNode == null) {
//       _internalFocusNode.dispose();
//     } else {
//       _internalFocusNode.removeListener(_onFocusChange);
//     }
//     super.dispose();
//   }
//
//   void _onFocusChange() {
//     // Khi user blur (unfocus), validate ngay
//     if (!_internalFocusNode.hasFocus && widget.controller.text.isNotEmpty) {
//       setState(() {
//         _hasInteracted = true;
//         _validateField();
//       });
//     }
//   }
//
//   void _validateField() {
//     if (widget.validator != null) {
//       _localError = widget.validator!(widget.controller.text);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Hiển thị lỗi từ backend hoặc lỗi local
//     final displayError = widget.errorText ?? (_hasInteracted ? _localError : null);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: widget.controller,
//           focusNode: _internalFocusNode,
//           obscureText: widget.obscureText && _isObscure,
//           keyboardType: widget.keyboardType,
//           maxLength: widget.maxLength,
//           textAlign: widget.textAlign,
//           onChanged: (value) {
//             // Khi user gõ, validate real-time nếu đã tương tác
//             if (_hasInteracted) {
//               setState(() {
//                 _validateField();
//               });
//             }
//
//             // Gọi callback từ parent
//             if (widget.onChanged != null) {
//               widget.onChanged!(value);
//             }
//           },
//           // QUAN TRỌNG: Tắt autovalidateMode để tự xử lý
//           autovalidateMode: AutovalidateMode.disabled,
//           validator: widget.validator,
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 16,
//           ),
//           decoration: InputDecoration(
//             labelText: widget.label,
//             labelStyle: TextStyle(
//               color: AppColors.textSecondary,
//             ),
//             prefixIcon: widget.icon != null
//                 ? Icon(widget.icon, color: AppColors.primary)
//                 : null,
//             suffixIcon: widget.obscureText
//                 ? IconButton(
//               icon: Icon(
//                 _isObscure ? Icons.visibility_off : Icons.visibility,
//                 color: AppColors.textSecondary,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isObscure = !_isObscure;
//                 });
//               },
//             )
//                 : null,
//             filled: true,
//             fillColor: AppColors.backgroundSecondary,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: displayError != null
//                     ? Colors.red.withOpacity(0.5)
//                     : AppColors.backgroundSecondary,
//                 width: 1,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: displayError != null ? Colors.red : AppColors.primary,
//                 width: 2,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: Colors.red,
//                 width: 2,
//               ),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: Colors.red,
//                 width: 2,
//               ),
//             ),
//             counterText: '',
//           ),
//         ),
//
//         // Hiển thị lỗi
//         if (displayError != null && displayError.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 8, left: 12),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   color: Colors.red,
//                   size: 16,
//                 ),
//                 SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     displayError,
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 12,
//                       height: 1.2,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }
class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;
  bool _hasInteracted = false;
  String? _localError;

  late FocusNode _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && widget.controller.text.isNotEmpty) {
      setState(() {
        _hasInteracted = true;
        _validateField();
      });
    }
  }

  void _validateField() {
    if (widget.validator != null) {
      _localError = widget.validator!(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayError =
        widget.errorText ?? (_hasInteracted ? _localError : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode, // ✅ dùng getter
          obscureText: widget.obscureText && _isObscure,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          textAlign: widget.textAlign,
          onChanged: (value) {
            if (_hasInteracted) {
              setState(_validateField);
            }
            widget.onChanged?.call(value);
          },
          autovalidateMode: AutovalidateMode.disabled,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
                     labelText: widget.label,
                      prefixIcon:
                      widget.icon != null ? Icon(widget.icon) : null,
                      suffixIcon: widget.obscureText
                          ? IconButton(
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _isObscure = !_isObscure);
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: AppColors.backgroundSecondary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: displayError != null
                              ? Colors.red.withValues(alpha: 0.5)
                              : AppColors.backgroundSecondary,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: displayError != null ? Colors.red : AppColors.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      counterText: '',
                    ),
          // decoration: InputDecoration(
          //   labelText: widget.label,
          //   prefixIcon:
          //   widget.icon != null ? Icon(widget.icon) : null,
          //   suffixIcon: widget.obscureText
          //       ? IconButton(
          //     icon: Icon(
          //       _isObscure
          //           ? Icons.visibility_off
          //           : Icons.visibility,
          //     ),
          //     onPressed: () {
          //       setState(() => _isObscure = !_isObscure);
          //     },
          //
          //   )
          //       : null,
          //   counterText: '',
          // ),
        ),
        if (displayError != null && displayError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    displayError,
                    style: const TextStyle(
                        color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
