import 'package:flutter/material.dart';
import '../../../app/core/app_core.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../model/order_details_model.dart';

class OrderBillDetails extends StatelessWidget {
  const OrderBillDetails({super.key, this.bill});
  final BillModel? bill;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMini.h),
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
      decoration: BoxDecoration(
        color: Styles.WHITE_COLOR,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(
          color: Styles.LIGHT_BORDER_COLOR,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated("receipt_details"),
            style:
                AppTextStyles.w700.copyWith(fontSize: 16, color: Styles.HEADER),
          ),
          SizedBox(height: 8.h),

          ///Sub Total
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated("sub_total"),
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.HEADER),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "+${(bill?.subTotal ?? 0).toStringAsFixed(2)}  ",
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                    children: [
                      WidgetSpan(
                          child: AppCore.saudiRiyalSymbol(
                              color: Styles.DETAILS_COLOR, size: 16.w)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///Discount
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated("discount"),
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.HEADER),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "-${(bill?.discount ?? 0).toStringAsFixed(2)}  ",
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 14, color: Styles.IN_ACTIVE),
                    children: [
                      WidgetSpan(
                          child: AppCore.saudiRiyalSymbol(
                              color: Styles.IN_ACTIVE, size: 16.w)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///Installation Charges
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  getTranslated("installation_charges"),
                  style: AppTextStyles.w600
                      .copyWith(fontSize: 14, color: Styles.HEADER),
                )),
                RichText(
                  text: TextSpan(
                    text:
                        "+${(bill?.installationCharges ?? 0).toStringAsFixed(2)}  ",
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                    children: [
                      WidgetSpan(
                          child: AppCore.saudiRiyalSymbol(
                              color: Styles.DETAILS_COLOR, size: 16.w)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///Delivery Charges
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated("delivery_charges"),
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.HEADER),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text:
                        "+${(bill?.deliveryCharges ?? 0).toStringAsFixed(2)}  ",
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                    children: [
                      WidgetSpan(
                          child: AppCore.saudiRiyalSymbol(
                              color: Styles.DETAILS_COLOR, size: 16.w)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///Tax
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${getTranslated("tax")}(${bill?.taxPercentage ?? 0}%)",
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 14, color: Styles.HEADER),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "+${(bill?.tax ?? 0).toStringAsFixed(2)}  ",
                    style: AppTextStyles.w500
                        .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                    children: [
                      WidgetSpan(
                          child: AppCore.saudiRiyalSymbol(
                              color: Styles.DETAILS_COLOR, size: 16.w)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///Total
          // if (bill?.actualTotalPrice == bill?.totalPrice)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated("total"),
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 16, color: Styles.TITLE),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "+${(bill?.totalPrice ?? 0).toStringAsFixed(2)}  ",
                    style: AppTextStyles.w600
                        .copyWith(fontSize: 16, color: Styles.ACTIVE),
                    children: [
                      WidgetSpan(
                          child:
                              AppCore.saudiRiyalSymbol(color: Styles.ACTIVE)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///Paid From Wallet
          if (bill?.paidFromWallet != null && bill?.paidFromWallet != 0)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTranslated("from_wallet"),
                      style: AppTextStyles.w600
                          .copyWith(fontSize: 14, color: Styles.HEADER),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text:
                          "-${(bill?.paidFromWallet ?? 0).toStringAsFixed(2)}  ",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                      children: [
                        WidgetSpan(
                            child: AppCore.saudiRiyalSymbol(
                                color: Styles.DETAILS_COLOR, size: 16.w)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ///Remaining Amount
          if (bill?.actualTotalPrice != bill?.totalPrice)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      getTranslated("remaining_amount"),
                      style: AppTextStyles.w600
                          .copyWith(fontSize: 14, color: Styles.HEADER),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text:
                          "+${(bill?.actualTotalPrice ?? 0).toStringAsFixed(2)}  ",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                      children: [
                        WidgetSpan(
                            child: AppCore.saudiRiyalSymbol(
                                color: Styles.DETAILS_COLOR, size: 16.w)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
