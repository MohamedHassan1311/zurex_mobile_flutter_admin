import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/features/order_details/bloc/order_details_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_button.dart';
import '../../cancel_order/view/cancellation_view.dart';

class OrderDetailsActions extends StatelessWidget {
  const OrderDetailsActions(
      {super.key,
      required this.id,
      required this.canCancel,
      required this.canRate});
  final int id;
  final bool canCancel, canRate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
        vertical: Dimensions.paddingSizeMini.w,
      ),
      child: Column(
        children: [
          if (canCancel)
            SafeArea(
              top: false,
              child: CustomButton(
                onTap: () => CustomBottomSheet.general(
                    widget: CancellationView(
                        id: id,
                        onSuccess: (v) => context
                            .read<OrderDetailsBloc>()
                            .add(Update(arguments: v)))),
                textColor: Styles.DETAILS_COLOR,
                backgroundColor: Styles.FILL_COLOR,
                text: getTranslated("cancel_order"),
              ),
            ),
        ],
      ),
    );
  }
}
