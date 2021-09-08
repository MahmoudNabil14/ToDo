import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
            Icons.menu
        ),
        title: Text(
            'First App'
        ),
        actions: [
          Icon(
              Icons.notifications
          ),
          Icon(
              Icons.search
          )
        ],
      ),
      body: Container(
        child: Column(
          children:
          [
               Padding(
                 padding: const EdgeInsets.all(50.0),
                 child: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(20.0),
                     ),
                   ),
                   clipBehavior: Clip.antiAliasWithSaveLayer,
                   child: Stack(
                     alignment: Alignment.bottomCenter,
                     children: [
                       Image(
                        height: 200.0,
                        width: 200.0,
                          image: NetworkImage('https://cdn.shopify.com/s/files/1/1463/4010/t/2/assets/masonry-feature-1-image.jpg?v=6292719477897739107'
                          ),
              ),
                       Container(
                         width: 200.0,
                         color: Colors.black.withOpacity(0.5),
                         padding: EdgeInsetsDirectional.only(top: 10,
                         bottom: 10,),
                         child: Text("flower",
                           style: TextStyle(

                             fontSize: 30.0,
                             color: Colors.white,
                           ),),
                       ),
                     ],
                   ),
                 ),
               ),


          ],
        ),
      ),
      );
  }
}