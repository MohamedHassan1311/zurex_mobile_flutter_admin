import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/main_blocs/user_bloc.dart';
import 'package:zurex_admin/main_widgets/guest_mode.dart';
import '../../../app/core/app_state.dart';
import '../../../data/config/di.dart';
import '../widgets/main_app_bar.dart';
import '../widgets/orders_body.dart';
import '../widgets/orders_header.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: SafeArea(
        child: BlocBuilder<UserBloc, AppState>(
          builder: (context, state) {
            return sl<UserBloc>().isLogin
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrdersHeader(),
                      OrdersBody(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Expanded(child: GuestMode())],
                  );
          },
        ),
      ),
    );
  }
}
