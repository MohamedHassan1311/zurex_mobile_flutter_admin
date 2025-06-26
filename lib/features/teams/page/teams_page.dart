import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/localization/language_constant.dart';
import 'package:zurex_admin/components/custom_app_bar.dart';

import '../../../app/core/app_state.dart';
import '../../../data/config/di.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_widgets/guest_mode.dart';
import '../widgets/teams_body.dart';
import '../widgets/teams_header.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("teams"),
      ),
      body: BlocBuilder<UserBloc, AppState>(
        builder: (context, state) {
          return sl<UserBloc>().isLogin
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TeamsHeader(),
                    TeamsBody(),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child: GuestMode())],
                );
        },
      ),
    );
  }
}
