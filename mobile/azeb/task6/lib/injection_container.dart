import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Auth imports
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Chat imports
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_chats_usecase.dart' as get_chats;
import 'features/chat/domain/usecases/send_message_usecase.dart'
    as send_message;
import 'features/chat/domain/usecases/receive_messages_usecase.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

// User imports
import 'features/chat/data/datasources/user_remote_datasource.dart';
import 'features/chat/data/repositories/user_repository_impl.dart';
import 'features/chat/domain/repositories/user_repository.dart';
import 'features/chat/domain/usecases/get_my_profile_usecase.dart';
import 'features/chat/domain/usecases/get_users_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      signUpUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  // User feature - Inject AuthLocalDataSource so UserRemoteDatasource fetches token dynamically
  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasource(client: sl(), authLocalDataSource: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => GetMyProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));

  // Chat feature - Inject AuthLocalDataSource so ChatRemoteDatasource fetches token dynamically
  const wsUrl = 'wss://g5-flutter-learning-path-be-tvum.onrender.com';

  sl.registerLazySingleton<ChatRemoteDatasource>(
    () => ChatRemoteDatasource(
      client: sl(),
      authLocalDataSource: sl(),
      wsUrl: wsUrl,
    ),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => get_chats.GetChatsUseCase(sl()));
  sl.registerLazySingleton(() => send_message.SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => ReceiveMessagesUseCase(sl()));

  sl.registerFactory(
    () => ChatBloc(
      getMyProfileUseCase: sl(),
      getUsersUseCase: sl(),
      getChatsUseCase: sl(),
      sendMessageUseCase: sl(),
      receiveMessagesUseCase: sl(),
    ),
  );
}
