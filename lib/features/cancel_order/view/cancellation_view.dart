import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/extensions.dart';
import 'package:zurex_admin/components/shimmer/custom_shimmer.dart';
import 'package:zurex_admin/main_models/custom_field_model.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_single_selector.dart';
import '../../../components/empty_widget.dart';
import '../../../data/config/di.dart';
import '../../../navigation/custom_navigation.dart';
import '../../order_details/model/order_details_model.dart';
import '../bloc/cancel_order_bloc.dart';
import '../bloc/cancellation_reasons_bloc.dart';
import '../model/cancel_reasons_model.dart';
import '../repo/cancel_order_repo.dart';

class CancellationView extends StatelessWidget {
  const CancellationView(
      {super.key, required this.id, required this.onSuccess});

  final int id;
  final Function(OrderDetailsModel) onSuccess;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CancelOrderBloc(repo: sl<CancelOrderRepo>()),
        ),
        BlocProvider(
          create: (context) =>
              CancellationReasonsBloc(repo: sl<CancelOrderRepo>())
                ..add(Click()),
        ),
      ],
      child: Column(
        children: [
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

          ///Title
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getTranslated("cancel_order"),
                  style: AppTextStyles.w700.copyWith(fontSize: 18),
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
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            ),
            child: const Divider(
              color: Styles.BORDER_COLOR,
            ),
          ),

          ///Body
          Expanded(
            child: BlocBuilder<CancellationReasonsBloc, AppState>(
              builder: (context, state) {
                if (state is Done) {
                  List<CancelReasonModel> data =
                      state.list as List<CancelReasonModel>;
                  return BlocBuilder<CancelOrderBloc, AppState>(
                    builder: (context, state) {
                      return StreamBuilder<CustomFieldModel?>(
                          stream: context
                              .read<CancelOrderBloc>()
                              .selectedReasonStream,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                ///Body
                                Expanded(
                                    child: CustomSingleSelector(
                                  list: data
                                      .map((e) => CustomFieldModel(
                                          id: e.id, name: e.reason))
                                      .toList(),
                                  initialValue: snapshot.data?.id,
                                  onConfirm: (v) => context
                                      .read<CancelOrderBloc>()
                                      .updateSelectReason(
                                          v as CustomFieldModel),
                                )),
                                SafeArea(
                                  top: false,
                                  child: BlocBuilder<CancelOrderBloc, AppState>(
                                    builder: (context, state) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .PADDING_SIZE_DEFAULT.w,
                                            vertical:
                                                Dimensions.paddingSizeMini.h),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                text: getTranslated("back_off"),
                                                isActive: state is! Loading,
                                                backgroundColor: Styles
                                                    .PRIMARY_COLOR
                                                    .withOpacity(0.1),
                                                textColor: Styles.PRIMARY_COLOR,
                                                onTap: () =>
                                                    CustomNavigator.pop(),
                                              ),
                                            ),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_DEFAULT.w),
                                            Expanded(
                                              child: CustomButton(
                                                text: getTranslated("submit"),
                                                isLoading: state is Loading,
                                                onTap: () => context
                                                    .read<CancelOrderBloc>()
                                                    .add(Click(arguments: {
                                                      "id": id,
                                                      "onSuccess": onSuccess
                                                    })),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  );
                }
                if (state is Loading) {
                  return ListAnimator(
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.paddingSizeMini.h),
                    data: List.generate(
                      5,
                      (i) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeMini.h),
                        child: CustomShimmerContainer(
                          height: 60.h,
                          width: context.width,
                          radius: 12.w,
                        ),
                      ),
                    ),
                  );
                }
                if (state is Error || state is Empty) {
                  return ListAnimator(
                    customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    data: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        child: EmptyState(
                          txt: getTranslated("no_result_found"),
                          subText: state is Error
                              ? getTranslated("something_went_wrong")
                              : getTranslated("no_result_found_description"),
                        ),
                      ),
                      CustomButton(
                          text: getTranslated("refresh"),
                          onTap: () => context
                              .read<CancellationReasonsBloc>()
                              .add(Click(arguments: id)))
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
