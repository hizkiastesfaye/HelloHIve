import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_profile_bloc_bloc.dart';
import '../widget/widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  __SettingsPageStateState createState() => __SettingsPageStateState();
}

class __SettingsPageStateState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
        builder: (context, state) {
          if(state is UserProfileLoading){
            return Center(child: CircularProgressIndicator());
          }
          else if(state is UserProfileGetError){
            return Text('Error: ${state.message}', style: _textTheme.bodyMedium);
          }
          else if(state is UserProfileLoaded){
            final profile = state.userProfiles;
            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: ColoredBox(
                  color: Colors.grey[100]!,
                  child: Column(
                    children: [
                      SizedBox(height: 50),

                      ProfilePhotoDisplayWidget(photoUrl: profile.photoUrl),
                      SizedBox(height: 10),

                      SettingProfileDisplay(profile: profile),
                      SizedBox(height: 20),

                      SettingsWidget(),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          }else{
            return Text('Error occured.', style: _textTheme.bodyMedium);

          }
        },
      ),
    );
  }
}
