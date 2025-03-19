import 'package:zurex_admin/app/core/app_state.dart';
import 'package:zurex_admin/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../main_blocs/user_bloc.dart';
import '../widgets/ads_section.dart';
import '../widgets/home_app_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, AppState>(
        builder: (context, state) {
          return Column(
            children: [
              const HomeAppBar(),
              Expanded(
                child: ListAnimator(
                  data: [
                    const AdsSection(),
                    const SizedBox(height: 24)
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
