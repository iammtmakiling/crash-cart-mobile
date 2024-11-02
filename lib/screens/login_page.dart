// import 'package:dashboard/api_requests/login.dart';
// import 'package:dashboard/screens/home_page.dart';
// import 'package:dashboard/widgets/passwordField.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../globals.dart' as globals;

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       supportedLocales: [
//         Locale('de'),
//         Locale('en'),
//         Locale('es'),
//         Locale('fr'),
//         Locale('it'),
//       ],
//       home: LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   LoginPageState createState() => LoginPageState();
// }

// class LoginPageState extends State<LoginPage> {
//   bool isAuthenticated = false;
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   Duration get loginTime => const Duration(milliseconds: 2250);
//   // String _macAddress = 'Unknown';
//   // final _getMacAddressPlugin = GetMacAddress();
//   String email = '';
//   String password = '';
//   late bool isDeviceExisting;
//   var usersList;
//   var usersListFb;

//   Future<String?> _authUser(String name, String password) {
//     print("AUTHENTICATING----------------------");
//     return Future.delayed(loginTime).then((_) async {
//       var loginResponse = await loginAuth(name, password, "");

//       if (loginResponse['accessToken'] == null) {
//         // something went wrong with authentication
//         print("ERROR----------------------");
//         print(loginResponse['message']);
//         return loginResponse['message'];
//       } else {}

//       // if code proceeds, user is authenticated
//       setState(() {
//         globals.bearerToken = loginResponse['accessToken'];
//         isDeviceExisting = loginResponse['checkDevice'];
//         email = name;
//         password = password;
//       });
//       return null;
//     });
//   }

//   Future<void> setGlobalValues(Map<String, dynamic> doc) async {
//     setState(() {
//       // globals.deviceUsed = _macAddress;

//       //Name of User
//       globals.firstName = doc["firstName"];
//       globals.lastName = doc["lastName"];
//       if (doc["middleName"] != null) {
//         globals.middleName = doc["middleName"];
//       }

//       if (doc["suffic"] != null) {
//         globals.suffix = doc["suffix"];
//       }

//       globals.name = doc["firstName"] + " " + doc["lastName"];
//       globals.username = doc["username"];
//       if (doc["patientID"] != null) {
//         globals.patientID = doc["patientID"];
//       }
//       globals.department = doc["role"];

//       globals.userID = doc["userID"];
//       globals.pin = doc["pin"];
//       globals.email = doc["email"];
//       globals.sex = doc["sex"];
//       globals.birthday = doc["birthday"];
//       globals.occupation = doc["occupation"];
//       globals.role = doc["role"];

//       globals.userFirebaseGenId = doc["documentID"];
//       globals.hospitalID = doc["hospitalID"];
//       globals.devices = doc["devices"];
//     });
//   }

//   Future<void> setGlobalExtraValues(Map<String, dynamic> doc) async {
//     setState(() {
//       globals.key = doc["key"];
//       globals.iv = doc["iv"];
//       globals.iat = doc["iat"];
//       globals.aud = doc["aud"];
//       globals.iss = doc["iss"];
//       globals.sub = doc["sub"];
//     });
//   }

//   Future<void> resetGlobalValues() async {
//     setState(() {
//       globals.deviceUsed = "";

//       //Name of User
//       globals.firstName = '';
//       globals.lastName = '';
//       globals.middleName = '';
//       globals.suffix = '';
//       globals.name = '';
//       globals.username = '';
//       globals.patientID = '';
//       globals.department = '';

//       globals.userID = '';
//       globals.pin = '';
//       globals.email = '';
//       globals.sex = '';
//       globals.birthday = '';
//       globals.occupation = '';
//       globals.role = '';

//       globals.userFirebaseGenId = '';
//       globals.hospitalID = '';
//       globals.devices = [];

//       globals.key = '';
//       globals.iv = '';
//       globals.iat = 0;
//       globals.aud = '';
//       globals.iss = '';
//       globals.sub = '';
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     resetGlobalValues();
//     // initPlatformState();
//   }

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return SafeArea(
//       child: Scaffold(
//         body: Form(
//           key: _formKey,
//           child: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Colors.cyan, Colors.indigo],
//               ),
//             ),
//             child: Center(
//                 child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 16.0),
//                 const Text(
//                   'Welcome to Crash Cart',
//                   style: TextStyle(
//                     fontSize: 28.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//                 Container(
//                   width: screenWidth * 0.8,
//                   height: null,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.5),
//                         spreadRadius: 5,
//                         blurRadius: 7,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(24.0),
//                   child: Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max, // Set mainAxisSize to max
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         SizedBox(
//                           width: screenWidth * 0.7,
//                           child: Column(
//                             children: [
//                               buildTextFormField(
//                                 label: 'Email',
//                                 // prefixIcon: Icons.person,
//                                 controller: emailController,
//                               ),
//                               const SizedBox(height: 8.0),
//                               PasswordFormField(
//                                 label: 'Password',
//                                 controller: passwordController,
//                                 formKey: _formKey,
//                               ),
//                               const SizedBox(height: 16.0),
//                               buildLogInButton(),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'A Trauma Registry Application',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             )),
//           ),
//         ),
//       ),
//     );
//   }

//   //Build Text Form Field
//   Widget buildTextFormField({
//     required String label,
//     required TextEditingController controller,
//   }) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.cyan),
//           ),
//           prefixIcon: const Icon(
//             Icons.person,
//             color: Colors.blue,
//           ),
//         ),
//         onSaved: (String? initialValue) {
//           _formKey.currentState?.save();
//         },
//         validator: (String? value) {
//           if (value == null || value.isEmpty) {
//             return 'Cannot be blank';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   //Build Log In Button
//   Widget buildLogInButton() {
//     return Container(
//       height: 60,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.cyan, Colors.indigo],
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//       child: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             )
//           : TextButton(
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   setState(
//                     () {
//                       _isLoading = true;
//                     },
//                   );
//                   _authUser(
//                     emailController.text,
//                     passwordController.text,
//                   ).then(
//                     (errorMessage) async {
//                       setState(
//                         () {
//                           _isLoading = false;
//                         },
//                       );
//                       if (errorMessage == null) {
//                         handleAuthSuccess();
//                         setState(() {
//                           emailController.text = "";
//                           passwordController.text = "";
//                         });
//                       } else {
//                         // ignore: use_build_context_synchronously
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(errorMessage),
//                             duration: const Duration(seconds: 3),
//                           ),
//                         );
//                       }
//                     },
//                   );
//                 }
//               },
//               child: const Text('Login'),
//             ),
//     );
//   }

// // Function to handle authentication success
//   void handleAuthSuccess() async {
//     await getUserAndNavigate();
//   }

// // Add device and navigate to home page
//   Future<void> addDeviceAndNavigate() async {
//     await addDeviceToUser(globals.bearerToken, "", email);
//     await getUserAndNavigate();
//   }

// // Retrieve user details, set global values, and navigate to home page
//   Future<void> getUserAndNavigate() async {
//     UserDetails userDetails = await getUserDetails(globals.bearerToken);
//     Map<String, dynamic> extraUserDetails =
//         getUserExtraDetails(globals.bearerToken);
//     await setGlobalExtraValues(extraUserDetails);
//     await setGlobalValues(userDetails.userDetails);
//     Get.to(const HomePage());
//   }
// }
