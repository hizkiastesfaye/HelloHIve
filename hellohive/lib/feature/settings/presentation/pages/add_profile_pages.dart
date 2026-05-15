import 'package:flutter/material.dart';
import 'package:hellohive/feature/settings/presentation/bloc/user_profile_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProfilePages extends StatefulWidget {
  AddProfilePages({super.key});

  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePages> {
  String _errorMessage = '';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  bool _isEmptyField() {
    return _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneController.text.isEmpty;
  }

  void _doneButtonPressed() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();
    String about = _aboutController.text;

    setState(() {
      _errorMessage = '';
    });
    if (_isEmptyField()) {
      _errorMessage = "Fields should not Empty.";
      return;
    }
    if (about.isEmpty || about == '') {
      about = 'Description';
    }
    context.read<UserProfileBlocBloc>().add(
      AddUserProfileEvent(
        uId: '',
        firstName: firstName,
        lastName: lastName,
        username: username,
        phone: phone,
        description: about,
        photoUrl: 'assets/images/allstar.jpg',
      ),
    );
  }

  Widget _buildEditableFieldRow(
    String label,
    bool isMandatory,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  isMandatory
                      ? Text('*', style: TextStyle(color: Colors.red))
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),

          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [SizedBox(width: 8), Text('Hello Hive')]),
      ),
      body: BlocConsumer<UserProfileBlocBloc, UserProfileBlocState>(
        listener: (context, state) {
          if(state is UserProfileAdded){
            Navigator.pushNamed(context, '/home');
          }
          else if(state is UserProfileAddError){
            _errorMessage = state.message;
          }
        },
        builder: (context, state) {
          if(state is UserProfileLoading){
            return CircularProgressIndicator();
          }

          return Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildEditableFieldRow('username', true, _usernameController),
                  _buildEditableFieldRow(
                    'First Name',
                    true,
                    _firstNameController,
                  ),
                  _buildEditableFieldRow(
                    'First Name',
                    true,
                    _firstNameController,
                  ),
                  _buildEditableFieldRow('Phone', true, _phoneController),
                  _buildEditableFieldRow(
                    'Description',
                    false,
                    _aboutController,
                  ),
                  SizedBox(height: 5,),
                  Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red),)),
                  SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).secondaryHeaderColor,
                        ),
                        onPressed: _doneButtonPressed,
                        child: Text(
                          'Done',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
