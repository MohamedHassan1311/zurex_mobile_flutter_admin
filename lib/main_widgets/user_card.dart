import 'package:flutter/material.dart';
import 'package:zurex_admin/components/custom_network_image.dart';
import 'package:zurex_admin/main_models/user_model.dart';

import '../app/core/dimensions.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, this.user});
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall.h),
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
        color: Styles.WHITE_COLOR,
      ),
      child: Row(
        spacing: Dimensions.paddingSizeMini.w,
        children: [
          CustomNetworkImage.circleNewWorkImage(
              radius: 25.w, image: user?.profileImage),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4.h,
            children: [
              Text(
                user?.name ?? "",
                style: AppTextStyles.w700
                    .copyWith(fontSize: 14, color: Styles.HEADER),
              ),
              Text(
                user?.phone ?? "",
                style: AppTextStyles.w500
                    .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
