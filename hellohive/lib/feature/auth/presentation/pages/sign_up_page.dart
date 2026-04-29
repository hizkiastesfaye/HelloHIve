import 'package:flutter/material.dart';
import 'package:hellohive/feature/settings/presentation/bloc/user_profile_bloc_bloc.dart';

import '../../../../core/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/feature/auth/presentation/bloc/bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _errorMessage = '';

  void _onSignUpPressed(BuildContext context) {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _errorMessage = '';
    });
    if (!Validators.passwordsMatch(
      password: password,
      confirmPassword: confirmPassword,
    )) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    context.read<AuthBloc>().add(
      SignUpEvent(
        email: _emailController.text.trim(),
        password: password.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is AuthError){
              setState(() {
                _errorMessage = state.message;
              });
            }
            if(state is AuthSignedUpState){
              print('________________sucess state----');
              context.read<UserProfileBlocBloc>().add(GetUserProfileEvent(state.authEntities.id));
              Navigator.pushNamed(
                context, '/verify',
                arguments: state.authEntities.email
              );
            }
          },
          builder: (context, state) {
            if(state is AuthLoading){
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 60),
                      Text(
                        'HelloHive ',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'Create an account, Sign Up here',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 60),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusColor: Colors.blue,
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusColor: Colors.blue,
                          labelText: 'Password',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusColor: Colors.blue,
                          labelText: 'Confirm Password',
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Already have an account?'),
                          SizedBox(width: 6),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                              // Navigator.pop(context);
                              Navigator.pushNamed(context, '/signin');
                            },
                            child: Text('Sign In'),
                          ),
                        ],
                      ),
                      Text(_errorMessage),
                      SizedBox(height: 10),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () => _onSignUpPressed(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).secondaryHeaderColor,
                          ),
                          child: Text(
                            'Sign Up',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
