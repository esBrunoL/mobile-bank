import 'package:flutter/material.dart';
import '../models/account.dart';
import 'package:intl/intl.dart';

/// A reusable card widget for displaying account information
/// 
/// This widget presents account details in a visually appealing card format,
/// including the account type, number, and balance. It also provides an
/// optional action button for viewing transactions.
class AccountCard extends StatelessWidget {
  /// The account data to display
  final Account account;
  
  /// Callback function when card or "View Transactions" button is pressed
  /// If null, the card will not be clickable
  final VoidCallback? onViewTransactions;
  
  /// Whether to show the "View Transactions" button
  /// This allows selective enabling of transaction viewing
  final bool showViewButton;

  /// Constructor for AccountCard
  /// 
  /// Parameters:
  /// - [account]: The account object containing data to display
  /// - [onViewTransactions]: Optional callback for viewing transactions
  /// - [showViewButton]: Whether to show the view transactions button (default: true)
  const AccountCard({
    Key? key,
    required this.account,
    this.onViewTransactions,
    this.showViewButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NumberFormat for displaying currency values
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Card(
      // Add elevation for a raised, shadow effect
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onViewTransactions,
        borderRadius: BorderRadius.circular(12),
        child: Container(
        // Apply gradient background for visual appeal
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Type Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    account.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Account icon based on type
                  Icon(
                    account.type.toLowerCase().contains('saving')
                        ? Icons.savings
                        : Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Account Number
              Text(
                'Account Number',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                account.accountNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              
              // Balance Display
              Text(
                'Current Balance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currencyFormatter.format(account.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // View Transactions Button (conditionally displayed)
              if (showViewButton && onViewTransactions != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onViewTransactions,
                    icon: const Icon(Icons.list_alt),
                    label: const Text('View Transactions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }
}
