import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../app/core/app_core.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/core/app_notification.dart';
import '../../../../../app/core/app_state.dart';
import '../../../../../app/core/styles.dart';
import '../../../../../data/error/failures.dart';
import '../../../../../main_models/search_engine.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../model/orders_model.dart';
import '../repo/orders_repo.dart';

class OrdersBloc extends HydratedBloc<AppEvent, AppState> {
  final OrdersRepo repo;
  final InternetConnection internetConnection;

  OrdersBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    updateSelectTab(OrderMainStatus.current);
    searchTEC = TextEditingController();
    controller = ScrollController();
    customScroll(controller);
    on<Click>(onClick);
  }

  TextEditingController? searchTEC;

  late ScrollController controller;
  late SearchEngine _engine;
  List<OrderModel>? _model;

  final selectTab = BehaviorSubject<OrderMainStatus>();
  Function(OrderMainStatus) get updateSelectTab => selectTab.sink.add;
  Stream<OrderMainStatus> get selectTabStream =>
      selectTab.stream.asBroadcastStream();

  final goingDown = BehaviorSubject<bool>();
  Function(bool) get updateGoingDown => goingDown.sink.add;
  Stream<bool> get goingDownStream => goingDown.stream.asBroadcastStream();

  customScroll(ScrollController controller) {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        updateGoingDown(false);
      } else {
        updateGoingDown(true);
      }
      bool scroll = AppCore.scrollListener(
          controller, _engine.maxPages, _engine.currentPage!);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage!);
        add(Click(arguments: _engine));
      }
    });
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        _engine = event.arguments as SearchEngine;
        if (_engine.currentPage == 0) {
          _model = [];
          if (!_engine.isUpdate) {
            emit(Loading());
          }
        } else {
          emit(Done(data: _model, loading: true));
        }
        _engine.data = {
          "status": selectTab.value.name,
          // if (searchTEC?.text.trim() != "") "keyword": searchTEC?.text.trim(),
        };

        Either<ServerFailure, Response> response =
            await repo.getOrders(_engine);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          OrdersModel? res = OrdersModel.fromJson(success.data);

          if (_engine.currentPage == 0) {
            _model?.clear();
          }

          if (res.data != null && res.data!.isNotEmpty) {
            for (var item in res.data!) {
              _model?.removeWhere((e) => e.id == item.id);
              _model?.add(item);
            }
            _engine.maxPages = res.meta?.pagesCount ?? 1;
            _engine.updateCurrentPage(res.meta?.currentPage ?? 1);
          }

          if (_model != null && _model!.isNotEmpty) {
            emit(Done(list: _model, loading: false));
          } else {
            emit(Empty());
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
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['state'] == "Start") {
        return Start();
      }
      if (json['state'] == "Error") {
        return Error();
      }
      if (json['state'] == "Loading") {
        return Loading();
      }
      if (json['state'] == "Done") {
        return Done(
          list: List<OrderModel>.from(
              jsonDecode(json['list']).map((e) => OrderModel.fromJson(e))),
          loading: jsonDecode(json['loading']) as bool,
        );
      }
      return Loading();
    } catch (e) {
      return Error();
    }
  }

  @override
  Map<String, dynamic>? toJson(AppState? state) => state?.toJson();
}

enum OrderMainStatus { current, completed, cancelled }
