import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/forgot_password_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/sign_in_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/splash_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/sign_up_screen.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';
import 'package:sumify_clean/routing/widgets/initial_widget.dart';
import 'package:sumify_clean/routing/widgets/scaffold_with_navbar.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: AppRouteConstants.initialRoute,
        path: '/',
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
        name: AppRouteConstants.splashRoute,
        path: '/splash',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SplashScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.signupRoute,
        path: '/signup',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignUpScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.signinRoute,
        path: '/signin',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignInScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.forgotPasswordRoute,
        path: '/forgotPassword',
        pageBuilder: (context, state) {
          return const MaterialPage(child: ForgotPasswordScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.loaderRoute,
        path: '/loader',
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
                  name: AppRouteConstants.homeRoute,
                  path: '/home',
                  pageBuilder: (context, state) {
                    return const MaterialPage(
                        child: Scaffold(
                      body: Center(
                        child: Text('Home'),
                      ),
                    ));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: AppRouteConstants.reportRoute,
                  path: '/report',
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
                  name: AppRouteConstants.commentsRoute,
                  path: '/comments',
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
                  name: AppRouteConstants.contactRoute,
                  path: '/contact',
                  pageBuilder: (context, state) {
                    return const MaterialPage(
                        child: Scaffold(
                      body: Center(
                        child: Text('Contact Us'),
                      ),
                    ));
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: AppRouteConstants.profileRoute,
                  path: '/profile',
                  pageBuilder: (context, state) {
                    return const MaterialPage(
                        child: Scaffold(
                      body: Center(
                        child: Text('Profile'),
                      ),
                    ));
                  },
                ),
              ],
            ),
          ]),
      // GoRoute(
      //   name: AppRouteConstants.homeRoute,
      //   path: '/loggedin',
      //   pageBuilder: (context, state) {
      //     return MaterialPage(
      //         child: Scaffold(
      //       body: Column(
      //         children: [
      //           const Center(
      //             child: Text('Logged In'),
      //           ),
      //           ElevatedButton(
      //               onPressed: () async {
      //                 try {
      //                   await FirebaseAuth.instance.signOut();
      //                   context.read<AppUserCubit>().updateUser(null);
      //                   context.goNamed(AppRouteConstants.signinRoute);
      //                 } catch (e) {
      //                   print(e);
      //                 }
      //               },
      //               child: const Text('Logout'))
      //         ],
      //       ),
      //     ));
      //   },
      // ),
    ],
    redirect: (context, state) {
      if (state.matchedLocation == '/' || state.matchedLocation == '/loader') {
        final appUserState = context.read<AppUserCubit>().state;

        if (appUserState is AppUserInitial) {
          return '/splash';
        } else if (appUserState is AppUserLoggedIn) {
          return '/loggedin';
        } else if (appUserState is AppUserLoading) {
          return '/loader';
        }
      }

      return null;
    },
  );
}
