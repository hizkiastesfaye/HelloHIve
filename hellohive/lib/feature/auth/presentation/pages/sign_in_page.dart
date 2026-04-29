import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/core/utils/validators.dart';
import 'package:hellohive/feature/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:hellohive/feature/settings/presentation/bloc/user_profile_bloc_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  void _SignInButtonPressed() {
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();
    setState((){
      _errorMessage = '';
    });
    if(
      !Validators.isNotFieldEmpty(email) ||
      !Validators.isEmailValid(email) ||
      !Validators.isPasswordValid(password)
    ){
      _errorMessage = "Invalid Email or Password";
      return;
    }
    context.read<AuthBloc>().add(
      SignInEvent(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
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
              print('----------ooohhhh errrrr:${state.message}-------------================');

                _errorMessage = state.message;
              });
            }
            else if(state is AuthSignedInState){
              print('----------successful-------------================');
              print('${state.authEntities.email}, ${state.authEntities.id}');
              
              if(!state.authEntities.isEmailVerified){
                Navigator.pushNamed(
                  context, 
                  '/verify',
                  arguments: state.authEntities.email,
                  );
              }
              else {
                print('---------sign in is successful-------------================');
                context.read<UserProfileBlocBloc>().add(GetUserProfileEvent(state.authEntities.id));
                Navigator.pushNamed(context, '/');
              }
            }
          },
          builder: (context, state) {
            if(state is AuthLoading){
              print('----------Loading-------------================');
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Text(
                        'Hello Hive',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'Welcome back, Sign In',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 60),
                      TextField(
                        controller: _emailController,
                        cursorColor: Theme.of(context).secondaryHeaderColor,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          labelText: 'Email',
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        cursorColor: Theme.of(context).secondaryHeaderColor,
                        decoration: InputDecoration(
                          labelText: 'password',
                          floatingLabelStyle: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _errorMessage,
                        style:Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: ()=>Navigator.pushNamed(context, '/resetPassword'), 
                        child: Text("Forget password?")),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 2,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: ()=>Navigator.pushNamed(context,'/signup'), 
                            child: Text('Sign Up')),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).secondaryHeaderColor,
                          ),
                          onPressed: _SignInButtonPressed,
                          child: Text(
                            'Sign In',
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
