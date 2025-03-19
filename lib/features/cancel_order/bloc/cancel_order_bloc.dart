import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zurex_admin/features/order_details/model/order_details_model.dart';
import 'package:zurex_admin/main_models/search_engine.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../data/error/failures.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
import '../../../navigation/custom_navigation.dart';
import '../../orders/bloc/orders_bloc.dart';
import '../repo/cancel_order_repo.dart';

class CancelOrderBloc extends Bloc<AppEvent, AppState> {
  final CancelOrderRepo repo;

  CancelOrderBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  final selectedReason = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateSelectReason => selectedReason.sink.add;
  Stream<CustomFieldModel?> get selectedReasonStream =>
      selectedReason.stream.asBroadcastStream();

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      if (selectedReason.valueOrNull == null) {
        return AppCore.showToast(getTranslated("oops_select_cancel_reason"));
      }
      emit(Loading());
      Either<ServerFailure, Response> response = await repo.cancelRequest(
          id: (event.arguments as Map)["id"] as int,
          reasonId: selectedReason.valueOrNull?.id);

      response.fold((fail) {
        AppCore.showToast(fail.error);
        emit(Error());
      }, (success) {
        OrderDetailsModel model =
            OrderDetailsModel.fromJson(success.data["data"]);
        (event.arguments as Map)["onSuccess"].call(model);
        sl<OrdersBloc>().add(Click(arguments: SearchEngine(isUpdate: true)));

        AppCore.showToast(getTranslated("your_order_cancelled_successfully"));
        CustomNavigator.pop();
        emit(Done());
      });
    } catch (e) {
      AppCore.showToast(e.toString());
      emit(Error());
    }
  }
}
