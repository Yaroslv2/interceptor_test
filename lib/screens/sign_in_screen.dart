import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interceptor_test/applicaton/bloc/auth_page_bloc/auth_page_bloc.dart';
import 'package:interceptor_test/applicaton/bloc/user_bloc/user_bloc.dart';
import 'package:interceptor_test/applicaton/repository/api_repository.dart';
import 'package:interceptor_test/applicaton/repository/token_repository.dart';
import 'package:interceptor_test/applicaton/services/auth_service.dart';
import 'package:interceptor_test/model/auth_form_model.dart';
import 'package:interceptor_test/model/status.dart';
import 'package:interceptor_test/widgets/loading_indicator_dialog.dart';
import 'package:interceptor_test/widgets/text_input_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthService(
        apiRepository: RepositoryProvider.of<ApiRepository>(context),
        tokenRepository: RepositoryProvider.of<TokenRepository>(context),
      ),
      child: BlocProvider(
        create: (context) => AuthPageBloc(
          authService: RepositoryProvider.of<AuthService>(context),
        ),
        child: BlocListener<AuthPageBloc, AuthPageState>(
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          listener: (context, state) {
            if (state.status != Status.loading) {
              LoadingIndicatorDialog.dismiss();
            }
            switch (state.status) {
              case Status.success:
                BlocProvider.of<UserBloc>(context).add(UserEvent.logged());
                break;
              case Status.failure:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ??
                        "Непредвиденная ошибка... (стандартный вывод ScaffoldMessenger)"),
                  ),
                );
                break;
              case Status.loading:
                LoadingIndicatorDialog.show(context);
                break;
              default:
                break;
            }
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SignInForm(),
                  TextButton(
                    onPressed: () {},
                    child: Text("Forgot password"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New to VEEEKTOR?"),
                      TextButton(
                        onPressed: () {},
                        child: Text("Create account"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          Text("Sign in"),
          TextInputWidget(
            controller: _emailController,
            label: "email",
            obscureText: false,
          ),
          Padding(padding: EdgeInsets.only(top: 5)),
          TextInputWidget(
            controller: _passwordController,
            label: "Password",
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthPageBloc>(context).add(
                AuthPageEvent.signIn(
                  form: SignInFormModel(
                      email: _emailController.text,
                      password: _passwordController.text),
                ),
              );
            },
            child: Text("Sign In"),
          ),
        ],
      ),
    );
  }
}
