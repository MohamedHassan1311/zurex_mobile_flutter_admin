import 'package:flutter/material.dart';
import 'package:zurex_admin/app/core/text_styles.dart';
import 'package:zurex_admin/app/localization/language_constant.dart';
import 'package:zurex_admin/features/teams/model/teams_model.dart';
import 'package:zurex_admin/navigation/custom_navigation.dart';
import 'package:zurex_admin/navigation/routes.dart';

import '../../../app/core/app_core.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../team_details/model/team_model.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({super.key, required this.team});
  final TeamModel team;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () =>
          CustomNavigator.push(Routes.teamDetails, arguments: team.id ?? 0),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: Dimensions.paddingSizeExtraSmall.h),
        margin:
            EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.w),
            border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
            color: Styles.WHITE_COLOR,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: Offset(1, 1),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        // text: "${(team.total ?? 0).toStringAsFixed(2)}  ",
                        style: AppTextStyles.w600
                            .copyWith(fontSize: 18, color: Styles.HEADER),
                        children: [
                          WidgetSpan(
                              child: AppCore.saudiRiyalSymbol(
                                  color: Styles.HEADER)),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Styles.PRIMARY_COLOR),
                    ),
                  ],
                )),
                InkWell(
                  onTap: () => CustomNavigator.push(Routes.teamDetails,
                      arguments: team.id ?? 0),
                  child: Row(
                    children: [
                      Text(
                        "${getTranslated("see_details")} ",
                        style: AppTextStyles.w500
                            .copyWith(fontSize: 14, color: Styles.ACCENT_COLOR),
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
            )
          ],
        ),
      ),
    );
  }
}
