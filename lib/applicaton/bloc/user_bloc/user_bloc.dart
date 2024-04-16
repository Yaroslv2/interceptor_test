import 'package:bloc/bloc.dart';
import 'package:interceptor_test/applicaton/repository/token_repository.dart';
import 'package:interceptor_test/applicaton/services/user_service.dart';
import 'package:interceptor_test/model/user.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService;
  final TokenRepository _tokenRepository;

  UserBloc(
      {required UserService userService,
      required TokenRepository tokenRepository})
      : _userService = userService,
        _tokenRepository = tokenRepository,
        super(UserState.initial()) {
    on<_RunAppEvent>(_runApp);
    on<_UserLoggedEvent>(_userLogged);
    on<_UserLogoutEvent>(_userLogout);
    on<_UserDataChangedEvent>(_userDataChanged);
  }

  Future _runApp(_RunAppEvent event, Emitter<UserState> emit) async {
    String? token = _tokenRepository.getAccessToken();
    if (token == null) {
      emit(state.copyWith(user: null, status: UserStatus.notLogged));
      return;
    }
    User? user = await _userService.getUserData();
    emit(state.copyWith(
        user: user,
        status: user == null ? UserStatus.notLogged : UserStatus.logged));
  }

  Future _userLogged(_UserLoggedEvent event, Emitter<UserState> emit) async {
    User? user = await _userService.getUserData();
    emit(state.copyWith(
        user: user,
        status: user == null ? UserStatus.notLogged : UserStatus.logged));
  }

  Future _userLogout(_UserLogoutEvent event, Emitter<UserState> emit) async {}

  Future _userDataChanged(
      _UserDataChangedEvent event, Emitter<UserState> emit) async {}
}
