import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/core/utils/request_permission.dart';
import 'package:sumify_clean/features/article/data/datasources/article_local_datasource.dart';
import 'package:sumify_clean/features/article/data/datasources/article_remote_datasource.dart';
import 'package:sumify_clean/features/article/data/repositories/article_repository_impl.dart';
import 'package:sumify_clean/features/article/domain/repositories/article_repository.dart';
import 'package:sumify_clean/features/article/domain/usecases/save_as_pdf.dart';
import 'package:sumify_clean/features/article/domain/usecases/set_article.dart';
import 'package:sumify_clean/features/article/presentation/blocs/article_bloc/article_bloc.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/current_user.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/forgot_password.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/login_user.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/signup_user.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:sumify_clean/features/contact_us/data/datasources/contact_us_remote_datasource.dart';
import 'package:sumify_clean/features/contact_us/data/repositories/contact_us_repository_impl.dart';
import 'package:sumify_clean/features/contact_us/domain/repositories/contact_us_repository.dart';
import 'package:sumify_clean/features/contact_us/domain/usecases/send_email.dart';
import 'package:sumify_clean/features/contact_us/presentation/blocs/contact_us_bloc/contact_us_bloc.dart';
import 'package:sumify_clean/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:sumify_clean/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';
import 'package:sumify_clean/features/profile/domain/usecases/change_profile_picture.dart';
import 'package:sumify_clean/features/profile/domain/usecases/delete_account.dart';
import 'package:sumify_clean/features/profile/domain/usecases/logout_user.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/delete_account_bloc/delete_account_bloc.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/edit_profile_image_bloc/edit_profile_image_bloc.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/logout_bloc/logout_bloc.dart';
import 'package:sumify_clean/firebase_options.dart';
import 'package:http/http.dart' as http;

part 'init_dependencies.main.dart';
