/// Model class representing a financial transaction
/// 
/// This class encapsulates all information related to a bank transaction,
/// including the date, description, and amount. Negative amounts represent
/// debits (withdrawals/payments), while positive amounts represent credits (deposits).
class Transaction {
  /// The date when the transaction occurred (format: YYYY-MM-DD)
  final String date;
  
  /// A description of the transaction (e.g., "ATM Withdrawal", "Deposit")
  final String description;
  
  /// The transaction amount
  /// Negative values represent debits (money out)
  /// Positive values represent credits (money in)
  final double amount;

  /// Constructor for creating a Transaction instance
  /// 
  /// Parameters:
  /// - [date]: The transaction date
  /// - [description]: A description of the transaction
  /// - [amount]: The transaction amount (negative for debits, positive for credits)
  Transaction({
    required this.date,
    required this.description,
    required this.amount,
  });

  /// Creates a Transaction instance from a JSON map
  /// 
  /// This factory constructor is used to deserialize JSON data
  /// into a Transaction object. It maps JSON keys to object properties.
  /// 
  /// Parameters:
  /// - [json]: A map containing transaction data from JSON
  /// 
  /// Returns: A new Transaction instance populated with the JSON data
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  /// Converts the Transaction instance to a JSON map
  /// 
  /// This method serializes the Transaction object into a map
  /// that can be easily converted to JSON format.
  /// 
  /// Returns: A map representation of the transaction
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'description': description,
      'amount': amount,
    };
  }

  /// Determines if this transaction is a debit (money out)
  /// 
  /// Returns: true if the amount is negative, false otherwise
  bool get isDebit => amount < 0;

  /// Determines if this transaction is a credit (money in)
  /// 
  /// Returns: true if the amount is positive, false otherwise
  bool get isCredit => amount > 0;
}
