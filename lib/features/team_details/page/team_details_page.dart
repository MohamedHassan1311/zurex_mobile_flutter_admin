import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/extensions.dart';
import 'package:zurex_admin/app/localization/language_constant.dart';
import 'package:zurex_admin/components/custom_app_bar.dart';
import 'package:zurex_admin/components/shimmer/custom_shimmer.dart';
import 'package:zurex_admin/features/team_details/bloc/team_details_bloc.dart';
import 'package:zurex_admin/features/team_details/model/team_model.dart';
import 'package:zurex_admin/features/team_details/repo/team_details_repo.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../components/animated_widget.dart';
import '../../../components/empty_widget.dart';
import '../../../data/config/di.dart';

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
                              SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT.h),
                            ],
                          ),
                        ),
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
                            height: 60.h,
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
