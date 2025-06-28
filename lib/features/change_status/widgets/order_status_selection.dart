import 'package:flutter/material.dart';
import 'package:zurex_admin/features/order_details/model/order_details_model.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import 'package:zurex_admin/components/animated_widget.dart';
import 'package:zurex_admin/app/core/extensions.dart';

class OrderStatusSelection extends StatefulWidget {
  const OrderStatusSelection(
      {super.key,
      required this.onConfirm,
      required this.list,
      this.initialValue});
  final ValueChanged<StatusModel> onConfirm;
  final List<StatusModel> list;
  final String? initialValue;

  @override
  State<OrderStatusSelection> createState() => _OrderStatusSelectionState();
}

class _OrderStatusSelectionState extends State<OrderStatusSelection> {
  String? _selectedItem;
  @override
  void initState() {
    setState(() {
      _selectedItem = widget.initialValue;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      controller: ScrollController(),
      customPadding:
          EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
      data: List.generate(
        widget.list.length,
        (index) => GestureDetector(
          onTap: () {
            setState(() => _selectedItem = widget.list[index].statusCode);
            widget.onConfirm(widget.list[index]);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL.h),
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                vertical: Dimensions.PADDING_SIZE_SMALL.h),
            decoration: BoxDecoration(
              color: _selectedItem == widget.list[index].statusCode
                  ? Styles.PRIMARY_COLOR
                  : Styles.WHITE_COLOR,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: _selectedItem == widget.list[index].statusCode
                      ? Styles.WHITE_COLOR
                      : Styles.PRIMARY_COLOR),
            ),
            width: context.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.list[index].status ?? "",
                    style: AppTextStyles.w600.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      color: _selectedItem == widget.list[index].statusCode
                          ? Styles.WHITE_COLOR
                          : Styles.PRIMARY_COLOR,
                    ),
                  ),
                ),
                Icon(
                    _selectedItem == widget.list[index].statusCode
                        ? Icons.radio_button_checked_outlined
                        : Icons.radio_button_off,
                    size: 22,
                    color: _selectedItem == widget.list[index].statusCode
                        ? Styles.WHITE_COLOR
                        : Styles.PRIMARY_COLOR)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
