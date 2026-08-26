import 'package:flutter/material.dart';
import 'package:hellohive/feature/settings/domain/entities/user_profile_entities.dart';

class FriendPhotoDisplayWidget extends StatelessWidget {
  final String photoUrl;
  final double? size;
  const FriendPhotoDisplayWidget({super.key, required this.photoUrl, this.size });

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    print('-----------------------FriendPhotoDisplayWidget--------------------');
    print('Profile Photo URL: $photoUrl');
    print('-----------------------FriendPhotoDisplayWidget--------------------');


    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent.withValues(
              alpha: 0.1,
            ),
            insetPadding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => {Navigator.of(context).pop()},
              child: Image.asset(
                photoUrl,
                // 'assets/images/allstar.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      child: ClipOval(
        child: Image.asset(
          // 'assets/images/allstar.jpg',
          photoUrl,
          height: size ?? 50,
          width: size ?? 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}