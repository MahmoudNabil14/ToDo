import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_flutter_app/layout/home_layout/cubit/app_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color color = Colors.blue,
  required String text ,
  bool isUpperCase = true,
  required Function function,
})=> Container(
  color:color,
  width: width,
  child:   MaterialButton(onPressed: (){
    return function();
  },
    child: Text(isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(
       color: Colors.white,
  ),
  ),
  ),
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  required String label,
  required IconData prefix ,
  IconData? suffix ,
  Function? suffixPressed,
  Function? onTap,
  bool obscure = false,
  bool isClickable = true,

}) => TextFormField(
controller: controller,
keyboardType: type,
obscureText: obscure,
enabled: isClickable,
onTap: (){
  return onTap!();
},
decoration: InputDecoration(
prefixIcon: Icon(
prefix,
),
labelText: label,
suffixIcon: suffix!=null ? IconButton(icon: Icon(suffix), onPressed: (){suffixPressed!();} ): null,
border: OutlineInputBorder(),
),
validator: (s){
   return validate(s);
},
);

Widget buildTaskItem(Map model,context)=>
    GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title:  Text("${model['title']} 's Description"),
                content: Text('${model['description']}'),
              );
            });
      },
    child: Dismissible(
      background: Container(
        decoration: BoxDecoration(
            color: Colors.red[400],
          borderRadius: BorderRadius.circular(10.0)
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.restore_from_trash_outlined),
      ),
      key: Key(model['id'].toString()),
      onDismissed: (direction){
        AppCubit.get(context).DeleteData(id: model['id']);
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you want to delete this task?"),
              actions: <Widget>[
                MaterialButton(
                    onPressed: ()=> Navigator.of(context).pop(true),
                    child: const Text("DELETE")
                ),
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:MainAxisSize.min,
                children: [
                  Text('${model['title']}',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.0,),
                  Text('${model['description']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 6.0,),
                  Text('${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20
            ),
            IconButton(
                onPressed: ()
                {
                  if(model['status'] == 'new'){
                    AppCubit.get(context).UpdateData(status: 'done', id: model['id']);
                  }
                  else if(model['status'] == 'archive'){
                    AppCubit.get(context).UpdateData(status: 'done', id: model['id']);
                  }
                  else{
                    AppCubit.get(context).UpdateData(status: 'new', id: model['id']);
                  }
                 },
                icon:  model['status']== 'done'?Icon(Icons.check_box,
                  color:  Colors.black45,):Icon(Icons.check_box_outline_blank,
                  color:  Colors.green[300],)),
            IconButton(
                onPressed: ()
                {
                  if(model['status'] == 'new'){
                    AppCubit.get(context).UpdateData(status: 'archive', id: model['id']);
                  }
                  else if(model['status'] == 'done'){
                    AppCubit.get(context).UpdateData(status: 'archive', id: model['id']);
                  }
                  else{
                    AppCubit.get(context).UpdateData(status: 'new', id: model['id']);
                  }

                }, icon:  model['status'] == 'archive' ?Icon(Icons.unarchive,
              color: Colors.black45,):Icon(Icons.archive,
              color: Colors.green[300],),
                ),
          ],
        ),
      ),
    ),
  );
Widget itemBuilder({
  required List<Map> tasks,
})=>ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context)=> ListView.separated(
      itemBuilder: (context, index) =>
          buildTaskItem(tasks[index],context),
      separatorBuilder: (context, index) =>
          Container(
            height: 1,
            color: Colors.grey[300],
            width: double.infinity,
          ),
      itemCount: tasks.length),
  fallback: (context)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No tasks Yet, Please add some tasks',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        )
      ],
    ),
  ),
);

