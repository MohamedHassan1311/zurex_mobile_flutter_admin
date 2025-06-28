import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:zurex_admin/app/core/app_state.dart';
import 'package:zurex_admin/app/core/text_styles.dart';
import 'package:zurex_admin/features/change_status/repo/change_status_repo.dart';
import 'package:zurex_admin/features/order_details/model/order_details_model.dart';
import 'package:zurex_admin/features/team_details/model/team_model.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/config/di.dart';
import '../bloc/change_team_status_bloc.dart';

class UpdateTeamStatus extends StatelessWidget {
  const UpdateTeamStatus(
      {super.key, required this.id, this.teamStatus, this.onSuccess});

  final int id;
  final TeamStatus? teamStatus;
  final Function(OrderDetailsModel)? onSuccess;

  @override
  Widget build(BuildContext context) {
    int index = TeamStatus.values.indexWhere((v) => v == teamStatus);
    if (index != -1 ) {
      return BlocProvider(
        create: (context) => ChangeTeamStatusBloc(repo: sl<ChangeStatusRepo>()),
        child: BlocBuilder<ChangeTeamStatusBloc, AppState>(
            builder: (context, state) {
          return SwipeButton(
            thumbPadding: EdgeInsets.all(4.w),
            borderRadius: BorderRadius.circular(12.w),
            thumb: Icon(
              Icons.arrow_forward,
              color: Styles.PRIMARY_COLOR,
              size: 24,
            ),
            activeTrackColor: Styles.PRIMARY_COLOR,
            activeThumbColor: Styles.WHITE_COLOR,
            inactiveThumbColor: Styles.WHITE_COLOR,
            inactiveTrackColor: Styles.GREEN,
            enabled: state is! Loading,
            elevationThumb: 2,
            elevationTrack: 2,
            height: 60,
            child: Text(
              getTranslated(TeamStatus.values[(index + 1)].name),
              style: AppTextStyles.w700.copyWith(
                color: Styles.WHITE_COLOR,
                fontSize: 16,
              ),
            ),
            onSwipe: () => context.read<ChangeTeamStatusBloc>().add(Click(
                  arguments: {
                    "id": id,
                    "team_status": TeamStatus.values[(index + 1)].name,
                    "onSuccess": (v) => onSuccess?.call(v),
                  },
                )),
          ).animate(onPlay: (c) {
            c.repeat();
          }).shimmer(
              color: Colors.white.withValues(alpha: 0.4), duration: 1500.ms);
        }),
      );
    } else {
      return const SizedBox();
    }
  }
}
