import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/current_user.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/forgot_password.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/login_user.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/signup_user.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:sumify_clean/firebase_options.dart';

part 'init_dependencies.main.dart';
