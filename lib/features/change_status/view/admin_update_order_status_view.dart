import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/app_core.dart';
import 'package:zurex_admin/components/animated_widget.dart';
import 'package:zurex_admin/features/change_status/entity/order_status_entity.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/core/validation.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../data/config/di.dart';
import '../../../navigation/custom_navigation.dart';
import '../../order_details/model/order_details_model.dart';
import '../../teams/page/teams_selection_view.dart';
import '../bloc/change_status_bloc.dart';
import '../repo/change_status_repo.dart';
import '../widgets/order_status_selection.dart';

class AdminUpdateOrderStatusView extends StatelessWidget {
  const AdminUpdateOrderStatusView(
      {super.key,
      required this.id,
      required this.availableStatus,
      this.onSuccess});
  final int id;
  final List<StatusModel> availableStatus;
  final Function(OrderDetailsModel)? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeStatusBloc(repo: sl<ChangeStatusRepo>()),
      child: BlocBuilder<ChangeStatusBloc, AppState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            child: Form(
              key: context.read<ChangeStatusBloc>().key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Title
                  Container(
                    width: 60.w,
                    height: 4.h,
                    margin: EdgeInsets.only(
                      left: Dimensions.PADDING_SIZE_DEFAULT.w,
                      right: Dimensions.PADDING_SIZE_DEFAULT.w,
                      top: Dimensions.paddingSizeMini.h,
                      bottom: Dimensions.PADDING_SIZE_DEFAULT.h,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Styles.HINT_COLOR,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated("update_order_status"),
                          style: AppTextStyles.w700.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            CustomNavigator.pop();
                          },
                          child: const Icon(
                            Icons.clear,
                            size: 24,
                            color: Styles.DISABLED,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    child: const Divider(
                      color: Styles.BORDER_COLOR,
                    ),
                  ),

                  ///Body
                  Flexible(
                    child: StreamBuilder<OrderStatusEntity?>(
                      stream: context.read<ChangeStatusBloc>().entityStream,
                      builder: (context, snapshot) {
                        return ListAnimator(
                          customPadding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                          data: [
                            ///Order Status
                            CustomTextField(
                              readOnly: true,
                              onTap: () => CustomBottomSheet.show(
                                  label: getTranslated("order_status"),
                                  widget: OrderStatusSelection(
                                    initialValue:
                                        snapshot.data?.status?.statusCode,
                                    onConfirm: (v) => context
                                        .read<ChangeStatusBloc>()
                                        .updateEntity(
                                            snapshot.data?.copyWith(status: v)),
                                    list: availableStatus,
                                  ),
                                  onConfirm: () => CustomNavigator.pop()),
                              controller: TextEditingController(
                                  text: snapshot.data?.status?.status),
                              label: getTranslated("order_status"),
                              hint: getTranslated("select_order_status"),
                              validate: (v) => Validations.field(
                                  snapshot.data?.status?.statusCode,
                                  fieldName: getTranslated("order_status")),
                              sufWidget: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 24,
                                color: Styles.HINT_COLOR,
                              ),
                            ),

                            ///Team
                            if (snapshot.data?.status?.statusCode ==
                                OrderStatus.out_for_delivery.name)
                              CustomTextField(
                                onTap: () => CustomBottomSheet.general(
                                  widget: TeamsSelectionView(
                                    initialValue: snapshot.data?.team?.id,
                                    onConfirm: (v) {
                                      log("Team ${v.toJson()}");
                                      context
                                          .read<ChangeStatusBloc>()
                                          .updateEntity(
                                              snapshot.data?.copyWith(team: v));
                                      log("Selected Team ${snapshot.data?.team?.toJson()}");
                                    },
                                  ),
                                ),
                                controller: TextEditingController(
                                    text: snapshot.data?.team?.name),
                                readOnly: true,
                                label: getTranslated("team"),
                                hint: getTranslated("select_team"),
                                validate: (v) => Validations.field(
                                    snapshot.data?.team?.name,
                                    fieldName: getTranslated("team")),
                                sufWidget: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 24,
                                  color: Styles.HINT_COLOR,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  ///Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeMini.h,
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    child: CustomButton(
                      text: getTranslated("confirm"),
                      onTap: () {
                        if (context
                            .read<ChangeStatusBloc>()
                            .key
                            .currentState!
                            .validate()) {
                          context.read<ChangeStatusBloc>().add(Click(
                                  arguments: {
                                    "id": id,
                                    "onSuccess": (v) => onSuccess?.call(v)
                                  }));
                        } else {
                          AppCore.showToast(getTranslated(
                              "oops_you_have_to_fill_all_inputs"));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
