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

class OrderTeamCard extends StatelessWidget {
  const OrderTeamCard({super.key, required this.team, this.teamStatus});
  final TeamModel team;
  final TeamStatus? teamStatus;

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
        margin:
            EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall.h),
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
          color: Styles.WHITE_COLOR,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Dimensions.PADDING_SIZE_SMALL.h,
                  bottom: Dimensions.paddingSizeMini.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      team.name ?? "",
                      style: AppTextStyles.w700
                          .copyWith(fontSize: 16, color: Styles.PRIMARY_COLOR),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: 8.w,
                            height: 8.w,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: Styles.PRIMARY_COLOR,
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: SizedBox()),
                        Flexible(
                          child: Text(
                           getTranslated( teamStatus?.name??''),
                            style: AppTextStyles.w600.copyWith(
                                fontSize: 14,
                                color: Styles.PRIMARY_COLOR,
                                height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
        ),
      ),
    );
  }
}
