import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/account.dart';
import '../models/transaction.dart';

/// Service class for loading and parsing bank data from JSON assets
/// 
/// This class provides methods to load account and transaction data
/// from JSON files stored in the app's assets folder. It handles
/// JSON parsing and error handling for data loading operations.
class BankDataService {
  // In-memory storage for transactions (for testing purposes)
  static Map<String, List<Transaction>> _transactionsCache = {};
  /// Loads all accounts from the accounts.json asset file
  /// 
  /// This method reads the accounts.json file from assets/data/,
  /// parses the JSON content, and converts it into a list of Account objects.
  /// 
  /// Returns: A Future that resolves to a list of Account objects
  /// 
  /// Throws: An exception if the file cannot be loaded or parsed
  static Future<List<Account>> loadAccounts() async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/data/accounts.json');
      
      // Parse the JSON string into a Map
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Extract the accounts array from the JSON
      final List<dynamic> accountsJson = jsonData['accounts'] as List<dynamic>;
      
      // Convert each JSON object to an Account instance
      return accountsJson
          .map((json) => Account.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Log the error and rethrow for caller to handle
      print('Error loading accounts: $e');
      rethrow;
    }
  }

  /// Loads all transactions from the transactions.json asset file
  /// 
  /// This method reads the transactions.json file from assets/data/,
  /// parses the JSON content, and converts it into a map where keys are
  /// account types and values are lists of transactions for that account.
  /// 
  /// Returns: A Future that resolves to a map of account type to list of transactions
  /// Example: {'Chequing': [Transaction1, Transaction2], 'Savings': [Transaction3]}
  /// 
  /// Throws: An exception if the file cannot be loaded or parsed
  static Future<Map<String, List<Transaction>>> loadTransactions() async {
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/data/transactions.json');
      
      // Parse the JSON string into a Map
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Extract the transactions map from the JSON
      final Map<String, dynamic> transactionsJson = jsonData['transactions'] as Map<String, dynamic>;
      
      // Convert the JSON structure to our model structure
      // For each account type, convert its transaction array to Transaction objects
      final Map<String, List<Transaction>> transactions = {};
      
      transactionsJson.forEach((accountType, transactionsList) {
        // Convert each transaction JSON object to a Transaction instance
        transactions[accountType] = (transactionsList as List<dynamic>)
            .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
            .toList();
      });
      
      return transactions;
    } catch (e) {
      // Log the error and rethrow for caller to handle
      print('Error loading transactions: $e');
      rethrow;
    }
  }

  /// Gets all transactions from cache (including test transactions)
  /// 
  /// If cache is empty, loads from JSON first.
  /// 
  /// Returns: A Future that resolves to a map of account type to list of transactions
  static Future<Map<String, List<Transaction>>> loadAllTransactions() async {
    // If cache is empty, load from JSON first
    if (_transactionsCache.isEmpty) {
      _transactionsCache = await loadTransactions();
    }
    return Map.from(_transactionsCache);
  }

  /// Gets transactions for a specific account type
  /// 
  /// This is a convenience method that loads all transactions and filters
  /// them for a specific account type.
  /// 
  /// Parameters:
  /// - [accountType]: The type of account (e.g., "Chequing", "Savings")
  /// 
  /// Returns: A Future that resolves to a list of transactions for the specified account
  ///          Returns an empty list if the account type is not found
  static Future<List<Transaction>> loadTransactionsForAccount(String accountType) async {
    // If cache is empty, load from JSON first
    if (_transactionsCache.isEmpty) {
      _transactionsCache = await loadTransactions();
    }
    return _transactionsCache[accountType] ?? [];
  }

  /// Adds a new transaction to the specified account (in memory only)
  /// 
  /// This is a testing feature that allows adding transactions in memory.
  /// The transactions are not persisted to the JSON file.
  /// 
  /// Parameters:
  /// - [accountType]: The type of account (e.g., "Chequing", "Savings")
  /// - [date]: The transaction date in YYYY-MM-DD format
  /// - [description]: The transaction description
  /// - [amount]: The transaction amount (positive for deposits, negative for withdrawals)
  static Future<void> addTransaction(
    String accountType,
    String date,
    String description,
    double amount,
  ) async {
    // Ensure cache is loaded
    if (_transactionsCache.isEmpty) {
      _transactionsCache = await loadTransactions();
    }
    
    // Create new transaction
    final newTransaction = Transaction(
      date: date,
      description: description,
      amount: amount,
    );
    
    // Add to cache
    if (_transactionsCache.containsKey(accountType)) {
      _transactionsCache[accountType]!.add(newTransaction);
    } else {
      _transactionsCache[accountType] = [newTransaction];
    }
  }
}
