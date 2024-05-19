import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cms/reminder.dart';

class DatabaseHelper {
  get _databaseHelper => null;

  Future<String> _retrieveContractInfoFromDatabase(String userQuery) async {
    try {
      String contractInfo = await _databaseHelper.getContractInfo(userQuery);
      return contractInfo;
    } catch (error) {
      print("Error retrieving contract information from database: $error");
      return 'Error: Unable to retrieve contract information';
    }
  }

  Future<String> getContractInfo(String userQuery) async {
    try {
      // Implement logic to fetch contract information based on userQuery
      List<Contract> contracts = await getAllContracts();

      // Find the contract that matches the user's query
      String contractInfo = '';
      for (Contract contract in contracts) {
        if (contract.contractName.toLowerCase() == userQuery.toLowerCase()) {
          contractInfo = "Contract Name: ${contract.contractName}\n"
                  "Party: ${contract.party}\n"
              // Include other contract information as needed
              ;
          break;
        }
      }
      return contractInfo;
    } catch (error) {
      print("Error fetching contract information: $error");
      return 'Error: Unable to fetch contract information';
    }
  }

  //Insterted this code for the reminder class.
  Future<void> insertReminder(Reminder reminder) async {
    final Database db = await database;
    await db.insert(
      'reminders',
      reminder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int?> getTotalContractsCount() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query('contracts');
    print('Total contracts count: ${result.length}');
    return result.length;
  }

  static Database? _database;

  Future<Database> get database async {
    // Check if database already exists, otherwise create it
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'contracts_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          """
          CREATE TABLE contracts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            contract_number TEXT UNIQUE,
            contract_name TEXT NOT NULL,
            party TEXT NOT NULL,
            type TEXT,
            department TEXT,
            location TEXT,
            value TEXT,
            effective_date INTEGER,
            expiry_date INTEGER
          )
          """,
        );
      },
    );
  }

  Future<void> insertContract(Contract contract) async {
    final Database db = await database;

    // Generate a unique contract number using timestamp and a unique identifier
    String contractNumber = DateTime.now().millisecondsSinceEpoch.toString();

    // Assign the generated contract number to the contract
    contract.contractNumber = contractNumber;

    // Insert the contract into the database
    await db.insert(
      'contracts',
      contract.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Contract>> getAllContracts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contracts');
    return List.generate(maps.length, (i) {
      return Contract(
        contractName: maps[i]['contract_name'],
        party: maps[i]['party'],
        type: maps[i]['type'],
        department: maps[i]['department'],
        location: maps[i]['location'],
        effectiveDate: maps[i]['effective_date'].toString(),
        expiryDate: maps[i]['expiry_date'].toString(),
        contractNumber: maps[i]['contract_number'], // Added contractNumber
      );
    });
  }

  Future<void> deleteContract(String contractNumber) async {
    final db = await database;
    await db.delete(
      'contracts',
      where: 'contract_number = ?',
      whereArgs: [contractNumber],
    );
  }

  getContractFromDatabase(String contractName) {}

  //getTotalContractsCount() {}
}

class Contract {
  String contractNumber; // Add contractNumber property

  final String contractName;
  final String party;
  final String? type;
  final String? department;
  final String? location;
  final String? effectiveDate;
  final String? expiryDate;

  Contract({
    required this.contractName,
    required this.party,
    this.type,
    this.department,
    this.location,
    this.effectiveDate,
    this.expiryDate,
    required this.contractNumber, // Add contractNumber to the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'contract_number': contractNumber,
      'contract_name': contractName,
      'party': party,
      'type': type,
      'department': department,
      'location': location,
      'effective_date': effectiveDate,
      'expiry_date': expiryDate,
    };
  }
}
