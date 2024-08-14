import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/common/widgets/loader.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';

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
        context.goNamed(AppRouteConstants.splashRouteName);
      } else if (appUserState is AppUserLoggedIn) {
        context.goNamed(AppRouteConstants.homeRouteName);
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
