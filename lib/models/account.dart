/// Model class representing a bank account
/// 
/// This class encapsulates all information related to a bank account,
/// including its type (Chequing/Savings), account number, and current balance.
/// It provides JSON serialization/deserialization capabilities for data loading.
class Account {
  /// The type of account (e.g., "Chequing", "Savings")
  final String type;
  
  /// The unique account number identifier
  final String accountNumber;
  
  /// The current balance in the account
  final double balance;

  /// Constructor for creating an Account instance
  /// 
  /// Parameters:
  /// - [type]: The account type
  /// - [accountNumber]: The unique account identifier
  /// - [balance]: The current account balance
  Account({
    required this.type,
    required this.accountNumber,
    required this.balance,
  });

  /// Creates an Account instance from a JSON map
  /// 
  /// This factory constructor is used to deserialize JSON data
  /// into an Account object. It maps JSON keys to object properties.
  /// 
  /// Parameters:
  /// - [json]: A map containing account data from JSON
  /// 
  /// Returns: A new Account instance populated with the JSON data
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      type: json['type'] as String,
      accountNumber: json['account_number'] as String,
      balance: (json['balance'] as num).toDouble(),
    );
  }

  /// Converts the Account instance to a JSON map
  /// 
  /// This method serializes the Account object into a map
  /// that can be easily converted to JSON format.
  /// 
  /// Returns: A map representation of the account
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'account_number': accountNumber,
      'balance': balance,
    };
  }
}
