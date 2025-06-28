import 'package:flutter/material.dart';
import 'package:zurex_admin/app/core/svg_images.dart';
import 'package:zurex_admin/app/core/text_styles.dart';
import 'package:zurex_admin/app/localization/language_constant.dart';
import 'package:zurex_admin/components/custom_images.dart';
import 'package:zurex_admin/navigation/custom_navigation.dart';
import 'package:zurex_admin/navigation/routes.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../team_details/model/team_model.dart';

class TeamCard extends StatelessWidget {
  const TeamCard(
      {super.key, required this.team, this.fromOrderDetails = false});
  final TeamModel team;
  final bool fromOrderDetails;

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
            vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
        margin:
            EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.w),
            border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
            color: Styles.WHITE_COLOR,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                offset: Offset(1, 1),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimensions.PADDING_SIZE_SMALL.h,
          children: [
            if (fromOrderDetails)
              Row(
                children: [
                  customImageIconSVG(
                      imageName: SvgImages.users,
                      color: Styles.HEADER,
                      width: 18.w,
                      height: 18.w),
                  SizedBox(width: Dimensions.paddingSizeMini.w),
                  Expanded(
                    child: Text(
                      getTranslated("team_details"),
                      style: AppTextStyles.w700
                          .copyWith(fontSize: 16, color: Styles.HEADER),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team.name ?? "",
                      style: AppTextStyles.w700
                          .copyWith(fontSize: 16, color: Styles.PRIMARY_COLOR),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      spacing: 8.w,
                      children: [
                        customImageIconSVG(
                          imageName: SvgImages.location,
                          width: 18.w,
                          height: 18.w,
                          color: Styles.HEADER,
                        ),
                        Text(
                          team.zone ?? "",
                          style: AppTextStyles.w500
                              .copyWith(fontSize: 14, color: Styles.HEADER),
                        ),
                      ],
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
