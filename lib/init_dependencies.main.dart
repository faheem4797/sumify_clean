part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  serviceLocator.registerLazySingleton(() => firebase);
  serviceLocator
      .registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  serviceLocator.registerLazySingleton(() => FirebaseStorage.instance);

  serviceLocator.registerFactory(() => InternetConnection());
  //core
  // serviceLocator
  //   ..registerFactory<SignoutRemoteDataSource>(
  //       () => SignoutRemoteDataSourceImpl(firebaseAuth: serviceLocator()))
  //   ..registerFactory<SignoutRepository>(
  //       () => SignoutRepositoryImpl(serviceLocator(), serviceLocator()))
  //   ..registerFactory(() => UserSignout(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));

  await _initAuth();
}

Future<void> _initAuth() async {
  serviceLocator
    ..registerFactory<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(firebaseAuth: serviceLocator()))
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        connectionChecker: serviceLocator(),
        authRemoteDatasource: serviceLocator()))
    ..registerFactory(() => SignupUser(authRepository: serviceLocator()))
    ..registerFactory(() => LoginUser(authRepository: serviceLocator()))
    ..registerFactory(() => ForgotPassword(authRepository: serviceLocator()))
    ..registerFactory(() => CurrentUser(authRepository: serviceLocator()))
    ..registerLazySingleton(() => AuthBloc(
          signupUser: serviceLocator(),
          loginUser: serviceLocator(),
          forgotPassword: serviceLocator(),
          currentUser: serviceLocator(),
        ));
}
