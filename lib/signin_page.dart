// // import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:google_sign_in/google_sign_in.dart';

// // import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// final FirebaseAuth _auth = FirebaseAuth.instance;
// // final GoogleSignIn _googleSignIn = GoogleSignIn();

// class SignInPage extends StatefulWidget {
//   final String title = 'Sign In';
//   @override
//   State<StatefulWidget> createState() => SignInPageState();
// }

// class SignInPageState extends State<SignInPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: <Widget>[
//           Builder(builder: (BuildContext context) {
//             return FlatButton(
//               child: const Text('Sign out'),
//               textColor: Theme.of(context).buttonColor,
//               onPressed: () async {
//                 final FirebaseUser user = await _auth.currentUser();
//                 if (user == null) {
//                   Scaffold.of(context).showSnackBar(
//                     SnackBar(
//                       content: const Text('No one has signed in.'),
//                     ),
//                   );
//                   return;
//                 }
//                 _signOut();
//                 final String uid = user.uid;
//                 Scaffold.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(uid + ' has successfully signed out.'),
//                   ),
//                 );
//               },
//             );
//           })
//         ],
//       ),
//       body: Builder(builder: (BuildContext context) {
//         return ListView(
//           scrollDirection: Axis.vertical,
//           children: <Widget>[
//             _EmailPasswordForm(),
//           ],
//         );
//       }),
//     );
//   }

//   // Example code for sign out.
//   void _signOut() async {
//     await _auth.signOut();
//   }
// }

// class _EmailPasswordForm extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _EmailPasswordFormState();
// }

// class _EmailPasswordFormState extends State<_EmailPasswordForm> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _success;
//   String _uid;
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             child: const Text('Test sign in with email and password'),
//             padding: const EdgeInsets.all(16),
//             alignment: Alignment.center,
//           ),
//           Container(
//             padding: EdgeInsets.all(40.0),
//             child: TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//               validator: (String value) {
//                 if (value.isEmpty) {
//                   return 'Please enter some text';
//                 }
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(40.0),
//             child: TextFormField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               validator: (String value) {
//                 if (value.isEmpty) {
//                   return 'Please enter some text';
//                 }
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             alignment: Alignment.center,
//             child: RaisedButton(
//               onPressed: () async {
//                 if (_formKey.currentState.validate()) {
//                   _signInWithEmailAndPassword();
//                 }
//               },
//               child: const Text('Submit'),
//             ),
//           ),
//           Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               _success == null
//                   ? ''
//                   : (_success
//                       ? 'Successfully signed in ' + _uid
//                       : 'Sign in failed'),
//               style: TextStyle(color: Colors.red),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Example code of how to sign in with email and password.
//   void _signInWithEmailAndPassword() async {
//     final FirebaseUser user = await _auth.signInWithEmailAndPassword(
//       email: _emailController.text,
//       password: _passwordController.text,
//     );
//     if (user != null) {
//       setState(() {
//         _success = true;
//         _uid = user.uid;

//         //getUserData(user);
//         //getIngredients();
//       });
//     } else {
//       _success = false;
//     }
//   }
// }

// // Future getIngredients() async {
// //   var ings = Firestore.instance.collection("ingredients").document("all");

// //   ings.snapshots()
// //     .listen((data) =>
// //         print(data));
// // }

// Future getUserData(user) async {
//   String token = await user.getIdToken();

//   var sendData = {'token': token};

//   var jsonText = jsonEncode(sendData);

//   print(jsonText);

//   var url =
//       'https://udlw5f5fzf.execute-api.us-east-1.amazonaws.com/dev/user/get';
//   var response = await http.post(url, body: jsonText);

//   print('Response status: ${response.statusCode}');

//   List allCats = [];
//   List allTypes = [];
//   // List allYears = [];

//   var body = jsonDecode(response.body);
//   assert(body is Map);

//   // body['message']['dataset'].forEach((k,v) => print('${k}: ${v}'));
//   body['message']['dataset'].forEach((category, types) {
//     allCats.add(category);

//     types.forEach((type, years) {
//       allTypes.add(type);

//       years.forEach((year, months) {
//         months.forEach((month, data) {
//           // print(data);
//         });
//       });
//     });
//   });

//   return(allCats);
//   // print(allTypes);
//   // print(allYears);
// }
