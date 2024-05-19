// ignore_for_file: unused_local_variable

import 'package:cms/chatScreen.dart';
import 'package:cms/contractScreenDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cms/database.dart';
import 'package:googleapis/artifactregistry/v1.dart';
import 'package:signature/signature.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRepository extends StatefulWidget {
  @override
  _MyRepositoryState createState() => _MyRepositoryState();
}

class _MyRepositoryState extends State<MyRepository> {
  SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _contractName = "";
  String _party = "";
  String _contractType = "";
  String _department = "";
  String _location = "";
  //String _value = "";
  DateTime? _currentEffectiveDate;
  DateTime? _currentExpiryDate;

  String _searchQuery = '';

  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Contract> contracts = [];

  get signatureBase64 => null;

  void _searchContracts() async {
    setState(() {
      contracts.clear();
    });
    // Implement your search logic here
    // For example, you can filter the contracts list based on the search query
    setState(() {
      contracts = contracts.where((contract) {
        // Filter contracts based on contract name
        return contract.contractName
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  void initState() {
    super.initState();
    // Initialize the SignatureController
    _signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
    );
  }

  void _sortContract() {
    setState(() {
      contracts.sort((a, b) => a.contractName.compareTo(b.contractName));
    });
  }

  void _deleteOrViewContract(Contract contract, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Contract Options"),
        content: Text("Choose an action for this contract:"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteContract(contract, context);
            },
            child: Text("Delete"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _viewContractDetails(contract, context);
            },
            child: Text("View Details"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              toolbarHeight: 110,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _searchContracts();
                    },
                    icon: Icon(Icons.search, color: Colors.black),
                  ),
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Get.to(ChatroomScreen());
                  },
                  child: Image.asset(
                    'assets/images/cb.png',
                    width: 24,
                    height: 24,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(0)),
                width: double.infinity,
                child: Row(
                  children: [
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Get.dialog(
                          SimpleDialog(
                            title: Text("Sort By"),
                            children: [
                              SimpleDialogOption(
                                onPressed: () {
                                  Get.back();
                                  print("Sort: Latest First");
                                },
                                child: Text("Latest First"),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Get.back();
                                  print("Sort: Earliest First");
                                },
                                child: Text("Earliest First"),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  _sortContract();
                                  Get.back();
                                  print("Sort: A-Z");
                                },
                                child: Text("A-Z"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.sort),
                    ),
                    Text("Sort"),
                    IconButton(
                      onPressed: () => Get.dialog(
                        Material(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                              border: Border.all(
                                  color: Colors.grey), // Border color
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "New Contract",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Form(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: "Contract Name",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Rounded corners
                                                ),
                                                hintText:
                                                    "Enter contract name", // Hint text
                                              ),
                                              validator: (value) =>
                                                  value!.isEmpty ? "" : null,
                                              onSaved: (value) =>
                                                  _contractName = value!,
                                            ),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: "Party",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Rounded corners
                                                ),
                                                hintText: "Enter party",
                                              ),
                                              validator: (value) =>
                                                  value!.isEmpty ? "" : null,
                                              onSaved: (value) =>
                                                  _party = value!,
                                            ),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Type',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Rounded corners
                                                ),
                                                hintText: "Enter contract type",
                                              ),
                                              onSaved: (value) =>
                                                  _contractType = value!,
                                            ),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: "Department",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Rounded corners
                                                ),
                                                hintText: "Enter department",
                                              ),
                                              onSaved: (value) =>
                                                  _department = value!,
                                            ),
                                            SizedBox(height: 10),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: "Location",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Rounded corners
                                                ),
                                                hintText: "Enter location",
                                              ),
                                              onSaved: (value) =>
                                                  _location = value!,
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text("Effective Date: "),
                                                Expanded(
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller:
                                                        TextEditingController(
                                                      text: _currentEffectiveDate !=
                                                              null
                                                          ? _currentEffectiveDate!
                                                              .toString()
                                                              .substring(0, 10)
                                                          : 'Select Date',
                                                    ),
                                                    onTap: () =>
                                                        _selectEffectiveDate(
                                                            context),
                                                    decoration: InputDecoration(
                                                      hintText: '',
                                                      suffixIcon: Icon(
                                                          Icons.calendar_today),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text("Expiry Date: "),
                                                Expanded(
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller:
                                                        TextEditingController(
                                                      text: _currentExpiryDate !=
                                                              null
                                                          ? _currentExpiryDate!
                                                              .toString()
                                                              .substring(0, 8)
                                                          : 'Select Date',
                                                    ),
                                                    onTap: () =>
                                                        _selectExpiryDate(
                                                            context),
                                                    decoration: InputDecoration(
                                                      hintText: '',
                                                      suffixIcon: Icon(
                                                        Icons.calendar_today,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text("E-signature:"),
                                            Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), // Rounded corners
                                                border: Border.all(
                                                    color: Colors
                                                        .grey), // Border color
                                              ),
                                              child: Stack(
                                                children: [
                                                  Signature(
                                                    controller:
                                                        _signatureController,
                                                    height: 130,
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        _signatureController
                                                            .clear();
                                                      },
                                                      child: Text(
                                                        "Clear Signature",
                                                        style: GoogleFonts.ptSans(
                                                            textStyle: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _formKey.currentState!
                                                          .save();
                                                      await _saveContract();
                                                    }
                                                  },
                                                  child: Text("Save"),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () => Get.back(),
                                                    child: Text(
                                                      "Cancel",
                                                      style: GoogleFonts.ptSans(
                                                          textStyle: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Color.fromARGB(
                                                          255,
                                                          229,
                                                          62,
                                                          50), // Change the background color
                                                      onPrimary: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.add),
                    ),
                    Text("Add"),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Expanded(
                  child: FutureBuilder<List<Contract>>(
                    future:
                        _databaseHelper.getAllContracts(), // i created a method
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No contracts available'));
                      } else {
                        List<Contract> filteredContracts =
                            snapshot.data!.where((contract) {
                          return contract.contractName
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                        }).toList();
                        filteredContracts.sort(
                            (a, b) => a.contractName.compareTo(b.contractName));

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Contract No.',
                                ),
                              ),
                              DataColumn(label: Text('Name.')),
                              DataColumn(label: Text('Party')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Department')),
                              DataColumn(label: Text('Location')),
                            ],
                            rows:
                                filteredContracts.asMap().entries.map((entry) {
                              int index = entry.key;
                              Contract contract = entry.value;
                              if (index == 1) {
                                // Skip the delete option for the first row
                                return DataRow(cells: [
                                  DataCell(
                                    Text(contract.contractNumber.toString()),
                                    onTap: () {
                                      _deleteOrViewContract(contract, context);
                                    },
                                  ),
                                  DataCell(Text(contract.contractName)),
                                  DataCell(Text(contract.party)),
                                  DataCell(Text(contract.type ?? 'N/A')),
                                  DataCell(Text(contract.department ?? 'N/A')),
                                  DataCell(Text(contract.location ?? 'N/A')),
                                  //DataCell(Text(contract.value ?? 'N/A')),
                                ]);
                              } else {
                                // Render the delete option for other rows
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(contract.contractNumber.toString()),
                                      onTap: () {
                                        _deleteOrViewContract(
                                            contract, context);
                                      },
                                    ),
                                    DataCell(Text(contract.contractName)),
                                    DataCell(Text(contract.party)),
                                    DataCell(Text(contract.type ?? 'N/A')),
                                    DataCell(
                                        Text(contract.department ?? 'N/A')),
                                    DataCell(Text(contract.location ?? 'N/A')),
                                  ],
                                  onSelectChanged: (isSelected) {
                                    if (isSelected!) {
                                      _deleteContract(contract, context);
                                    }
                                  },
                                );
                              }
                            }).toList(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectEffectiveDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentEffectiveDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _currentEffectiveDate = selectedDate;
      });
    }
  }

  void _selectExpiryDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentExpiryDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _currentExpiryDate = selectedDate;
      });
    }
  }

  Future<void> _saveContract() async {
    int totalContracts = contracts.length;
    int contractNumber = totalContracts + 1;

    Contract contract = Contract(
      contractName: _contractName,
      party: _party,
      type: _contractType,
      department: _department,
      location: _location,
      effectiveDate: _currentEffectiveDate.toString(),
      expiryDate: _currentExpiryDate.toString(),
      contractNumber: '',
      //signature: signatureBase64,
    );
    await _databaseHelper.insertContract(contract);
    setState(() {
      _currentEffectiveDate = null;
      _currentExpiryDate = null;
      //_signatureController.clear();
    });
    Get.back();
    Get.snackbar(
      'Success',
      'Contract saved.',
      duration: Duration(seconds: 3),
    );
  }

  void _viewContractDetails(Contract contract, BuildContext context) {
    Get.to(() => ContractDetailsScreen(contract: contract));
  }

  Future<void> _deleteContract(Contract contract, BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this contract?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Return true to confirm deletion
            },
            child: Text("Delete"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Return false to cancel deletion
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );

    // If user confirms deletion, delete the contract
    if (confirmDelete == true) {
      // Perform deletion logic here, e.g., call a function from your database helper

      await _databaseHelper.deleteContract(contract.contractNumber);

      setState(() {
        contracts.remove(contract);
      });

      Get.snackbar(
        'Success',
        'Contract deleted.',
        duration: Duration(seconds: 3),
      );
    }
  }
}
