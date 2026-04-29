import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/user_profile_bloc_bloc.dart';
import '../widget/widget.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isEditingProfilePic = false;
  bool _isEditingFields = false;
  File? _profileImage;
  String _imagePath = 'assets/images/allstar.jpg';

  String _uId = '';
  String _originalFirstName = '';
  String _originalLastName = '';
  String _originalUsername = '';
  String _originalPhone = '';
  String _originalAbout = '';
  String _originalPhotoUrl = '';
  String _sucessMessage = 'successful';
  String _errorMessage = 'Failed, Please try again.';
  String _emptyFieldMessage = 'Please fill all the fields.';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();



  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        _imagePath = image.path;
      });
      print('___________________________+++++++++++++++++++++++');
      print(_imagePath);
      print('___________________________+++++++++++++++++++++++');
    }
  }



  @override
  void initState() {
    super.initState();
    // _revertToOriginalValues();
    _revertToOriginalPhoto();
    // _saveOriginalValues();
  }

  // void _saveOriginalValues() {
  //   _originalFirstName = _firstNameController.text;
  //   _originalLastName = _lastNameController.text;
  //   _originalUsername = _usernameController.text;
  //   _originalPhone = _phoneController.text;
  //   _originalAbout = _aboutController.text;
  // }

  void _revertToOriginalValues() {
    _firstNameController.text = _originalFirstName;
    _lastNameController.text = _originalLastName;
    _usernameController.text = _originalUsername;
    _phoneController.text = _originalPhone;
    _aboutController.text = _originalAbout;
  }

  void _revertToOriginalPhoto() {
    _imagePath = _originalPhotoUrl;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  bool _checkForChanges() {
    return _firstNameController.text != _originalFirstName ||
        _lastNameController.text != _originalLastName ||
        _usernameController.text != _originalUsername ||
        _phoneController.text != _originalPhone ||
        _aboutController.text != _originalAbout;

  }
  bool _isEmptyPhoto() {
    return _imagePath.isEmpty;
  }
  bool _isEmptyField() {
    return _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _aboutController.text.isEmpty;
  }

  void _onDonePhotoButton(){
    if(_isEmptyPhoto()){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          margin: EdgeInsets.only(
            bottom: 20,
            left:20,
            right:20
            ),
          content: Text('Please select a photo'),
        ),
      );
      return;
    }
    else if(_imagePath != _originalPhotoUrl){
      context.read<UserProfileBlocBloc>().add(UpdateSingleUserProfileEvent(
        uId: _uId,
        fieldName: 'photoUrl',
        value: _imagePath,
      ));
      setState(() {
        _isEditingProfilePic = false;
      });
    }
    else{
      setState(() {
        _isEditingProfilePic = false;
      });
    }
  }

  void _onDoneFieldButton(){
    if(_isEmptyField()){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          margin: EdgeInsets.only(
            bottom: 20,
            left:20,
            right:20
            ),
          content: Text(_emptyFieldMessage)),
      );
      return;
    }
    else if(_checkForChanges()){

      context.read<UserProfileBlocBloc>().add(UpdateUserProfileEvent(
        uId: _uId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        phone: _phoneController.text,
        description: _aboutController.text,
      ));
      setState(() {
        _isEditingFields = false;
      });
    }
    else{
      setState(() {
        _isEditingFields = false;
      });
    }
  }

  Widget _buildFieldRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns both text lines to the left
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(
            height: 4,
          ), // Adds a small gap between the label and the value
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildEditableFieldRow(
    String label,
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
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('User Profile')),
      body: BlocConsumer<UserProfileBlocBloc, UserProfileBlocState>(
        listener: (context, state) {
          if(state is UserProfileLoaded){
            _originalPhotoUrl = state.userProfiles.photoUrl;

            _revertToOriginalValues();
            _revertToOriginalPhoto();
          }
          if (state is UserProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.blue,
                margin: EdgeInsets.all(20),
                content: Text('Profile updated successfully',),
              ),
            );
            context.read<UserProfileBlocBloc>().add(GetUserProfileEvent(_uId));
          }
          else if(state is UserProfileSingleUpdateError){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          else if(state is UserProfileUpdateError){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if(state is UserProfileLoading){
            return Center(child: CircularProgressIndicator());
          }
          else if (state is UserProfileGetError){
            return Center(child: Text('Error: ${state.message}'));
          }
          else if(state is UserProfileLoaded){
            _uId = state.userProfiles.uId;
            _originalUsername = state.userProfiles.username;
            _originalFirstName = state.userProfiles.firstName;
            _originalLastName = state.userProfiles.lastName;
            _originalPhone = state.userProfiles.phone;
            _originalAbout = state.userProfiles.description;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Profile Picture Section
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // CircleAvatar(
                          //   radius: 60,
                          //   backgroundImage: _profileImage != null
                          //       ? FileImage(_profileImage!) as ImageProvider
                          //       : const AssetImage('assets/images/allstar.jpg'),
                          // ),
                          (_imagePath != null && _imagePath!.isNotEmpty) 
                            ? ProfilePhotoDisplayWidget(photoUrl: _imagePath!) 
                            : ProfilePhotoDisplayWidget(photoUrl: 'assets/images/allstar.jpg'),
                          if (_isEditingProfilePic)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 18,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  onPressed: _pickImage,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (!_isEditingProfilePic)
                        TextButton.icon(
                          onPressed: () {
                            _revertToOriginalPhoto();
                            setState(() {
                              _isEditingProfilePic = true;
                            });
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[50],
                                foregroundColor: Colors.red,
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.delete, size: 18),
                              label: const Text('Delete'),
                              onPressed: () {
                                setState(() {
                                  _profileImage = null;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[50],
                                foregroundColor: Colors.red,
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.cancel, size: 18),
                              label: const Text('Cancel'),
                              onPressed: () {
                                _revertToOriginalPhoto();
                                setState(() {
                                  _isEditingProfilePic = false;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[50],
                                foregroundColor: Colors.green,
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('Done'),
                              onPressed: () {
                                setState(() {
                                  _isEditingProfilePic = false;
                                });
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
                // Personal Information Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!_isEditingFields)
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              // _saveOriginalValues();
                              _revertToOriginalValues();
                              _isEditingFields = true;
                            });
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                        )
                      else
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _revertToOriginalValues();
                                  _isEditingFields = false;
                                });
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _onDoneFieldButton();
                                // setState(() {
                                //   _isEditingFields = false;
                                // });
                              },
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (_isEditingFields)
                  Column(
                    children: [
                      _buildEditableFieldRow('First Name', _firstNameController,),
                      _buildEditableFieldRow('Last Name', _lastNameController),
                      _buildEditableFieldRow('Username', _usernameController),
                      _buildEditableFieldRow('Phone', _phoneController),
                      _buildEditableFieldRow('About', _aboutController, maxLines: 3,),
                    ],
                  )
                else
                  SettingProfileDisplay(profile: state.userProfiles),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     _buildFieldRow('First Name', _firstNameController.text),
                  //     _buildFieldRow('Last Name', _lastNameController.text),
                  //     _buildFieldRow('Username', _usernameController.text),
                  //     _buildFieldRow('Phone', _phoneController.text),
                  //     _buildFieldRow('About', _aboutController.text),
                  //   ],
                  // ),
                const SizedBox(height: 32),
              ],
            ),
          );
          }
          else{
            return Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }
}
