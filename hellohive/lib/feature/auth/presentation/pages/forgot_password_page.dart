import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellohive/feature/auth/presentation/bloc/bloc/auth_bloc.dart';

import '../../../../core/utils/validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgotPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  String paragraph =
      'Enter your email address, if the email you entered is correct, the reset link will be send.';
  void sendResetLink() {
    final email = _emailController.text.trim();
    setState(() {
      _errorMessage = '';
    });
    if(
      !Validators.isNotFieldEmpty(email) ||
      !Validators.isEmailValid(email)
    ){
      _errorMessage = "Invalid Email";
      return;
    }
    context.read<AuthBloc>().add(
      ForgotPasswordEvent( email: email)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if(state is AuthError){
                setState(() {
                  _errorMessage = state.message;
                });
              }
              if(state is ResetPasswordState){
                Navigator.pushNamed(context, '/signin');
              }
            },
            builder: (context, state) {
              if(state is AuthLoading){
                return Padding(
                  padding: const EdgeInsets.only(top:80),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *0.7,
                      child: Text(paragraph),
                    ),
                    
                    SizedBox(height: 50),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *0.7,
                      child: TextField(
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
                    ),
                    SizedBox(height: 10),
                    Text(_errorMessage),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: sendResetLink, 
                      child: Text('Send')),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
