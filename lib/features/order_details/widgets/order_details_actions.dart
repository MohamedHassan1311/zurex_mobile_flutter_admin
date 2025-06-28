import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/dimensions.dart';
import 'package:zurex_admin/components/custom_bottom_sheet.dart';
import 'package:zurex_admin/components/custom_button.dart';
import 'package:zurex_admin/features/change_status/view/update_order_status_view.dart';
import 'package:zurex_admin/features/order_details/bloc/order_details_bloc.dart';
import 'package:zurex_admin/features/order_details/model/order_details_model.dart';
import 'package:zurex_admin/features/team_details/model/team_model.dart';
import 'package:zurex_admin/main_blocs/user_bloc.dart';
import '../../../app/core/app_event.dart';
import '../../../app/localization/language_constant.dart';
import '../../change_status/view/update_team_status.dart';

class OrderDetailsActions extends StatelessWidget {
  const OrderDetailsActions({super.key, required this.model});

  final OrderDetailsModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (UserBloc.instance.user?.userType == UserType.admin &&
            model.availableStatus != null &&
            model.availableStatus!.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              vertical: Dimensions.paddingSizeExtraSmall.h,
            ),
            child: CustomButton(
              text: getTranslated("update_order_status"),
              onTap: () => CustomBottomSheet.general(
                  widget: UpdateOrderStatusView(
                onSuccess: (v) =>
                    context.read<OrderDetailsBloc>().add(Update(arguments: v)),
                id: model.id!,
                availableStatus: model.availableStatus ?? [],
              )),
            ),
          ),
        if (UserBloc.instance.user?.userType == UserType.driver &&
            model.statusCode == OrderStatus.out_for_delivery.name &&
            model.teamStatus != TeamStatus.delivered &&
            model.team != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              vertical: Dimensions.paddingSizeExtraSmall.h,
            ),
            child: UpdateTeamStatus(
              id: model.id!,
              teamStatus: model.teamStatus,
              onSuccess: (v) =>
                  context.read<OrderDetailsBloc>().add(Update(arguments: v)),
            ),
          )
      ],
    );
  }
}
