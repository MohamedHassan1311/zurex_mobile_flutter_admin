import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/dimensions.dart';
import 'package:zurex_admin/app/core/extensions.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../data/config/di.dart';
import '../../../main_models/search_engine.dart';
import '../bloc/orders_bloc.dart';
import 'order_tabs.dart';

class OrdersHeader extends StatefulWidget {
  const OrdersHeader({super.key});

  @override
  State<OrdersHeader> createState() => _OrdersHeaderState();
}

class _OrdersHeaderState extends State<OrdersHeader> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, AppState>(builder: (context, state) {
      return StreamBuilder(
        stream: sl<OrdersBloc>().goingDownStream,
        builder: (context, snapshot) {
          return AnimatedCrossFade(
            crossFadeState: snapshot.data == true
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 400),
            firstChild: SizedBox(width: context.width),
            secondChild: Padding(
              padding: EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_DEFAULT.w,
                right: Dimensions.PADDING_SIZE_DEFAULT.w,
                top: Dimensions.PADDING_SIZE_DEFAULT.h,
                bottom: Dimensions.paddingSizeExtraSmall.h,
              ),
              child: Column(
                children: [
                  OrderTabs(),
                  // SizedBox(height: 6.h),
                  // CustomTextField(
                  //   hint: getTranslated("search_by_order_id"),
                  //   controller: sl<OrdersBloc>().searchTEC,
                  //   pSvgIcon: SvgImages.search,
                  //   withLabel: false,
                  //   onChanged: (v) {
                  //     if (timer != null) if (timer!.isActive) timer!.cancel();
                  //     timer = Timer(
                  //       const Duration(milliseconds: 400),
                  //       () {
                  //         sl<OrdersBloc>()
                  //             .add(Click(arguments: SearchEngine()));
                  //       },
                  //     );
                  //   },
                  //   onSubmit: (v) {
                  //     sl<OrdersBloc>().add(Click(arguments: SearchEngine()));
                  //   },
                  // ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
