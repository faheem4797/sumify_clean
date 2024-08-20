// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sumify_clean/app_bloc_observer.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/theme/theme.dart';
import 'package:sumify_clean/features/article/presentation/blocs/article_bloc/article_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:sumify_clean/features/contact_us/presentation/blocs/contact_us_bloc/contact_us_bloc.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/delete_account_bloc/delete_account_bloc.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/edit_profile_image_bloc/edit_profile_image_bloc.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/logout_bloc/logout_bloc.dart';
import 'package:sumify_clean/init_dependencies.dart';
import 'package:sumify_clean/routing/app_route_config.dart';
// import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await initDependencies();

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) =>
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (BuildContext context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
          BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
          BlocProvider(create: (_) => serviceLocator<SignUpBloc>()),
          BlocProvider(create: (_) => serviceLocator<SignInBloc>()),
          BlocProvider(create: (_) => serviceLocator<ForgotPasswordBloc>()),
          BlocProvider(create: (_) => serviceLocator<ArticleBloc>()),
          BlocProvider(create: (_) => serviceLocator<EditProfileImageBloc>()),
          BlocProvider(create: (_) => serviceLocator<LogoutBloc>()),
          BlocProvider(create: (_) => serviceLocator<DeleteAccountBloc>()),
          BlocProvider(create: (_) => serviceLocator<ContactUsBloc>()),
        ],
        child: const MyApp(),
      ),
    ),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sumify',
      theme: AppTheme.lightThemeMode,
      routerConfig: MyAppRouter().router,
    );
  }
}
