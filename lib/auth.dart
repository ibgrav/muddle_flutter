// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import './glob.dart' as glob;

// class SignInPage extends StatefulWidget {
//   SignInPage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _SignInPageState createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController =
//       TextEditingController(text: glob.loginEmail);
//   final TextEditingController _passwordController =
//       TextEditingController(text: glob.loginPass);

//   bool _isLoading = false;
//   bool _login = false;

//   var _error;

//   @override
//   Widget build(BuildContext context) {
//     final emailField = TextFormField(
//       controller: _emailController,
//       obscureText: false,
//       style: style,
//       decoration: InputDecoration(
//           contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//           hintText: "Email",
//           border:
//               OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Please enter some text';
//         }
//       },
//     );
//     final passwordField = TextFormField(
//       controller: _passwordController,
//       obscureText: true,
//       style: style,
//       decoration: InputDecoration(
//           contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//           hintText: "Password",
//           border:
//               OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
//       validator: (String value) {
//         if (value.isEmpty) {
//           return 'Please enter some text';
//         }
//       },
//     );
//     final loginButton = Material(
//       elevation: 3.0,
//       borderRadius: BorderRadius.circular(30.0),
//       color: Color(0xff01A0C7),
//       child: MaterialButton(
//         minWidth: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//         onPressed: () async {
//           if (_formKey.currentState.validate()) {
//             setState(() {
//               _isLoading = true;
//             });

//             await _signInWithEmailAndPassword();

//             print("_login");
//             print(_login);

//             setState(() {
//               _isLoading = false;
//             });
//           }
//         },
//         child: Text("Login",
//             textAlign: TextAlign.center,
//             style: style.copyWith(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     );
//     final createAccountButton = Material(
//       elevation: 3.0,
//       borderRadius: BorderRadius.circular(30.0),
//       color: Colors.deepOrange,
//       child: MaterialButton(
//         minWidth: MediaQuery.of(context).size.width,
//         padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//         onPressed: () async {
//           if (_formKey.currentState.validate()) {
//             setState(() {
//               _isLoading = true;
//             });

//             await _register();

//             print("_login");
//             print(_login);

//             setState(() {
//               _isLoading = false;
//             });
//           }
//         },
//         child: Text("Create Account",
//             textAlign: TextAlign.center,
//             style: style.copyWith(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     );

//     final credentialsForm = Form(
//       key: _formKey,
//       child: Center(
//         child: Container(
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(36.0),
//             child: ListView(shrinkWrap: true, children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   SizedBox(
//                     height: 100.0,
//                     child: Image.asset(
//                       "assets/images/logo.png",
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(height: 45.0),
//                   emailField,
//                   SizedBox(height: 25.0),
//                   passwordField,
//                   SizedBox(
//                     height: 45.0,
//                   ),
//                   loginButton,
//                   SizedBox(
//                     height: 25.0,
//                   ),
//                   createAccountButton,
//                   SizedBox(
//                     height: 25.0,
//                   ),
//                 ],
//               ),
//             ]),
//           ),
//         ),
//       ),
//     );

//     Widget _isLoadingWidget() {
//       if (_isLoading) {
//         return (Center(child: CircularProgressIndicator()));
//       }
//       return (credentialsForm);
//     }

//     return Scaffold(
//         body: Stack(
//       children: <Widget>[_isLoadingWidget()],
//     ));
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future _signInWithEmailAndPassword() async {
//     final FirebaseUser user = await glob.auth
//         .signInWithEmailAndPassword(
//       email: _emailController.text,
//       password: _passwordController.text,
//     )
//         .catchError((error) {
//       print(error);
//       setState(() {
//         _error = error;
//       });
//     });

//     if (user != null) {
//       print(user);
//       if (!user.isEmailVerified) user.sendEmailVerification();

//       await glob.saveCredentials(
//           _emailController.text, _passwordController.text);

//       setState(() {
//         _login = true;
//       });
//     } else {
//       setState(() {
//         _login = false;
//       });
//     }
//   }

//   Future _register() async {
//     final FirebaseUser user = await glob.auth
//         .createUserWithEmailAndPassword(
//       email: _emailController.text,
//       password: _passwordController.text,
//     )
//         .catchError((error) {
//       print(error);
//       setState(() {
//         _error = error;
//       });
//     });

//     if (user != null) {
//       print(user);

//       await glob.saveCredentials(
//           _emailController.text, _passwordController.text);

//       setState(() {
//         _login = true;
//       });
//     } else {
//       setState(() {
//         _login = false;
//       });
//     }
//   }

//   Future<void> loginAlert(message) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: true, // user does not have to tap button
//       builder: (BuildContext context) {
//         return AlertDialog(
//           // title: Text('Message'),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(message),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('thx'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
