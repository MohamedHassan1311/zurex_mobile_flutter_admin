import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/extensions.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/search_engine.dart';
import '../../team_details/model/team_model.dart';
import '../bloc/teams_bloc.dart';
import 'team_card.dart';

class TeamsBody extends StatelessWidget {
  const TeamsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TeamsBloc, AppState>(
        builder: (context, state) {
          if (state is Loading) {
            return ListAnimator(
              controller: sl<TeamsBloc>().controller,
              customPadding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
              data: List.generate(
                10,
                (i) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: CustomShimmerContainer(
                    height: 120.h,
                    width: context.width,
                    radius: 12.w,
                  ),
                ),
              ),
            );
          }
          if (state is Done) {
            List<TeamModel> teams = state.list as List<TeamModel>;
            return RefreshIndicator(
              color: Styles.PRIMARY_COLOR,
              onRefresh: () async {
                sl<TeamsBloc>().add(Click(arguments: SearchEngine()));
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListAnimator(
                      controller: sl<TeamsBloc>().controller,
                      customPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      data: List.generate(
                        teams.length,
                        (i) => TeamCard(
                          team: teams[i],
                        ),
                      ),
                    ),
                  ),
                  CustomLoadingText(loading: state.loading),
                ],
              ),
            );
          }
          if (state is Error || state is Empty) {
            return RefreshIndicator(
              color: Styles.PRIMARY_COLOR,
              onRefresh: () async {
                sl<TeamsBloc>().add(Click(arguments: SearchEngine()));
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListAnimator(
                      controller: sl<TeamsBloc>().controller,
                      customPadding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                      ),
                      data: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.h),
                          child: EmptyState(
                              txt: state is Error
                                  ? getTranslated("something_went_wrong")
                                  : null),
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
    );
  }
}
