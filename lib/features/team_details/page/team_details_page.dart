import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/localization/language_constant.dart';
import 'package:zurex_admin/components/custom_app_bar.dart';
import 'package:zurex_admin/components/custom_loading.dart';
import 'package:zurex_admin/components/grid_list_animator.dart';
import 'package:zurex_admin/features/team_details/bloc/team_details_bloc.dart';
import 'package:zurex_admin/features/team_details/model/team_model.dart';
import 'package:zurex_admin/features/team_details/repo/team_details_repo.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_images.dart';
import '../../../components/empty_widget.dart';
import '../../../data/config/di.dart';
import '../../../main_widgets/user_card.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';

class TeamDetailsPage extends StatelessWidget {
  const TeamDetailsPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("team_details"),
      ),
      body: BlocProvider(
        create: (context) => TeamDetailsBloc(repo: sl<TeamDetailsRepo>())
          ..add(Click(arguments: id)),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<TeamDetailsBloc, AppState>(
                builder: (context, state) {
                  if (state is Done) {
                    TeamModel model = state.model as TeamModel;
                    return ListAnimator(
                      customPadding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      data: [
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),

                        ///Team Name
                        Text(
                          model.name ?? "",
                          style: AppTextStyles.w700.copyWith(
                              fontSize: 26, color: Styles.PRIMARY_COLOR),
                        ),

                        ///Team Zone
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_SMALL.h),
                          child: Row(
                            spacing: 8.w,
                            children: [
                              customImageIconSVG(
                                imageName: SvgImages.location,
                                width: 22.w,
                                height: 22.w,
                                color: Styles.HEADER,
                              ),
                              Expanded(
                                child: Text(
                                  model.zone ?? "",
                                  style: AppTextStyles.w500.copyWith(
                                      fontSize: 18, color: Styles.HEADER),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///Team Statistics
                        Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.paddingSizeMini.h),
                          child: Row(
                            spacing: 8.w,
                            children: [
                              customImageIconSVG(
                                imageName: SvgImages.barChart,
                                width: 22.w,
                                height: 22.w,
                                color: Styles.HEADER,
                              ),
                              Expanded(
                                child: Text(
                                  getTranslated("team_statistics"),
                                  style: AppTextStyles.w600.copyWith(
                                      fontSize: 18, color: Styles.HEADER),
                                ),
                              ),
                              InkWell(
                                onTap: () => CustomNavigator.push(
                                    Routes.teamDetails,
                                    arguments: model.id ?? 0),
                                child: Row(
                                  children: [
                                    Text(
                                      "${getTranslated("see_details")} ",
                                      style: AppTextStyles.w500.copyWith(
                                          fontSize: 14,
                                          color: Styles.ACCENT_COLOR),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Styles.ACCENT_COLOR,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        GridListAnimatorWidget(
                            columnCount: 3,
                            aspectRatio: 2.5,
                            items: [
                              _StatisticsInfo(
                                title: getTranslated("total_orders"),
                                value: "${model.numOfOrders ?? 0}",
                              ),
                              _StatisticsInfo(
                                title: getTranslated("delivered_orders"),
                                value: "${model.numOfOrdersDelivered ?? 0}",
                              ),
                              _StatisticsInfo(
                                title: getTranslated("cancelled_orders"),
                                value: "${model.numOfOrdersCancelled ?? 0}",
                              ),
                            ]),

                        ///Supervisor
                        Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_DEFAULT.h),
                          child: Text(
                            getTranslated("supervisor"),
                            style: AppTextStyles.w600
                                .copyWith(fontSize: 18, color: Styles.HEADER),
                          ),
                        ),
                        ...List.generate(
                          model.supervisor?.length ?? 0,
                          (i) => UserCard(
                            user: model.supervisor?[i],
                          ),
                        ),

                        ///Driver
                        Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_DEFAULT.h),
                          child: Text(
                            getTranslated("driver"),
                            style: AppTextStyles.w600
                                .copyWith(fontSize: 18, color: Styles.HEADER),
                          ),
                        ),
                        ...List.generate(
                          model.driver?.length ?? 0,
                          (i) => UserCard(
                            user: model.driver?[i],
                          ),
                        ),

                        ///Members
                        Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_DEFAULT.h),
                          child: Text(
                            getTranslated("members"),
                            style: AppTextStyles.w600
                                .copyWith(fontSize: 18, color: Styles.HEADER),
                          ),
                        ),
                        ...List.generate(
                          model.members?.length ?? 0,
                          (i) => UserCard(
                            user: model.members?[i],
                          ),
                        ),

                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                      ],
                    );
                  }
                  if (state is Loading) {
                    return CustomLoading();
                  }
                  if (state is Error || state is Empty) {
                    return RefreshIndicator(
                      color: Styles.PRIMARY_COLOR,
                      onRefresh: () async {
                        context
                            .read<TeamDetailsBloc>()
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
    );
  }
}

class _StatisticsInfo extends StatelessWidget {
  const _StatisticsInfo({required this.title, required this.value});
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimensions.paddingSizeMini.h,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.w400.copyWith(fontSize: 12, color: Styles.TITLE),
        ),
        Text(
          value,
          style: AppTextStyles.w700
              .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
        ),
      ],
    );
  }
}
