import 'package:flutter/material.dart';
import 'package:cms/database.dart'; // Import your Contract class

class ContractDetailsScreen extends StatelessWidget {
  final Contract contract;

  ContractDetailsScreen({required this.contract});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        backgroundColor: Color.fromARGB(255, 213, 19, 6),
        title: Text('Contract Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        
        child: Column(
        
          children: [
            _buildFieldRow('Contract Name:', contract.contractName),
            _buildFieldRow('Party:', contract.party),
            _buildFieldRow('Type:', contract.type ?? 'N/A'),
            _buildFieldRow('Department:', contract.department ?? 'N/A'),
            _buildFieldRow('Location:', contract.location ?? 'N/A'),
           // _buildFieldRow('Value:', contract.cashValue ?? 'N/A'),
            _buildFieldRow('Effective Date:', contract.effectiveDate ?? 'N/A'),
            _buildFieldRow('Expiry Date:', contract.expiryDate ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
