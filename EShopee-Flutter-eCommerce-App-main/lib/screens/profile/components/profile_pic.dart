import 'package:flutter/material.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          FutureBuilder(
            future: UserDatabaseHelper().displayPictureForCurrentUser,
            builder: (context, snapshot) {
              return CircleAvatar(
                backgroundImage: snapshot.data != null ? NetworkImage(snapshot.data) : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
