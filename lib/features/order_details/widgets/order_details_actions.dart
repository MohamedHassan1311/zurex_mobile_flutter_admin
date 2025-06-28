import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/dimensions.dart';
import 'package:zurex_admin/components/custom_bottom_sheet.dart';
import 'package:zurex_admin/components/custom_button.dart';
import 'package:zurex_admin/features/change_status/view/admin_update_order_status_view.dart';
import 'package:zurex_admin/features/order_details/bloc/order_details_bloc.dart';
import 'package:zurex_admin/features/order_details/model/order_details_model.dart';
import '../../../app/core/app_event.dart';
import '../../../app/localization/language_constant.dart';

class OrderDetailsActions extends StatelessWidget {
  const OrderDetailsActions(
      {super.key, required this.id, required this.availableStatus});

  final int id;
  final List<StatusModel> availableStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeMini.h,
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
      child: CustomButton(
        text: getTranslated("update_order_status"),
        onTap: () => CustomBottomSheet.general(
            widget: AdminUpdateOrderStatusView(
          onSuccess: (v) =>
              context.read<OrderDetailsBloc>().add(Update(arguments: v)),
          id: id,
          availableStatus: availableStatus,
        )),
      ),
    );
  }
}
