import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../data/error/failures.dart';
import '../model/cancel_reasons_model.dart';
import '../repo/cancel_order_repo.dart';

class CancellationReasonsBloc extends Bloc<AppEvent, AppState> {
  final CancelOrderRepo repo;

  CancellationReasonsBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      Either<ServerFailure, Response> response =
          await repo.getCancellationReasons();

      response.fold((fail) {
        emit(Error());
      }, (success) {
        CancelReasonsModel model = CancelReasonsModel.fromJson(success.data);

        if (model.data != null && model.data!.isNotEmpty) {
          emit(Done(list: model.data!));
        } else {
          emit(Empty());
        }
      });
    } catch (e) {
      emit(Error());
    }
  }
}
