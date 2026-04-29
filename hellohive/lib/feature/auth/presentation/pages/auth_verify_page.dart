import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/auth_bloc.dart';

class AuthVerifyPage extends StatefulWidget {
  final String email;
  const AuthVerifyPage({Key? key, required this.email}) : super(key: key);

  @override
  _AuthVerifyState createState() => _AuthVerifyState();
}

class _AuthVerifyState extends State<AuthVerifyPage> {
  String _errorMessage = '';
  bool _sendClicked = false;

  void CheckEmailVerified() {
    setState(() {
      _errorMessage = '';
    });
    context.read<AuthBloc>().add(EmailVerifiedEvent());
  }

  void SendEmailLink() {
    setState(() {
      _errorMessage = '';
    });
    context.read<AuthBloc>().add(VerifyEmailEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              setState(() {
                _errorMessage = state.message;
              });
            }
            if (state is EmailVerifiedState) {
              print('----------------ssssss-------------------');
              Navigator.pushNamed(context, '/');
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        // SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => Navigator.pushNamed(context, '/signin'),
                            icon: Icon(Icons.close),
                          ),
                        ),
                        SizedBox(height: 60),
                        Text('${widget.email}'),
                        SizedBox(height: 5),
                        Text('You need to verify your email.'),
                        SizedBox(height: 30),
                        Text('If You have verified your email,'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('refresh the page or'),
                            TextButton(
                              onPressed: CheckEmailVerified,
                              child: Text('click here'),
                            ),
                          ],
                        ),
                        Text(_errorMessage),
                        if (!_sendClicked)
                          TextButton(
                            onPressed: SendEmailLink,
                            child: Text('Send Link'),
                          ),
                      ],
                    ),
                  ),
                  if (state is AuthLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
