import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

/// A reusable list tile widget for displaying individual transactions
/// 
/// This widget presents transaction details in a clean, organized format
/// with visual indicators for credits (deposits) and debits (withdrawals).
/// It uses color coding to quickly distinguish between money in and money out.
class TransactionTile extends StatelessWidget {
  /// The transaction data to display
  final Transaction transaction;

  /// Constructor for TransactionTile
  /// 
  /// Parameters:
  /// - [transaction]: The transaction object containing data to display
  const TransactionTile({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NumberFormat for displaying currency values
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    // DateFormat for displaying dates in a user-friendly format
    final dateFormatter = DateFormat('MMM dd, yyyy');
    
    // Parse the date string from the transaction
    final transactionDate = DateTime.parse(transaction.date);
    
    // Determine if this is a credit (money in) or debit (money out)
    final isCredit = transaction.isCredit;
    
    // Choose colors based on transaction type
    final amountColor = isCredit ? Colors.green[700] : Colors.red[700];
    final icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
    final iconColor = isCredit ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        
        // Leading icon indicating transaction type (credit or debit)
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        
        // Transaction description and date
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            dateFormatter.format(transactionDate),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ),
        
        // Transaction amount with appropriate color coding
        trailing: Text(
          currencyFormatter.format(transaction.amount.abs()),
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
