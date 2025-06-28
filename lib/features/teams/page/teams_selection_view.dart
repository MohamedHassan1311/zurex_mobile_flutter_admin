import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/extensions.dart';
import 'package:zurex_admin/features/team_details/model/team_model.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/search_engine.dart';
import '../../../navigation/custom_navigation.dart';
import '../bloc/teams_bloc.dart';
import '../widgets/team_selection_card.dart';
import '../widgets/teams_header.dart';

class TeamsSelectionView extends StatefulWidget {
  const TeamsSelectionView({super.key, this.initialValue, this.onConfirm});
  final int? initialValue;
  final Function(TeamModel)? onConfirm;

  @override
  State<TeamsSelectionView> createState() => _TeamsSelectionViewState();
}

class _TeamsSelectionViewState extends State<TeamsSelectionView> {
  int? _selectedItem;
  @override
  void initState() {
    setState(() {
      _selectedItem = widget.initialValue;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
                  getTranslated("select_team"),
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
                vertical: 8.h, horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            child: const Divider(
              color: Styles.BORDER_COLOR,
            ),
          ),

          TeamsHeader(),

          ///Body
          Flexible(
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: ListAnimator(
                            controller: sl<TeamsBloc>().controller,
                            customPadding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                            data: List.generate(
                              teams.length,
                              (i) => TeamSelectionCard(
                                team: teams[i],
                                initialValue: _selectedItem,
                                onTap: () {
                                  setState(() => _selectedItem = teams[i].id);
                                  widget.onConfirm?.call(teams[i]);
                                },
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
          ),

          ///Button
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeMini.h,
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            child: CustomButton(
              text: getTranslated("confirm"),
              onTap: () => CustomNavigator.pop(),
            ),
          )
        ],
      ),
    );
  }
}
