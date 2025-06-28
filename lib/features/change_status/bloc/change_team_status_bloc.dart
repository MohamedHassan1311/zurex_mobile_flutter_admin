import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zurex_admin/components/loading_dialog.dart';
import 'package:zurex_admin/features/change_status/entity/team_status_entity.dart';
import 'package:zurex_admin/features/order_details/model/order_details_model.dart';
import 'package:zurex_admin/main_models/search_engine.dart';
import 'package:zurex_admin/navigation/custom_navigation.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../data/error/failures.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/config/di.dart';
import '../../orders/bloc/orders_bloc.dart';
import '../repo/change_status_repo.dart';

class ChangeTeamStatusBloc extends Bloc<AppEvent, AppState> {
  final ChangeStatusRepo repo;

  ChangeTeamStatusBloc({required this.repo}) : super(Start()) {
    updateEntity(TeamStatusEntity());
    on<Click>(onClick);
  }

  final key = GlobalKey<FormState>();

  final entity = BehaviorSubject<TeamStatusEntity?>();
  Function(TeamStatusEntity?) get updateEntity => entity.sink.add;
  Stream<TeamStatusEntity?> get entityStream =>
      entity.stream.asBroadcastStream();

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      loadingDialog();
      entity.valueOrNull?.copyWith(id: (event.arguments as Map)["id"]);
      Either<ServerFailure, Response> response =
          await repo.changeTeamStatus(entity.valueOrNull!);

      ///To Close Loading Dialog
      CustomNavigator.pop();

      response.fold((fail) {
        AppCore.showToast(fail.error);
        emit(Error());
      }, (success) {
        OrderDetailsModel model =
            OrderDetailsModel.fromJson(success.data["data"]);
        (event.arguments as Map)["onSuccess"].call(model);
        sl<OrdersBloc>().add(Click(arguments: SearchEngine(isUpdate: true)));
        AppCore.showToast(getTranslated("your_order_updated_successfully"));

        ///To Close Bottom sheet
        CustomNavigator.pop();
        emit(Done());
      });
    } catch (e) {
      AppCore.showToast(e.toString());
      CustomNavigator.pop();
      emit(Error());
    }
  }
}
