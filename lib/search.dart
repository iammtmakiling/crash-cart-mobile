// import 'package:dashboard/api_requests/getPatient.dart';
// import 'package:dashboard/edit.dart';
// // import 'package:dashboard/firestoreDb/firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'globals.dart' as globals;

// class SearchBase extends StatelessWidget {
//   const SearchBase({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         backgroundColor: Colors.grey[300]
//       ),
//       home: const SearchFilters(),
//     );
//   }
// }

// class SearchFilters extends StatefulWidget {
//   const SearchFilters({ Key? key }) : super(key: key);

//   @override
//   _SearchFiltersState createState() => _SearchFiltersState();
// }

// class _SearchFiltersState extends State<SearchFilters> {
//   var _searchQueryResults;
//   TextEditingController searchController = TextEditingController();
//   String dropdownVal = "First Name";
//   List filters = ["First Name", "Last Name", "Patient ID"];

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: <Color>[Color.fromRGBO(142, 36, 170, 1), Color.fromARGB(255, 74, 20, 140)]),
//           ),),
//         leading: BackButton(
//             onPressed: () => Get.back(),
//           ),
//         title: const Text("Search Patient"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Center(
//                   child: SizedBox(
//                     width: ((MediaQuery.of(context).size.width) * 0.90), 
//                     child: TextField(
//                       controller: searchController,
//                       decoration: const InputDecoration(
//                           labelText: "Search",
//                           hintText: "Search",
//                           prefixIcon: Icon(Icons.search),
//                           contentPadding: EdgeInsets.all(16),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(25.0)))),
//                     ),
//                   ),
//                 ),
//                 DropdownButton(
//                   value: dropdownVal,
//                   style: const TextStyle(color: Colors.grey),
                    
//                   // Down Arrow Icon
//                   icon: const Icon(
//                     Icons.arrow_drop_down_circle_rounded,
//                     color: Colors.purple,
//                     size: 18),    
                    
//                   // Array list of items
//                   items: filters.map<DropdownMenuItem<String>>((filter) {
//                     return DropdownMenuItem<String>(
//                       value: filter,
//                       child: Text(filter),
//                     );
//                   }).toList(),
//                   // After selecting the desired option,it will
//                   // change button value to selected value
//                   onChanged: (String? newValue) { 
//                       setState(() {
//                         dropdownVal= newValue!;
//                       });
//                   },
//                 ),
//               ],
//             ),
//           )
//         ],),
//       persistentFooterButtons: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: OutlinedButton(
//                   onPressed: () {
//                       _searchQueryResults = getUsers(globals.bearerToken);
//                       Get.to(Search(results: _searchQueryResults));
//                   }, 
//                   child: const Text("Display All Patients")),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                       // _searchQueryResults = FireStoreDatabase.readFilteredPatients(dropdownVal, searchController.text);
//                       _searchQueryResults = getFilteredPatients(searchController.text, dropdownVal, globals.bearerToken);
//                       Get.to(Search(results: _searchQueryResults));
//                   }, 
//                   child: const Text("Search Patients")),
//               ),
//           ],)
//       ],
//     );
//   }
// }

// class Search extends StatefulWidget {
//   const Search({ Key? key, required this.results} ) : super(key: key);

//   final Future<List<Map<String, dynamic>>> results;

//   @override
//   _SearchState createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   int mostRecentRecordIndex(List list){
//     return list.length - 1;
//   }

//   Card searchRender(Map<String, dynamic> patient, BuildContext context){

//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//       ),
//       color: Colors.grey[400],
//       child: InkWell(
//         onTap: () async {
          
//           var patientDetailsRequest = await getPatientDetails(patient['centralRegistryID'], globals.bearerToken);

//           var patientDetails = [patientDetailsRequest.record].cast<Map<String, dynamic>>();
//           Get.to(editRecord(patientDetails: patientDetails,));
//         },
//         child: ListTile(
//           hoverColor: Colors.blue[300],
//           title: FittedBox(
//             alignment: Alignment.centerLeft,
//             fit: BoxFit.scaleDown, 
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 returnAvatar(patient['general']['gender']),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8,0,0,0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           patient['general']['lastName'].toUpperCase() + ", " + patient['general']['firstName'],
//                           textAlign: TextAlign.left,
//                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//                       Text("Registry ID: " + patient['centralRegistryID'],
//                         style: const TextStyle(fontSize: 16)),
//                       // Text("Date Created: " + patient['patientHistory'][mostRecentRecordIndex(patient['patientHistory'])]['dateCreated'].toDate().toString(),
//                       //   style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget returnAvatar(String gender){
//     if(gender == "male"){
//       return const CircleAvatar(
//         backgroundColor: Color.fromRGBO(74, 20, 140, 1),
//         maxRadius: 30,
//         backgroundImage: AssetImage('assets/images/avatar_male.png'),
//       );
//     } else if (gender == "female"){
//       return const CircleAvatar(
//         backgroundColor: Color.fromRGBO(74, 20, 140, 1),
//         maxRadius: 30,
//         backgroundImage: AssetImage('assets/images/avatar_female.png'),
//       );
//     } 
    
//     return const CircleAvatar(
//         backgroundColor: Color.fromRGBO(74, 20, 140, 1),
//         maxRadius: 30,
//         backgroundImage: AssetImage('assets/images/avatar_male.png'),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: <Color>[Color.fromRGBO(142, 36, 170, 1), Color.fromARGB(255, 74, 20, 140)]),
//           ),),
//         leading: BackButton(
//             onPressed: () => Get.back(),
//           ),
//         title: const Text("Search Results"),
//         centerTitle: true,
//       ),
//       body: DefaultTextStyle(
//       style: Theme.of(context).textTheme.headline6!,
//       textAlign: TextAlign.center,
//       child: SingleChildScrollView(
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: widget.results, // a previously-obtained Future<String> or null
//           builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//             List<Widget> children;
//             if (snapshot.hasData) {
//               if (snapshot.data == []){
//                 children = <Widget> [
//                 const Center(
//                   child: Text("No results for your search query."),
//                 )
//               ];
//               } else{
//               children = [Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text("Your search returned " + snapshot.data!.length.toString() + " search results." , textAlign: TextAlign.center,),
//               ),
//                 Column(children: snapshot.data!
//                   .map((patient) => searchRender(patient, context))
//                   .toList())
//               ]
//               ;
//               }
//             } else if (snapshot.hasError) {
//               children = <Widget>[
//                 const Icon(
//                   Icons.error_outline,
//                   color: Colors.red,
//                   size: 60,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: Text('Error: ${snapshot.error}'),
//                 )
//               ];
//             } else {
//               children = const <Widget>[
//                 SizedBox(
//                   width: 60,
//                   height: 60,
//                   child: CircularProgressIndicator(),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 16),
//                   child: Text('Awaiting result...'),
//                 )
//               ];
//             }
//             return Center(
//               child: SafeArea(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: children),
//               ),
//             );
//           },
//         ),
//       ),
//     ),
//     );
// }
// }
