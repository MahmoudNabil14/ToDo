import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessengerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 20.0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage("https://scontent.fcai19-1.fna.fbcdn.net/v/t1.6435-9/195590606_3025788357652523_7163091295717838230_n.jpg?_nc_cat=108&ccb=1-3&_nc_sid=09cbfe&_nc_eui2=AeH5b4Y0_PQUMW8X_DrdNX7F7WR-pz8EB_ztZH6nPwQH_PifJUJ4Uf5tkcfeqcy7Orb0YxE-RMWTnOovFZ5HSXXH&_nc_ohc=ynmgNUA68UsAX8TsIPN&_nc_ht=scontent.fcai19-1.fna&oh=0d93d1718cc9ca7625678027f6f37ead&oe=60F560C1"),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              "Chats",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            )
          ],
        ),//title
        actions: [
          IconButton(onPressed: (){},
              icon: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 15.0,
              child: Icon(
              Icons.camera_alt ,
              size: 18.0,
              color: Colors.white,
            ),
          )
          ),
          IconButton(onPressed: (){},
              icon: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 15.0,
                child: Icon(
                  Icons.edit ,
                  size: 18.0,
                  color: Colors.white,
                ),
              )
          ),
        ],
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadiusDirectional.circular(7.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                          Icons.search
                      ),
                      SizedBox(
                          width: 15.0
                      ),
                      Text("search")


                    ],
                  ),
                ),
              ), //search
              SizedBox(
                  height: 20.0),
              Container(
                height: 100.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index) => buildStoryItem(),
                    itemCount:19,
                  separatorBuilder: ( context,  index) => SizedBox(width:15.0),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                  itemBuilder: (context,index) => buildChatItem() ,
                  separatorBuilder: (context,index) => SizedBox(height: 20.0,),
                  itemCount: 20,
              ),
          ],
          ),
        ),
      ),
    );
  }
  Widget buildChatItem() => Row(
    children: [
      Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage("https://scontent.fcai19-1.fna.fbcdn.net/v/t1.6435-9/195590606_3025788357652523_7163091295717838230_n.jpg?_nc_cat=108&ccb=1-3&_nc_sid=09cbfe&_nc_eui2=AeH5b4Y0_PQUMW8X_DrdNX7F7WR-pz8EB_ztZH6nPwQH_PifJUJ4Uf5tkcfeqcy7Orb0YxE-RMWTnOovFZ5HSXXH&_nc_ohc=ynmgNUA68UsAX8TsIPN&_nc_ht=scontent.fcai19-1.fna&oh=0d93d1718cc9ca7625678027f6f37ead&oe=60F560C1"),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
                end: 3.0,bottom: 3.0)
            ,
            child: CircleAvatar(
              radius: 8.0,
              backgroundColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 3.0,bottom: 3.0),
            child: CircleAvatar(
              radius: 7.0,
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
      SizedBox(
          width:15.0
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mahmoud Nabil",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Hello, my name's mahmoud how are you doing",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 7.0,
                  ),
                ),
                SizedBox(
                  width: 3.0,
                ),
                Text(
                    "02.00 pm"
                )
              ],
            ),

          ],
        ),
      ),

    ],
  );
  Widget buildStoryItem() => Container(
    width: 60.0,
    child: Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage("https://scontent.fcai19-1.fna.fbcdn.net/v/t1.6435-9/195590606_3025788357652523_7163091295717838230_n.jpg?_nc_cat=108&ccb=1-3&_nc_sid=09cbfe&_nc_eui2=AeH5b4Y0_PQUMW8X_DrdNX7F7WR-pz8EB_ztZH6nPwQH_PifJUJ4Uf5tkcfeqcy7Orb0YxE-RMWTnOovFZ5HSXXH&_nc_ohc=ynmgNUA68UsAX8TsIPN&_nc_ht=scontent.fcai19-1.fna&oh=0d93d1718cc9ca7625678027f6f37ead&oe=60F560C1"),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  end: 3.0,bottom: 3.0)
              ,
              child: CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 3.0,bottom: 3.0),
              child: CircleAvatar(
                radius: 7.0,
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(
            height:6.0
        ),
        Text(
          "Mahmoud Nabil",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ),
  );
}
