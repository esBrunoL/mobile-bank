import 'package:flutter/material.dart';
import '../data/bank_data_service.dart';
import '../models/account.dart';
import '../widgets/account_card.dart';
import 'transaction_details_screen.dart';

/// Account List Screen - Displays all user accounts
/// 
/// This screen loads and displays all accounts from the JSON data source.
/// Users can view account details and access transaction history for one account.
/// The screen includes proper error handling and loading states.
class AccountListScreen extends StatefulWidget {
  const AccountListScreen({Key? key}) : super(key: key);

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

/// State class for AccountListScreen
/// 
/// Manages the loading and display of account data from the JSON file.
/// Handles asynchronous data loading and error states.
class _AccountListScreenState extends State<AccountListScreen> {
  /// List to store loaded accounts (with calculated current balances)
  List<Account> _accounts = [];
  
  /// Map to store original balances from JSON (before net activity calculation)
  Map<String, double> _originalBalances = {};
  
  /// Flag to track loading state
  bool _isLoading = true;
  
  /// Error message if data loading fails
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load accounts when screen initializes
    _loadAccounts();
  }

  /// Loads accounts from JSON data using BankDataService
  /// 
  /// This method fetches account data asynchronously and updates the UI
  /// based on success or failure. It handles errors gracefully and provides
  /// user feedback through loading and error states.
  /// 
  /// Bruno's Modification: Now also loads transactions to calculate
  /// the current balance as (original balance + net activity)
  Future<void> _loadAccounts() async {
    try {
      // Fetch accounts from the data service
      final accounts = await BankDataService.loadAccounts();
      
      // Store original balances before modification
      final originalBalances = <String, double>{};
      
      // Load transactions to calculate net activity for each account
      // This loads from cache if available (includes test transactions)
      final allTransactions = await BankDataService.loadAllTransactions();
      
      // Calculate current balance for each account
      // Current Balance = Original Balance + Net Activity
      // (Net activity is already signed: negative for withdrawals, positive for deposits)
      for (var account in accounts) {
        // Save original balance
        originalBalances[account.type] = account.balance;
        
        final transactions = allTransactions[account.type] ?? [];
        final netActivity = transactions.fold<double>(
          0.0,
          (sum, transaction) => sum + transaction.amount,
        );
        
        // Update the account balance to reflect current balance
        // Add net activity (negative values will reduce balance, positive will increase)
        final currentBalance = account.balance + netActivity;
        
        // Create a new account instance with updated balance
        final updatedAccount = Account(
          type: account.type,
          accountNumber: account.accountNumber,
          balance: currentBalance,
        );
        
        // Replace the account in the list
        final index = accounts.indexOf(account);
        accounts[index] = updatedAccount;
      }
      
      // Update state with loaded and calculated accounts
      setState(() {
        _accounts = accounts;
        _originalBalances = originalBalances;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors and display error message
      setState(() {
        _errorMessage = 'Failed to load accounts: $e';
        _isLoading = false;
      });
    }
  }

  /// Shows dialog to add a test transaction
  /// 
  /// This is a testing feature that allows users to manually add transactions
  /// to any account. The transaction is added to the JSON data in memory.
  void _showAddTransactionDialog() {
    String? selectedAccountType;
    String description = '';
    String transactionType = 'add'; // 'add' or 'subtract'
    double value = 0.0;
    
    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Transaction -TEST-'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Account dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Account',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedAccountType,
                        items: _accounts.map((account) {
                          return DropdownMenuItem<String>(
                            value: account.type,
                            child: Text('${account.type} - ${account.accountNumber}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            selectedAccountType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an account';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Description field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                        maxLength: 20,
                        onChanged: (value) {
                          description = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Transaction type dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        value: transactionType,
                        items: const [
                          DropdownMenuItem(value: 'add', child: Text('Add (Deposit)')),
                          DropdownMenuItem(value: 'subtract', child: Text('Subtract (Withdrawal)')),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            transactionType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Value field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          border: OutlineInputBorder(),
                          prefixText: '\$ ',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (val) {
                          value = double.tryParse(val) ?? 0.0;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter a value';
                          }
                          if (double.tryParse(val) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(val) <= 0) {
                            return 'Value must be greater than 0';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Add the transaction
                      _addTransaction(
                        selectedAccountType!,
                        description,
                        transactionType,
                        value,
                      );
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const Text('Add Transaction'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Adds a test transaction to the specified account
  /// 
  /// This method adds a transaction to the account in memory and reloads
  /// the account list to reflect the changes.
  Future<void> _addTransaction(
    String accountType,
    String description,
    String type,
    double value,
  ) async {
    // Calculate the final amount based on transaction type
    final amount = type == 'add' ? value : -value;
    
    // Get current date in YYYY-MM-DD format
    final now = DateTime.now();
    final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    // Add transaction to the data service (in memory)
    await BankDataService.addTransaction(accountType, date, description, amount);
    
    // Reload accounts to reflect the new transaction
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with back navigation
      appBar: AppBar(
        title: const Text('My Accounts'),
        centerTitle: true,
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
                  // Retry loading accounts
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadAccounts();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Show message if no accounts found
    if (_accounts.isEmpty) {
      return const Center(
        child: Text(
          'No accounts found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    // Display the list of accounts
    return Column(
      children: [
        // Account cards list - clickable cards that navigate to transaction details
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: _accounts.length,
            itemBuilder: (context, index) {
              final account = _accounts[index];
              final originalBalance = _originalBalances[account.type] ?? account.balance;
              
              // Cards are now clickable - tap to view transactions for that account
              return AccountCard(
                account: account,
                showViewButton: false,
                onViewTransactions: () {
                  // Navigate to Transaction Details for the tapped account
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsScreen(
                        accountType: account.type,
                        accountNumber: account.accountNumber,
                        accountBalance: originalBalance,
                        allAccounts: _accounts,
                        originalBalances: _originalBalances,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // Add Transaction TEST button - for testing purposes only
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _accounts.isNotEmpty ? () {
                _showAddTransactionDialog();
              } : null,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Transaction -TEST-'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        
        // Single View Transactions button - user selects account via dropdown in next screen
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _accounts.isNotEmpty ? () {
                // Navigate to Transaction Details - default to first account (Chequing)
                // User can switch accounts using dropdown in the transaction screen
                final firstAccount = _accounts.first;
                final originalBalance = _originalBalances[firstAccount.type] ?? firstAccount.balance;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailsScreen(
                      accountType: firstAccount.type,
                      accountNumber: firstAccount.accountNumber,
                      accountBalance: originalBalance,
                      allAccounts: _accounts,
                      originalBalances: _originalBalances,
                    ),
                  ),
                );
              } : null,
              icon: const Icon(Icons.list_alt),
              label: const Text('View Transactions'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
