import 'package:flutter/material.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_images.dart';
import '../../../../main_blocs/user_bloc.dart';

class ChooseUserType extends StatelessWidget {
  const ChooseUserType({super.key, required this.type, required this.onChange});
  final UserType type;
  final Function(UserType) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
      decoration: BoxDecoration(
          border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
          color: Styles.FILL_COLOR,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: List.generate(
          UserType.values.length,
          (i) => Expanded(
            child: InkWell(
              onTap: () => onChange.call(UserType.values[i]),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                    vertical: Dimensions.PADDING_SIZE_SMALL.h),
                decoration: BoxDecoration(
                  color: UserType.values[i].index == type.index
                      ? Styles.PRIMARY_COLOR
                      : Styles.FILL_COLOR,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customImageIconSVG(
                        imageName: UserType.values[i] == UserType.driver
                            ? SvgImages.driver
                            : SvgImages.user,
                        width: 20.w,
                        height: 20.w,
                        color: UserType.values[i].index == type.index
                            ? Styles.WHITE_COLOR
                            : Styles.DISABLED),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Text(
                        getTranslated(UserType.values[i].name),
                        maxLines: 1,
                        style: AppTextStyles.w600.copyWith(
                          fontSize: 14,
                          color: UserType.values[i].index == type.index
                              ? Styles.WHITE_COLOR
                              : Styles.DISABLED,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
