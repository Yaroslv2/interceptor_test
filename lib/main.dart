import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interceptor_test/applicaton/bloc/user_bloc/user_bloc.dart';
import 'package:interceptor_test/applicaton/repository/api_repository.dart';
import 'package:interceptor_test/applicaton/repository/token_repository.dart';
import 'package:interceptor_test/applicaton/services/user_service.dart';
import 'package:interceptor_test/screens/sign_in_screen.dart';
import 'package:interceptor_test/screens/splash_screen.dart';
import 'package:interceptor_test/widgets/bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenRepository.init();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => TokenRepository(),
        ),
        RepositoryProvider(
          create: (context) => ApiRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserService(
            apiRepository: RepositoryProvider.of<ApiRepository>(context),
          ),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(
                userService: RepositoryProvider.of<UserService>(context),
                tokenRepository:
                    RepositoryProvider.of<TokenRepository>(context))..add(UserEvent.runApp()),
          ),
        ],
        child: App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: _navigatorKey,
      builder: (context, _) {
        return BlocListener<UserBloc, UserState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case UserStatus.logged:
                _navigatorKey.currentState!
                    .pushAndRemoveUntil(BottomBar.route(), (route) => false);
                break;
              case UserStatus.notLogged:
                _navigatorKey.currentState!
                    .pushAndRemoveUntil(SignInScreen.route(), (route) => false);
                break;
              default:
                break;
            }
          },
          child: _,
        );
      },
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (_) => SplashScreen.route(),
    );
  }
}
