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

  serviceLocator.registerLazySingleton(() => http.Client());

  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerLazySingleton(() => ImagePicker());
  serviceLocator.registerLazySingleton(() => PermissionsService());
  serviceLocator.registerLazySingleton(
      () => PermissionRequest(permissionsService: serviceLocator()));

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

  serviceLocator.registerLazySingleton(() => Random());

  await _initAuth();
  await _initArticle();
  await _initProfile();
  await _initContactUs();
}

Future<void> _initAuth() async {
  serviceLocator
    ..registerFactory<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(
        firebaseAuth: serviceLocator(), firebaseFirestore: serviceLocator()))
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
        ))
    ..registerLazySingleton(() => SignUpBloc())
    ..registerLazySingleton(() => SignInBloc())
    ..registerLazySingleton(() => ForgotPasswordBloc());
}

Future<void> _initArticle() async {
  serviceLocator
    ..registerFactory<ArticleRemoteDatasource>(
        () => ArticleRemoteDatasourceImpl())
    ..registerFactory<ArticleLocalDatasource>(
        () => ArticleLocalDatasourceImpl())
    ..registerFactory<ArticleRepository>(() => ArticleRepositoryImpl(
          connectionChecker: serviceLocator(),
          articleRemoteDatasource: serviceLocator(),
          articleLocalDatasource: serviceLocator(),
          permissionRequest: serviceLocator(),
          random: serviceLocator(),
        ))
    ..registerFactory(() => SaveAsPdf(articleRepository: serviceLocator()))
    ..registerFactory(() => SetArticle(articleRepository: serviceLocator()))
    ..registerLazySingleton(() =>
        ArticleBloc(setArticle: serviceLocator(), saveAsPdf: serviceLocator()));
}

Future<void> _initProfile() async {
  serviceLocator
    ..registerFactory<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(
              firebaseAuth: serviceLocator(),
              firebaseStorage: serviceLocator(),
              firebaseFirestore: serviceLocator(),
            ))
    ..registerFactory<ProfileRepository>(() => ProfileRepositpryImpl(
          connectionChecker: serviceLocator(),
          profileRemoteDataSource: serviceLocator(),
        ))
    ..registerFactory(
        () => ChangeProfilePicture(profileRepository: serviceLocator()))
    ..registerFactory(() => LogoutUser(profileRepository: serviceLocator()))
    ..registerFactory(() => DeleteAccount(profileRepository: serviceLocator()))
    ..registerLazySingleton(
        () => EditProfileImageBloc(changeProfilePicture: serviceLocator()))
    ..registerLazySingleton(() => LogoutBloc(logoutUser: serviceLocator()))
    ..registerLazySingleton(
        () => DeleteAccountBloc(deleteAccount: serviceLocator()));
}

Future<void> _initContactUs() async {
  serviceLocator
    ..registerFactory<ContactUsRemoteDatasource>(
        () => ContactUsRemoteDatasourceImpl(client: serviceLocator()))
    ..registerFactory<ContactUsRepository>(() => ContactUsRepositoryImpl(
          connectionChecker: serviceLocator(),
          contactUsRemoteDatasource: serviceLocator(),
        ))
    ..registerFactory(() => SendEmail(contactUsRepository: serviceLocator()))
    ..registerLazySingleton(() => ContactUsBloc(sendEmail: serviceLocator()));
}
