import 'package:first_flutter_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginDesing extends StatefulWidget {
  @override
  _LoginDesingState createState() => _LoginDesingState();
}

class _LoginDesingState extends State<LoginDesing> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('Login Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications), onPressed: () {  },
          ),
          IconButton(
            icon: Icon(Icons.widgets), onPressed: () {  },
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center( //scroll view
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Login',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  defaultFormField(
                    type: TextInputType.emailAddress,
                    label: 'email address',
                    controller:emailController,
                    prefix: Icons.email,
                    validate: (value){
                      if( value.isEmpty){
                        return 'email address can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    suffixPressed: (){
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },

                  type: TextInputType.visiblePassword,
                  obscure: isPassword,
                    label: 'Password',
                    suffix: isPassword ? Icons.visibility:Icons.visibility_off,
                    controller:passwordController,
                    prefix: Icons.lock,
                    validate: (value){
                      if( value.isEmpty){
                        return 'password is too short';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultButton(
                    function: (){
                      if(formKey.currentState!.validate()){

                      }

                    },
                    text: 'Login',),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {  },
                        child: Text(
                            'Register Now'
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}
