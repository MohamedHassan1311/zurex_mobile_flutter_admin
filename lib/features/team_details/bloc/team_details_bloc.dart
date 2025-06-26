import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zurex_admin/features/team_details/model/team_model.dart';
import 'package:zurex_admin/features/team_details/repo/team_details_repo.dart';

import '../../../../../app/core/app_core.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/core/app_notification.dart';
import '../../../../../app/core/app_state.dart';
import '../../../../../app/core/styles.dart';
import '../../../../../data/error/failures.dart';

class TeamDetailsBloc extends Bloc<AppEvent, AppState> {
  final TeamDetailsRepo repo;

  TeamDetailsBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    on<Update>(onUpdate);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Either<ServerFailure, Response> response =
          await repo.getTeamDetails(event.arguments as int);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        if (success.data["data"] != null) {
          TeamModel? res = TeamModel.fromJson(success.data["data"]);
          emit(Done(model: res));
        } else {
          emit(Error());
        }
      });
    } catch (e) {
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
      emit(Error());
    }
  }

  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    emit(Done(model: event.arguments as TeamModel));
  }
}
