import 'package:equatable/equatable.dart';
import 'package:playschool/src/authentication/cubit/userCubit.dart';
import 'package:playschool/src/authentication/model/User.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:playschool/src/authentication/repository/AuthRepository.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  final AuthRepository authRepository;
  final UserCubit userCubit;

  AuthCubit({
    required this.authRepository,
    required this.userCubit,
  }) : super(const AuthState()) {
    _tryAutoLogin();
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    try {
      final token = await authRepository.login(email, password);
      final user = await authRepository.fetchUserInfo(token);

      emit(state.copyWith(
        authStatus: AuthStatus.complete,
        token: token,
      ));
      userCubit.setUser(user);
    } catch (e) {
      emit(state.copyWith(authStatus: AuthStatus.error));
    }
  }

  void logout() {
    emit(const AuthState()); // 초기화
  }

  void _tryAutoLogin() async {
    if(state.token != null) {
      emit(state.copyWith(authStatus: AuthStatus.loading));

      await authRepository.fetchUserInfo(state.token!).then((user) {
        emit(state.copyWith(
          authStatus: AuthStatus.complete,
        ));
        userCubit.setUser(user);
      }).catchError((_) {
        emit(state.copyWith(authStatus: AuthStatus.error));
      });
    }
  }

  @override
  AuthState fromJson(Map<String, dynamic> json) {
    return AuthState(
      token: json['token'] as String?,
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {
      'token': state.token,
    };
  }
}

enum AuthStatus {
  init,
  loading,
  complete,
  error
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final String? token;

  const AuthState ({
    this.authStatus = AuthStatus.init,
    this.token,
  });

  AuthState copyWith ({
    AuthStatus? authStatus,
    String? token,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      token: token ?? this.token,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [authStatus, token];
}