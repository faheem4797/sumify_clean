import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/features/article/presentation/pages/home_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/forgot_password_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/sign_in_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/splash_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/sign_up_screen.dart';
import 'package:sumify_clean/features/contact_us/presentation/pages/contact_us_screen.dart';
import 'package:sumify_clean/features/profile/presentation/pages/profile_screen.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';
import 'package:sumify_clean/routing/widgets/initial_widget.dart';
import 'package:sumify_clean/routing/widgets/scaffold_with_navbar.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: AppRouteConstants.initialRouteName,
        path: AppRouteConstants.initialRoutePath,
        pageBuilder: (context, state) {
          return const MaterialPage(
              child: Scaffold(
            body: Center(
              child: Text(''),
            ),
          ));
        },
      ),
      GoRoute(
        name: AppRouteConstants.splashRouteName,
        path: AppRouteConstants.splashRoutePath,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SplashScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.signupRouteName,
        path: AppRouteConstants.signupRoutePath,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignUpScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.signinRouteName,
        path: AppRouteConstants.signinRoutePath,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignInScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.forgotPasswordRouteName,
        path: AppRouteConstants.forgotPasswordRoutePath,
        pageBuilder: (context, state) {
          return const MaterialPage(child: ForgotPasswordScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.loaderRouteName,
        path: AppRouteConstants.loaderRoutePath,
        pageBuilder: (context, state) {
          return const MaterialPage(child: InitialWidget());
        },
      ),
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              ScaffoldWithNavBar(navigationShell: navigationShell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: AppRouteConstants.homeRouteName,
                  path: AppRouteConstants.homeRoutePath,
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: HomeScreen());
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: AppRouteConstants.reportRouteName,
                  path: AppRouteConstants.reportRoutePath,
                  pageBuilder: (context, state) {
                    return const MaterialPage(
                        child: Scaffold(
                      body: Center(
                        child: Text('Report'),
                      ),
                    ));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: AppRouteConstants.commentsRouteName,
                  path: AppRouteConstants.commentsRoutePath,
                  pageBuilder: (context, state) {
                    return const MaterialPage(
                        child: Scaffold(
                      body: Center(
                        child: Text('Comments'),
                      ),
                    ));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: AppRouteConstants.contactRouteName,
                  path: AppRouteConstants.contactRoutePath,
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: ContactUsScreen());
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: AppRouteConstants.profileRouteName,
                  path: AppRouteConstants.profileRoutePath,
                  pageBuilder: (context, state) {
                    return const MaterialPage(child: ProfileScreen());
                  },
                ),
              ],
            ),
          ]),
      // GoRoute(
      //   // name: AppRouteConstants.homeRouteName,
      //   // path: AppRouteConstants.homeRoutePath,
      //   path: '/homePath',
      //   pageBuilder: (context, state) {
      //     return const MaterialPage(
      //         child: Scaffold(
      //       body: Center(
      //         child: Text('Home'),
      //       ),
      //     ));
      //   },
      // ),
    ],
    redirect: (context, state) {
      debugPrint(state.matchedLocation);
      if (state.matchedLocation == '/' || state.matchedLocation == '/loader') {
        final appUserState = context.read<AppUserCubit>().state;
        debugPrint(appUserState.toString());

        if (appUserState is AppUserInitial) {
          return '/splash';
        } else if (appUserState is AppUserLoggedIn) {
          return '/home';
        } else if (appUserState is AppUserLoading) {
          return '/loader';
        }
      }

      return null;
    },
  );
}
