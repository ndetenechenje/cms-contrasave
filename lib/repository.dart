import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cms/database.dart';

class MyRepository extends StatefulWidget {
  @override
  _MyRepositoryState createState() => _MyRepositoryState();
}

class _MyRepositoryState extends State<MyRepository> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _contractName = "";
  String _party = "";
  String _contractType = "";
  String _department = "";
  String _location = "";
  DateTime? _effectiveDate;
  DateTime? _expiryDate;

  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Contract> contracts = [];
  String _searchQuery='';

void _searchContracts() {
    // Implement your search logic here
    // For example, you can filter the contracts list based on the search query
    setState(() {
      contracts = contracts.where((contract) {
        // Filter contracts based on contract name
        return contract.contractName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              
                IconButton(
                  onPressed: () {
                    print("Profile clicked!");
                  },
                  icon: Icon(Icons.person, color: Colors.black),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(8)),
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
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Contract Name"),
                                      validator: (value) =>
                                          value!.isEmpty ? "" : null,
                                      onSaved: (value) =>
                                          _contractName = value!,
                                    ),
                                    TextFormField(
                                      decoration:
                                          InputDecoration(labelText: "Party"),
                                      validator: (value) =>
                                          value!.isEmpty ? "" : null,
                                      onSaved: (value) => _party = value!,
                                    ),
                                    TextFormField(
                                      decoration:
                                          InputDecoration(labelText: 'Type'),
                                      onSaved: (value) =>
                                          _contractType = value!,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Department"),
                                      onSaved: (value) => _department = value!,
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Location"),
                                      onSaved: (value) => _location = value!,
                                    ),
                                    Row(
                                      children: [
                                        Text("Effective Date: "),
                                        TextButton(
                                          onPressed: () =>
                                              _selectEffectiveDate(context),
                                          child: Text(
                                              _effectiveDate?.toString() ??
                                                  "Select Date"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Expiry Date: "),
                                        TextButton(
                                          onPressed: () =>
                                              _selectExpiryDate(context),
                                          child: Text(_expiryDate?.toString() ??
                                              "Select Date"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "E-signature: (Functionality to be implemented)"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              await _saveContract();
                                            }
                                          },
                                          child: Text("Save"),
                                        ),
                                        ElevatedButton(
                                          //add button color red,
                                          onPressed: () => Get.back(),
                                          child: Text("Cancel"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
              Expanded(
                child: /*FutureBuilder<List<Contract>>(
                  future: _databaseHelper.getAllContracts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No contracts available'));
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Contract No.')),
                            DataColumn(label: Text('Name.')),
                            DataColumn(label: Text('Party')),
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Department')),
                            DataColumn(label: Text('Location')),
                          ],
                          rows: snapshot.data!.asMap().entries.map((entry) {
                            int index = entry.key;
                            Contract contract = entry.value;
                            if (index == 1) {
                              // Skip the delete option for the first row
                              return DataRow(cells: [
                                DataCell(
                                    Text(contract.contractNumber.toString())),
                                DataCell(Text(contract.contractName)),
                                DataCell(Text(contract.party)),
                                DataCell(Text(contract.type ?? 'N/A')),
                                DataCell(Text(contract.department ?? 'N/A')),
                                DataCell(Text(contract.location ?? 'N/A')),
                              ]);
                            } else {
                              // Render the delete option for other rows
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(contract.contractNumber.toString()),
                                    onTap: () {
                                      _deleteContract(contract, context);
                                    },
                                  ),
                                  DataCell(Text(contract.contractName)),
                                  DataCell(Text(contract.party)),
                                  DataCell(Text(contract.type ?? 'N/A')),
                                  DataCell(Text(contract.department ?? 'N/A')),
                                  DataCell(Text(contract.location ?? 'N/A')),
                                ],
                                onSelectChanged: (isSelected) {
                                  if (isSelected!) {
                                    _deleteContract(
                                        contract, context);
                                  }
                                },
                              );
                            }
                          }).toList(),*/
                          FutureBuilder<List<Contract>>(
  future: _databaseHelper.getAllContracts(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text('No contracts available'));
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Contract No.')),
            DataColumn(label: Text('Name.')),
            DataColumn(label: Text('Party')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Location')),
          ],
          rows: snapshot.data!.asMap().entries.map((entry) {
            int index = entry.key;
            Contract contract = entry.value;
            if (index == 1) {
              // Skip the delete option for the first row
              return DataRow(cells: [
                DataCell(Text(contract.contractNumber.toString())),
                DataCell(Text(contract.contractName)),
                DataCell(Text(contract.party)),
                DataCell(Text(contract.type ?? 'N/A')),
                DataCell(Text(contract.department ?? 'N/A')),
                DataCell(Text(contract.location ?? 'N/A')),
              ]);
            } else {
              // Render the delete option for other rows
              return DataRow(
                cells: [
                  DataCell(
                    Text(contract.contractNumber.toString()),
                    onTap: () {
                      _deleteContract(contract, context);
                    },
                  ),
                  DataCell(Text(contract.contractName)),
                  DataCell(Text(contract.party)),
                  DataCell(Text(contract.type ?? 'N/A')),
                  DataCell(Text(contract.department ?? 'N/A')),
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
          ],),),

                        ),
                      );
                    }
                  

  void _selectEffectiveDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _effectiveDate = selectedDate;
      });
    }
  }

  void _selectExpiryDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _expiryDate = selectedDate;
      });
    }
  }

  Future<void> _saveContract() async {
    Contract contract = Contract(
      contractName: _contractName,
      party: _party,
      type: _contractType,
      department: _department,
      location: _location,
      effectiveDate: _effectiveDate.toString(),
      expiryDate: _expiryDate.toString(),
    );
    await _databaseHelper.insertContract(contract);
    Get.back();
    Get.snackbar(
      'Success',
      'Contract saved.',
      duration: Duration(seconds: 3),
    );
  }

  Future <void> _deleteContract(Contract contract, BuildContext context) async{
    bool confirmDelete = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Confirm Deletion"),
      content: Text("Are you sure you want to delete this contract?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Return true to confirm deletion
          },
          child: Text("Delete"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Return false to cancel deletion
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

/*void _deleteContract(Contract contract, BuildContext context) async {
  // Show a confirmation dialog
  bool confirmDelete = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Confirm Deletion"),
      content: Text("Are you sure you want to delete this contract?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Return true to confirm deletion
          },
          child: Text("Delete"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Return false to cancel deletion
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

class _databaseHelper {
  static deleteContract(contractNumber) {}
}*/
