import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserModel {
   final  int?  id ;
   final String? name;
   final String? phone;
  UserModel({
      this.id,
      this.name,
      this.phone,
});

}
class UserScreen extends StatelessWidget {

  List<UserModel> users =
  [
    UserModel(
        id: 1, name: 'Mahmoud', phone: '+57545313'
    ),
    UserModel(
        id: 2, name: 'zaki', phone: '+0524453'
    ),
    UserModel(
        id: 3, name: 'hedia', phone: '+543321868'
    ),
    UserModel(
        id: 4, name: 'ahmed', phone: '+5464564587'
    ),
    UserModel(
        id: 5, name: 'abdelrahman', phone: '+5456546'
    ),
    UserModel(
        id: 6, name: 'hashem', phone: '+54545\7'
    ),
    UserModel(
        id: 7, name: 'felix', phone: '+2815615'
    ),
    UserModel(
        id: 8, name: 'ashraf', phone: '+201117843643'
    ),
    UserModel(
        id: 9, name: 'hossam', phone: '+2015448063643'
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users",
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context , index) => buildUserItem(users[index]),
          separatorBuilder: (context , index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20.0),
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          itemCount: users.length, ),
    );
  }
  Widget buildUserItem(UserModel userModel) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          child: Text(
            '${userModel.id}',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 20.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${userModel.name}',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${userModel.phone}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

          ],
        )

      ],
    ),
  );
}
