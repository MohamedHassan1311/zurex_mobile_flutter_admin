import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/features/orders/bloc/orders_bloc.dart';
import 'package:zurex_admin/main_models/search_engine.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/config/di.dart';

class OrderTabs extends StatelessWidget {
  const OrderTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder<OrderMainStatus>(
            stream: sl<OrdersBloc>().selectTabStream,
            builder: (context, snapshot) {
              return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraSmall.w,
                    vertical: Dimensions.paddingSizeExtraSmall.h,
                  ),
                  decoration: BoxDecoration(
                      color: Styles.SMOKED_WHITE_COLOR,
                      borderRadius: BorderRadius.circular(12.w)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      OrderMainStatus.values.length,
                      (i) => Expanded(
                        child: _TabButton(
                          onSelect: (v) {
                            if (state is! Loading) {
                              sl<OrdersBloc>().updateSelectTab(v);
                              sl<OrdersBloc>()
                                  .add(Click(arguments: SearchEngine()));
                            }
                          },
                          orderStatus: OrderMainStatus.values[i],
                          isSelect: snapshot.data?.index == i,
                        ),
                      ),
                    ),
                  ));
            });
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton(
      {required this.orderStatus, this.isSelect = false, this.onSelect});

  final OrderMainStatus orderStatus;
  final bool isSelect;
  final Function(OrderMainStatus)? onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect?.call(orderStatus),
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: isSelect ? Styles.PRIMARY_COLOR : Styles.WHITE_COLOR,
          borderRadius: BorderRadius.circular(100),
        ),
        margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeMini.w),
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeMini.w,
            vertical: Dimensions.paddingSizeExtraSmall.h),
        child: Text(
          getTranslated(orderStatus.name),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.w600.copyWith(
              fontSize: 16,
              color: isSelect ? Styles.WHITE_COLOR : Styles.HEADER),
        ),
      ),
    );
  }
}
