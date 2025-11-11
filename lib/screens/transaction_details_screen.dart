import 'package:flutter/material.dart';
import '../data/bank_data_service.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../widgets/transaction_tile.dart';
import 'package:intl/intl.dart';

/// Transaction Details Screen - Displays transactions for a specific account
/// 
/// This screen loads and displays all transactions for the selected account.
/// Transactions are loaded from JSON data and displayed in a scrollable list.
/// The screen includes proper error handling, loading states, and transaction summary.
/// User can switch between accounts using a dropdown selector.
class TransactionDetailsScreen extends StatefulWidget {
  /// The type of account to load transactions for (e.g., "Chequing", "Savings")
  final String accountType;
  
  /// The account number for display purposes
  final String accountNumber;
  
  /// The original account balance from JSON data
  final double accountBalance;
  
  /// List of all available accounts for dropdown selection
  final List<Account> allAccounts;
  
  /// Map of original balances for all accounts
  final Map<String, double> originalBalances;

  /// Constructor for TransactionDetailsScreen
  /// 
  /// Parameters:
  /// - [accountType]: The account type to filter transactions
  /// - [accountNumber]: The account number to display in the header
  /// - [accountBalance]: The account balance from JSON data
  /// - [allAccounts]: List of all accounts for dropdown
  /// - [originalBalances]: Map of original balances
  const TransactionDetailsScreen({
    Key? key,
    required this.accountType,
    required this.accountNumber,
    required this.accountBalance,
    required this.allAccounts,
    required this.originalBalances,
  }) : super(key: key);

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

/// State class for TransactionDetailsScreen
/// 
/// Manages the loading and display of transaction data from the JSON file.
/// Handles asynchronous data loading, error states, and transaction calculations.
class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  /// List to store loaded transactions
  List<Transaction> _transactions = [];
  
  /// Flag to track loading state
  bool _isLoading = true;
  
  /// Error message if data loading fails
  String? _errorMessage;
  
  /// Currently selected account type for dropdown
  late String _selectedAccountType;
  
  /// Currently selected account number for display
  late String _selectedAccountNumber;
  
  /// Currently selected account balance
  late double _selectedAccountBalance;

  @override
  void initState() {
    super.initState();
    // Initialize with the account passed from navigation
    _selectedAccountType = widget.accountType;
    _selectedAccountNumber = widget.accountNumber;
    _selectedAccountBalance = widget.accountBalance;
    // Load transactions when screen initializes
    _loadTransactions();
  }

  /// Loads transactions from JSON data using BankDataService
  /// 
  /// This method fetches transaction data for the specific account type
  /// and updates the UI based on success or failure. Includes error handling.
  Future<void> _loadTransactions() async {
    try {
      // Fetch transactions for the currently selected account type
      final transactions = await BankDataService.loadTransactionsForAccount(
        _selectedAccountType,
      );
      
      // Sort transactions by date (most recent first)
      transactions.sort((a, b) {
        final dateA = DateTime.parse(a.date);
        final dateB = DateTime.parse(b.date);
        return dateB.compareTo(dateA); // Descending order
      });
      
      // Update state with loaded transactions
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors and display error message
      setState(() {
        _errorMessage = 'Failed to load transactions: $e';
        _isLoading = false;
      });
    }
  }

  /// Switches to a different account and reloads transactions
  /// 
  /// This method is called when user selects a different account from dropdown
  void _switchAccount(String accountType) {
    // Find the selected account from the list
    final selectedAccount = widget.allAccounts.firstWhere(
      (acc) => acc.type == accountType,
      orElse: () => widget.allAccounts.first,
    );
    
    // Get the original balance for the selected account
    final originalBalance = widget.originalBalances[accountType] ?? selectedAccount.balance;
    
    // Update the selected account info
    setState(() {
      _selectedAccountType = accountType;
      _selectedAccountNumber = selectedAccount.accountNumber;
      _selectedAccountBalance = originalBalance;
      _isLoading = true;
      _errorMessage = null;
    });
    
    // Reload transactions for the new account
    _loadTransactions();
  }

  /// Calculates the total amount of all transactions
  /// 
  /// This is useful for showing a summary of activity.
  /// Positive result means net deposits, negative means net withdrawals.
  double _calculateTotalTransactions() {
    return _transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  /// Counts the number of credit transactions (deposits)
  int _countCredits() {
    return _transactions.where((t) => t.isCredit).length;
  }

  /// Counts the number of debit transactions (withdrawals/payments)
  int _countDebits() {
    return _transactions.where((t) => t.isDebit).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with back navigation and account selector dropdown
      appBar: AppBar(
        title: Text(
          _selectedAccountNumber,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leadingWidth: 140,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            // Dropdown selector for switching accounts
            DropdownButton<String>(
              value: _selectedAccountType,
              dropdownColor: Theme.of(context).primaryColor,
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              items: widget.allAccounts.map((account) {
                return DropdownMenuItem<String>(
                  value: account.type,
                  child: Text(
                    account.type,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && newValue != _selectedAccountType) {
                  _switchAccount(newValue);
                }
              },
            ),
          ],
        ),
        elevation: 2,
      ),
      body: _buildBody(),
    );
  }

  /// Builds the body of the screen based on current state
  /// 
  /// Returns different widgets depending on loading state, error state,
  /// or successful data loading. This provides appropriate feedback to users.
  Widget _buildBody() {
    // Show loading indicator while data is being fetched
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error message if loading failed
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Retry loading transactions
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadTransactions();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Show message if no transactions found
    if (_transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'No transactions found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Display the transaction summary and list
    return Column(
      children: [
        // Transaction Summary Card
        _buildSummaryCard(),
        
        // Transactions List Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.receipt_long, size: 20),
              const SizedBox(width: 8),
              Text(
                'Recent Transactions (${_transactions.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        // Scrollable list of transactions
        Expanded(
          child: ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              return TransactionTile(
                transaction: _transactions[index],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds a summary card showing transaction statistics
  /// 
  /// Displays total number of credits, debits, and net transaction amount
  /// to provide users with a quick overview of their account activity.
  Widget _buildSummaryCard() {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final totalAmount = _calculateTotalTransactions();
    final creditsCount = _countCredits();
    final debitsCount = _countDebits();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction Summary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Credits (Deposits) Count
                _buildSummaryItem(
                  icon: Icons.arrow_downward,
                  label: 'Deposits',
                  value: creditsCount.toString(),
                  color: Colors.green[300]!,
                ),
                // Debits (Withdrawals) Count
                _buildSummaryItem(
                  icon: Icons.arrow_upward,
                  label: 'Withdrawals',
                  value: debitsCount.toString(),
                  color: Colors.red[300]!,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white70),
            const SizedBox(height: 8),
            // Net Activity and Current Balance - Side by Side
            Row(
              children: [
                // Left Half - Net Activity
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Net Activity:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormatter.format(totalAmount),
                        style: TextStyle(
                          color: totalAmount >= 0 ? Colors.green[300] : Colors.red[300],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right Half - Current Balance
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Balance:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormatter.format(_selectedAccountBalance + totalAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a summary item widget for the summary card
  /// 
  /// Parameters:
  /// - [icon]: The icon to display
  /// - [label]: The text label
  /// - [value]: The value to display
  /// - [color]: The color for the icon background
  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
