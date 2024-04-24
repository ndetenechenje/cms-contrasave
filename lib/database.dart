import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
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
  }) : contractNumber = DateTime.now().millisecondsSinceEpoch.toString();

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

  void remove(Contract contract) {}
}
