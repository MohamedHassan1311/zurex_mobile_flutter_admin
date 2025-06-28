import 'package:flutter/material.dart';
import 'package:zurex_admin/app/core/extensions.dart';
import 'package:zurex_admin/app/core/svg_images.dart';
import 'package:zurex_admin/app/core/text_styles.dart';
import 'package:zurex_admin/components/custom_images.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../team_details/model/team_model.dart';

class TeamSelectionCard extends StatelessWidget {
  const TeamSelectionCard(
      {super.key, required this.team, this.initialValue, this.onTap});
  final TeamModel team;
  final int? initialValue;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL.h),
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              vertical: Dimensions.PADDING_SIZE_SMALL.h),
          decoration: BoxDecoration(
            color: initialValue == team.id
                ? Styles.PRIMARY_COLOR
                : Styles.WHITE_COLOR,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: initialValue == team.id
                    ? Styles.WHITE_COLOR
                    : Styles.PRIMARY_COLOR),
          ),
          width: context.width,
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name ?? "",
                    style: AppTextStyles.w700.copyWith(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      color: initialValue == team.id
                          ? Styles.WHITE_COLOR
                          : Styles.PRIMARY_COLOR,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    spacing: 8.w,
                    children: [
                      customImageIconSVG(
                        imageName: SvgImages.location,
                        width: 18.w,
                        height: 18.w,
                        color: initialValue == team.id
                            ? Styles.WHITE_COLOR
                            : Styles.HEADER,
                      ),
                      Text(
                        team.zone ?? "",
                        style: AppTextStyles.w500.copyWith(
                          fontSize: 14,
                          color: initialValue == team.id
                              ? Styles.WHITE_COLOR
                              : Styles.HEADER,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              Icon(
                  initialValue == team.id
                      ? Icons.radio_button_checked_outlined
                      : Icons.radio_button_off,
                  size: 22,
                  color: initialValue == team.id
                      ? Styles.WHITE_COLOR
                      : Styles.PRIMARY_COLOR)
            ],
          )),
    );
  }
}
