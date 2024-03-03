

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_7/firebase_options.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}
class _LoginViewState extends State<LoginView> {
  // This widget is the home page of your application. It is stateful, meaning
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context){
   return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title:const Text('Login'),
        ),
        body: FutureBuilder(

            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
             
            ),
          builder: (context,snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                  return Column(
              children: [
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
                TextField(
                  controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    
                  ),
                ),
                Center(
                  child: TextButton(
                   onPressed: () async{
                      final email = _email.text;
                      final password = _password.text;
                      try{
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                      } on FirebaseAuthException catch (e){
                        if(e.code == 'user-not-found'){
                          print('No user found for that email');
                        } else if (e.code == 'wrong-password'){
                          print('Wrong password provided for that user');
                        }
                      }

                      
                   },
                   child :const Text('Login'),
                ),
                
                ),
              ],
            );
        
              default:
                return const  Text('Loading...') ;
            }
              }
        ) 

    );
  }
}

