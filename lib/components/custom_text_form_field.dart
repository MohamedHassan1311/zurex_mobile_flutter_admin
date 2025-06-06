import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zurex_admin/app/core/dimensions.dart';
import 'package:zurex_admin/app/core/extensions.dart';
import 'package:zurex_admin/app/core/text_styles.dart';
import '../app/core/styles.dart';
import '../app/core/svg_images.dart';
import 'custom_images.dart';

class CustomTextField extends StatefulWidget {
  final TextInputAction keyboardAction;
  final Color? iconColor;
  final TextInputType? inputType;
  final String? hint;
  final String? label;
  final double labelSpace;
  final void Function(String)? onChanged;
  final bool isPassword;
  final void Function(String)? onSubmit;
  final FocusNode? focusNode, nextFocus;
  final FormFieldValidator<String>? validate;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final bool keyboardPadding;
  final bool withLabel;
  final bool readOnly;
  final int? maxLength;
  final bool obscureText;
  final bool? autoFocus;
  final bool? alignLabel;
  final String? errorText;
  final String? initialValue;
  final bool isEnabled;
  final bool? alignLabelWithHint;
  final bool? withPadding;
  final GestureTapCallback? onTap;
  final Color? onlyBorderColor;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? formattedType;
  final Function(dynamic)? onTapOutside;
  final double? height;
  final String? sufSvgIcon, sufAssetIcon;
  final String? pAssetIcon, pSvgIcon;
  final Color? pIconColor, sIconColor;
  final Widget? prefixWidget, sufWidget;
  final bool isFillColor;
  final double? borderRadius;
  const CustomTextField({
    super.key,
    this.height,
    this.sufSvgIcon,
    this.autofillHints,
    this.borderRadius,
    this.sufAssetIcon,
    this.pAssetIcon,
    this.pSvgIcon,
    this.pIconColor,
    this.sIconColor,
    this.sufWidget,
    this.prefixWidget,
    this.keyboardAction = TextInputAction.next,
    this.inputType,
    this.hint,
    this.alignLabelWithHint = false,
    this.isFillColor = false,
    this.onChanged,
    this.validate,
    this.obscureText = false,
    this.isPassword = false,
    this.readOnly = false,
    this.labelSpace = 8,
    this.maxLines = 1,
    this.minLines = 1,
    this.isEnabled = true,
    this.withPadding = true,
    this.alignLabel = false,
    this.controller,
    this.errorText,
    this.maxLength,
    this.formattedType,
    this.focusNode,
    this.nextFocus,
    this.iconColor,
    this.keyboardPadding = false,
    this.autoFocus,
    this.initialValue,
    this.onSubmit,
    this.onlyBorderColor,
    this.withLabel = true,
    this.label,
    this.onTap,
    this.onTapOutside,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isHidden = true;
  bool _isFocus = false;

  late InputBorder _borders;
  @override
  void initState() {
    _borders = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
      borderSide: const BorderSide(
        style: BorderStyle.solid,
        color: Styles.BORDER_COLOR,
        width: 1,
      ),
    );
    widget.focusNode?.addListener(() {
      _onFocus();
    });
    super.initState();
  }

  void _visibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  _onFocus() {
    setState(() {
      _isFocus = widget.focusNode?.hasFocus == true;
    });
  }

  activationColor() {
    return widget.errorText != null
        ? Styles.ERORR_COLOR
        : _isFocus
            ? Styles.PRIMARY_COLOR
            : Styles.BORDER_COLOR;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null && widget.label != null)
            Text(
              widget.label ?? "",
              style: AppTextStyles.w700.copyWith(
                fontSize: 14,
                color: Styles.HEADER,
              ),
            ),
          if (widget.withLabel && widget.label != null)
            SizedBox(height: widget.labelSpace.h),
          GestureDetector(
            onTap: widget.onTap,
            child: TextFormField(
              autofillHints: widget.autofillHints,
              focusNode: widget.focusNode,
              initialValue: widget.initialValue,
              textInputAction: widget.keyboardAction,
              // textDirection: sl<LanguageBloc>().isLtr
              //     ? TextDirection.ltr
              //     : TextDirection.rtl,
              textAlignVertical: TextAlignVertical.bottom,
              onTap: widget.onTap,
              autofocus: widget.autoFocus ?? false,
              maxLength: widget.maxLength,
              onFieldSubmitted: (v) {
                widget.onSubmit?.call(v);
                FocusScope.of(context).requestFocus(widget.nextFocus);
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(widget.nextFocus);
              },
              enabled: widget.isEnabled,
              readOnly: widget.readOnly,
              obscureText:
                  widget.isPassword == true ? _isHidden : widget.obscureText,
              controller: widget.controller,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              validator: (v) {
                return widget.validate?.call(v);
              },
              keyboardType: widget.inputType,
              onChanged: widget.onChanged,
              inputFormatters: widget.inputType == TextInputType.phone
                  ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                  : widget.formattedType ?? [],
              onTapOutside: (v) {
                widget.onTapOutside?.call(v);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              style: AppTextStyles.w600.copyWith(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: widget.isFillColor ? Colors.white : Styles.HEADER,
              ),
              scrollPhysics: const BouncingScrollPhysics(),
              scrollPadding: EdgeInsets.only(
                  bottom: widget.keyboardPadding ? context.bottom : 0.0),
              decoration: InputDecoration(
                isDense: true,
                counterText: "",
                counterStyle: AppTextStyles.w400
                    .copyWith(fontSize: 12, color: Styles.HINT_COLOR),
                prefixIcon: (widget.pAssetIcon != null ||
                        widget.pSvgIcon != null ||
                        widget.prefixWidget != null)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 16.w),
                          widget.prefixWidget ??
                              (widget.pAssetIcon != null
                                  ? Image.asset(
                                      widget.pAssetIcon!,
                                      height: 16.h,
                                      width: 16.w,
                                      color: widget.pIconColor ??
                                          activationColor(),
                                    )
                                  : widget.pSvgIcon != null
                                      ? customImageIconSVG(
                                          imageName: widget.pSvgIcon!,
                                          color: widget.pIconColor ??
                                              activationColor(),
                                          height: 16.h,
                                          width: 16.w,
                                        )
                                      : const SizedBox()),
                          const Expanded(child: SizedBox()),
                          Container(
                            height: 100,
                            width: 1,
                            decoration: BoxDecoration(
                                color: widget.pIconColor ?? activationColor(),
                                borderRadius: BorderRadius.circular(100)),
                            child: const SizedBox(),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      )
                    : null,
                suffixIcon: widget.sufWidget != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: widget.sufWidget,
                      )
                    : (widget.sufAssetIcon != null
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Image.asset(
                              widget.sufAssetIcon!,
                              height: 22.h,
                              color: widget.sIconColor ?? activationColor(),
                            ),
                          )
                        : widget.sufSvgIcon != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: customImageIconSVG(
                                  imageName: widget.sufSvgIcon!,
                                  color: widget.sIconColor ?? activationColor(),
                                  height: 16.h,
                                ),
                              )
                            : widget.isPassword == true
                                ? IconButton(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    onPressed: _visibility,
                                    alignment: Alignment.center,
                                    icon: customImageIconSVG(
                                      imageName: _isHidden
                                          ? SvgImages.hiddenEyeIcon
                                          : SvgImages.eyeIcon,
                                      height: 17.h,
                                      width: 20.w,
                                      color: _isHidden
                                          ? const Color(0xFF8B97A3)
                                          : Styles.PRIMARY_COLOR,
                                    ))
                                : null),
                enabled: widget.isEnabled,
                // labelText: widget.label,
                hintText: widget.hint ?? '',
                alignLabelWithHint:
                    widget.alignLabelWithHint ?? widget.alignLabel,
                disabledBorder: _borders,
                focusedBorder: _borders.copyWith(
                    borderSide: const BorderSide(
                  width: 1,
                  color: Styles.PRIMARY_COLOR,
                )),
                errorBorder: _borders.copyWith(
                    borderSide: const BorderSide(
                  width: 1,
                  color: Styles.ERORR_COLOR,
                )),
                enabledBorder: _borders,
                border: _borders,
                filled: true,
                fillColor:
                    widget.isFillColor ? Styles.FILL_COLOR : Colors.white,
                errorMaxLines: 1,
                errorText: widget.errorText,
                errorStyle: AppTextStyles.w600.copyWith(
                  color: Styles.ERORR_COLOR,
                  fontSize: 14,
                ),
                labelStyle: const TextStyle(
                    color: Styles.PRIMARY_COLOR,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
                floatingLabelStyle: AppTextStyles.w600
                    .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 16),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: AppTextStyles.w400.copyWith(
                  color: Styles.HINT_COLOR,
                  fontSize: 14,
                ),
                prefixIconConstraints: BoxConstraints(
                    maxHeight: 30.h,
                    maxWidth:
                        widget.inputType == TextInputType.phone ? 100.w : 60.w),
                suffixIconConstraints: BoxConstraints(maxHeight: 35.h),
                contentPadding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_SMALL.h,
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
