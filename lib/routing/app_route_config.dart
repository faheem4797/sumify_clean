import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/common/widgets/loader.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/forgot_password_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/sign_in_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/splash_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/sign_up_screen.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';

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
                  path: '/loggedin',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                        child: Scaffold(
                      body: Column(
                        children: [
                          const Center(
                            child: Text('Logged In'),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                  context.read<AppUserCubit>().updateUser(null);
                                  context
                                      .goNamed(AppRouteConstants.signinRoute);
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Text('Logout'))
                        ],
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

class InitialWidget extends StatefulWidget {
  const InitialWidget({
    super.key,
  });

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  StreamSubscription<AuthState>? _subscription;

  void _triggerEvent() {
    _subscription = context.read<AuthBloc>().stream.listen((state) {
      if (state is AuthSuccess) {
        context.read<AppUserCubit>().updateUser(state.user);

        _subscription?.cancel();
      } else if (state is AuthFailure) {
        context.read<AppUserCubit>().updateUser(null);

        _subscription?.cancel();
      }

      final appUserState = context.read<AppUserCubit>().state;
      if (appUserState is AppUserInitial) {
        context.goNamed(AppRouteConstants.splashRoute);
      } else if (appUserState is AppUserLoggedIn) {
        context.goNamed(AppRouteConstants.homeRoute);
      }
    });

    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  void initState() {
    super.initState();
    _triggerEvent();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Loader(),
      ),
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  // #docregion configuration-custom-shell
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The StatefulNavigationShell from the associated StatefulShellRoute is
      // directly passed as the body of the Scaffold.
      body: navigationShell,
      bottomNavigationBar: SizedBox(
        height: 90.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.r)),
            boxShadow: [
              BoxShadow(
                  color: AppPallete.kShadowColor,
                  spreadRadius: 5.r,
                  blurRadius: 10.r),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.r),
              topRight: Radius.circular(50.r),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: AppPallete.klightTealColor,
              selectedItemColor: AppPallete.kWhiteColor,
              // Here, the items of BottomNavigationBar are hard coded. In a real
              // world scenario, the items would most likely be generated from the
              // branches of the shell route, which can be fetched using
              // `navigationShell.route.branches`.
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.question_answer), label: 'Comments'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.article), label: 'Report'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_page), label: 'Contact Us'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
              currentIndex: navigationShell.currentIndex,
              // Navigate to the current location of the branch at the provided index
              // when tapping an item in the BottomNavigationBar.
              onTap: (int index) => navigationShell.goBranch(index),
            ),
          ),
        ),
      ),
    );
  }
  // #enddocregion configuration-custom-shell

  /// NOTE: For a slightly more sophisticated branch switching, change the onTap
  /// handler on the BottomNavigationBar above to the following:
  /// `onTap: (int index) => _onTap(context, index),`
  // ignore: unused_element
  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
