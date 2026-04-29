import 'package:flutter/material.dart';
import 'package:hellohive/feature/settings/domain/entities/user_profile_entities.dart';

class SettingProfileDisplay extends StatelessWidget {
  final UserProfileEntities profile;
  const SettingProfileDisplay({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Profile', style: _textTheme.titleSmall),
          SizedBox(height: 20),
          Text('Name', style: _textTheme.labelLarge),
          Text('${profile.firstName} ${profile.lastName}', style: _textTheme.bodyMedium),
          Divider(
            color: Color(0xFF929292).withAlpha(50),
            thickness: 1,
          ),
          SizedBox(height: 5),
          Text('Username', style: _textTheme.labelLarge),
          Text(profile.username, style: _textTheme.bodyMedium),
          Divider(
            color: Color(0xFF929292).withAlpha(50),
            thickness: 1,
          ),
          SizedBox(height: 5),
          Text('phone number', style: _textTheme.labelLarge),
          Text(profile.phone, style: _textTheme.bodyMedium),
          Divider(
            color: Color(0xFF929292).withAlpha(50),
            thickness: 1,
          ),
          SizedBox(height: 5),
          Text('About', style: _textTheme.labelLarge),
          Text(profile.description, style: _textTheme.bodyMedium),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}