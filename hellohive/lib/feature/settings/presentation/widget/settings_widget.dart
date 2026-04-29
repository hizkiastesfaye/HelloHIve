import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  Widget _divider() {
    return Divider(color: Color(0xFF929292).withAlpha(50), thickness: 1);
  }

  ButtonStyle _syleText1() {
    return TextButton.styleFrom(
      alignment: Alignment.centerLeft,
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
    
  }

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
          Text('Settings', style: _textTheme.titleSmall),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/userProfile');
              },
              icon: const Icon(
                Icons.account_circle_outlined,
                color: Color(0xFF929292),
                size: 20,
              ),
              label: Text('Account', style: _textTheme.bodyLarge),
              style: _syleText1(),
            ),
          ),
          _divider(),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text('Chats', style: _textTheme.bodyLarge),
              style: _syleText1(),
            ),
          ),
          _divider(),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.security_outlined,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text(
                'Privacy and Security',
                style: _textTheme.bodyLarge,
              ),
              style: _syleText1(),
            ),
          ),
          _divider(),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.account_circle_outlined,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text(
                'Appearance',
                style: _textTheme.bodyLarge,
              ),
              style: _syleText1(),
            ),
          ),
          _divider(),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.notification_important_outlined,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text(
                'Notifications',
                style: _textTheme.bodyLarge,
              ),
              style: _syleText1(),
            ),
          ),
          _divider(),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.storage_outlined,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text(
                'Storage and Data',
                style: _textTheme.bodyLarge,
              ),
              style: _syleText1(),
            ),
          ),
          _divider(),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.language,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text(
                'Language',
                style: _textTheme.bodyLarge,
              ),
              style: _syleText1(),
            ),
          ),
          _divider(),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.help_outline,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text('Help', style: _textTheme.bodyLarge),
              style: _syleText1(),
            ),
          ),
          _divider(),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.inbox,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text(
                'Invite a Friend',
                style: _textTheme.bodyLarge,
              ),
              style: _syleText1(),
            ),
          ),
          _divider(),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.info_outline,
                color: Color(0xFF929292),
                size: 25,
              ),
              label: Text(
                'About App',
                style: _textTheme.bodyLarge,
              ),
              style: _syleText1(),
            ),
          ),
        ],
      ),
    );
  }
}