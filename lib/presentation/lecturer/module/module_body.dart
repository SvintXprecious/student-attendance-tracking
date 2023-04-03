import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:student_attendance/config/config.dart';
import 'package:student_attendance/presentation/lecturer/module/components/module_card_builder.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';
import 'package:student_attendance/state/module/providers/fetch_lecturer_modules_provider.dart';


class ModuleBody extends ConsumerWidget {
  const ModuleBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var dimension=Dimensions(context: context);
    final modules=ref.watch(fetchLecturerModulesProvider(authStateProvider));
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(fetchLecturerModulesProvider(authStateProvider));
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Container(
        margin: EdgeInsets.only(
            left: dimension.horizontalPadding20,
            right: dimension.horizontalPadding20,
            top: dimension.verticalPadding20),
        child:modules.when(
          data: (modules) => ModuleCardBuilder(modules: modules),
          error: (error, stackTrace) => Container(),
          loading: () => Container(),
        ),
      ),
    );

  }
}
