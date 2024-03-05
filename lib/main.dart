import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_7/constants/routes.dart';
import 'package:flutter_application_7/views/login_view.dart';
import 'package:flutter_application_7/views/register_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const RegisterView(),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        
      },

    ); 
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ), 
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if(user!=null) {
                print(user);
                if (user.emailVerified) {
                  return const NotesView();
                } else {
                  return const NotesView();
                  //return const VerifyEmailView();
                }
              }else{
                return const LoginView();
              }
            
            default:
              return const Text("Loading...");
          }
        },
      )
    );
  }
}

 class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children:[
          const Text('Please verify your email'),
          TextButton(onPressed: (){
            final user = FirebaseAuth.instance.currentUser;
            user?.sendEmailVerification();
          },
           child: const Text('Resend Email')
           )
        ],
      );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout }
class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) {
            switch(value){
              case MenuAction.logout:
                signOutDialog(context).then((value){
                  if(value){
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                });
                break;
            }


          },itemBuilder: (context) {
             return [
              const PopupMenuItem<MenuAction>(
              child: Text("Log out"),
              value: MenuAction.logout,
              )

             ];
          },
          
          )
        ],
      ),
      body: const Center(
        child: Text('Notes'),
      ),
    );
  }
}

Future<bool> signOutDialog(BuildContext context) {
 return showDialog<bool>(context: context, 
  builder:(context){
    return AlertDialog(
      title: const Text('Log out'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context, false);
        }, child: const Text('Cancel')),
        TextButton(onPressed: (){
          Navigator.pop(context, true);
        }, child: const Text('Log out'))
      ],
    );
  }
  ).then((value) => value ?? false);
}
