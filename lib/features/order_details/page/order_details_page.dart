import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/extensions.dart';
import 'package:zurex_admin/app/localization/language_constant.dart';
import 'package:zurex_admin/components/custom_app_bar.dart';
import 'package:zurex_admin/components/shimmer/custom_shimmer.dart';
import 'package:zurex_admin/features/order_details/bloc/order_details_bloc.dart';
import 'package:zurex_admin/features/order_details/model/order_details_model.dart';
import 'package:zurex_admin/features/order_details/repo/order_details_repo.dart';
import 'package:zurex_admin/features/teams/widgets/team_card.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../components/animated_widget.dart';
import '../../../components/empty_widget.dart';
import '../../../data/config/di.dart';
import '../widgets/delivery_date.dart';
import '../widgets/delivery_location.dart';
import '../widgets/order_bill_details.dart';
import '../widgets/order_current_status.dart';
import '../widgets/order_details_actions.dart';
import '../widgets/order_products.dart';
import '../widgets/order_status_list.dart';
import '../widgets/order_user_card.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("order_details"),
      ),
      body: BlocProvider(
        create: (context) => OrderDetailsBloc(repo: sl<OrderDetailsRepo>())
          ..add(Click(arguments: id)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<OrderDetailsBloc, AppState>(
                  builder: (context, state) {
                    if (state is Done) {
                      OrderDetailsModel model = state.model as OrderDetailsModel;
                      return Column(
                        children: [
                          ///Order Body
                          Expanded(
                            child: ListAnimator(
                              customPadding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                              ),
                              data: [
                                SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT.h),
                                OrderCurrentStatus(
                                  orderNum: model.orderNum,
                                  status: model.status,
                                ),
                                OrderStatusList(list: model.statuses ?? []),
                                OrderProducts(items: model.products ?? []),
                                DeliveryDate(
                                  date: model.deliveryDate,
                                  time: model.deliveryTime?.name,
                                ),
                                DeliveryLocation(address: model.address),
                                OrderClientCard(user: model.user),
                                if (model.team != null)
                                  TeamCard(
                                      team: model.team!, fromOrderDetails: true),
                                OrderBillDetails(bill: model.bill),
                                SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT.h),
                              ],
                            ),
                          ),

                          ///Order Actions
                          if(model.availableStatus != null && model.availableStatus!.isNotEmpty)
                          OrderDetailsActions(id: id, availableStatus: model.availableStatus??[]),
                        ],
                      );
                    }
                    if (state is Loading) {
                      return ListAnimator(
                        customPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        ),
                        data: [
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeMini.h),
                            child: CustomShimmerContainer(
                              height: 80.h,
                              width: context.width,
                              radius: 16.w,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeMini.h),
                            child: CustomShimmerContainer(
                              height: 150.h,
                              width: context.width,
                              radius: 16.w,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeMini.h),
                            child: CustomShimmerContainer(
                              height: 150.h,
                              width: context.width,
                              radius: 16.w,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeMini.h),
                            child: CustomShimmerContainer(
                              height: 160.h,
                              width: context.width,
                              radius: 16.w,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeMini.h),
                            child: CustomShimmerContainer(
                              height: 80.h,
                              width: context.width,
                              radius: 16.w,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeMini.h),
                            child: CustomShimmerContainer(
                              height: 160.h,
                              width: context.width,
                              radius: 16.w,
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is Error || state is Empty) {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<OrderDetailsBloc>()
                              .add(Click(arguments: id));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                customPadding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                                ),
                                data: [
                                  SizedBox(height: 50.h),
                                  EmptyState(
                                    txt: getTranslated("no_result_found"),
                                    subText: state is Error
                                        ? getTranslated("something_went_wrong")
                                        : getTranslated(
                                            "no_result_found_description"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
