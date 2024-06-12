import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_plan_app/src/presentation/view/draw_desk/bloc/draw/draw_bloc.dart';
import 'package:my_plan_app/src/presentation/view/draw_desk/draw_plan_screen.dart';

import 'common/app_styles/app_theme.dart';
import 'common/utils/l10n/generated/l10n.dart';
import 'common/utils/locale/locale.dart';

class Application extends StatelessWidget {
  const Application({super.key});

 // final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DrawBloc(),
        ),

      ],
      child: ScreenUtilInit(
        useInheritedMediaQuery: true,
        builder: (context, child) => LocaleBuilder(builder: (context, locale) {
          return MaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: locale,
            supportedLocales: S.delegate.supportedLocales,
            theme: AppTheme.lightTheme,
            home: const DrawPlanScreen(),
          );
        }),
      ),
    );
  }
}
