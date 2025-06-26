import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex_admin/app/core/dimensions.dart';
import 'package:zurex_admin/app/core/extensions.dart';
import 'package:zurex_admin/features/teams/bloc/teams_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../data/config/di.dart';
import '../../../main_models/search_engine.dart';

class TeamsHeader extends StatefulWidget {
  const TeamsHeader({super.key});

  @override
  State<TeamsHeader> createState() => _TeamsHeaderState();
}

class _TeamsHeaderState extends State<TeamsHeader> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsBloc, AppState>(builder: (context, state) {
      return StreamBuilder(
        stream: sl<TeamsBloc>().goingDownStream,
        builder: (context, snapshot) {
          return AnimatedCrossFade(
            crossFadeState: snapshot.data == true
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 400),
            firstChild: SizedBox(width: context.width),
            secondChild: Padding(
              padding: EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_DEFAULT.w,
                right: Dimensions.PADDING_SIZE_DEFAULT.w,
                top: Dimensions.paddingSizeExtraSmall.h,
                bottom: Dimensions.paddingSizeExtraSmall.h,
              ),
              child: CustomTextField(
                hint: getTranslated("search_hint"),
                controller: context.read<TeamsBloc>().searchTEC,
                pSvgIcon: SvgImages.search,
                withLabel: false,
                onChanged: (v) {
                  if (timer != null) if (timer!.isActive) timer!.cancel();
                  timer = Timer(
                    const Duration(milliseconds: 400),
                    () {
                      context
                          .read<TeamsBloc>()
                          .add(Click(arguments: SearchEngine()));
                    },
                  );
                },
                onSubmit: (v) {
                  context
                      .read<TeamsBloc>()
                      .add(Click(arguments: SearchEngine()));
                },
              ),
            ),
          );
        },
      );
    });
  }
}
