# Flutter Bank - Mobile Banking Application

A simple and elegant mobile banking application built with Flutter that displays account information and transaction history using JSON data.

## 🌐 Live Demo

**[View Live Demo](https://esBrunoL.github.io/mobile-bank/)**

---

## 📋 Table of Contents
- [Live Demo](#-live-demo)
- [Bruno's Modifications](#-brunos-modifications)
- [Features](#features)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Deployment](#deployment)

---

## 🔧 Bruno's Modifications

This section documents the custom modifications and enhancements made to the original application.

### Balance Calculation (CORRECTED)

#### **Proper Balance Formula**
- **Corrected Calculation**: `Current Balance = Original Balance + Net Activity`
- Net activity includes both positive (deposits) and negative (withdrawals) amounts
- Negative net activity automatically reduces the balance
- Positive net activity increases the balance

**Example Calculations:**
- Chequing: $2,500.00 + (-$145.00) = **$2,355.00**
- Savings: $5,000.00 + (-$590.00) = **$4,410.00**

### Transaction Details Screen Enhancements

#### **Account Dropdown Selector**
- **NEW**: Dropdown menu in AppBar to switch between accounts
- Select Chequing or Savings without leaving the transaction screen
- Transactions and balance update dynamically when account is changed
- **Account number centered in AppBar** for better visibility
- Single unified interface for viewing all account transactions

#### **Split Summary Display**
- **Net Activity**: Displayed on the left half with color-coded amount (red/green)
- **Current Balance**: Displayed on the right half showing real-time balance
- Both values update when switching accounts via dropdown
- Formula: `Balance = Original Balance + Net Activity`

**Technical Implementation:**
- Added `allAccounts` and `originalBalances` parameters to `TransactionDetailsScreen`
- Implemented `_switchAccount()` method to handle account changes
- State variables track currently selected account: `_selectedAccountType`, `_selectedAccountNumber`, `_selectedAccountBalance`
- DropdownButton in AppBar for account selection
- Dynamic transaction reloading on account switch

### Account List Screen Enhancements

#### **Dynamic Balance Calculation**
- Account balances now reflect **current balance** (live calculation)
- Calculation: `Current Balance = Original Balance + Net Activity`
- Real-time calculation based on all transactions for each account
- Original balances preserved for transaction detail screen

#### **Clickable Account Cards**
- **NEW**: Account cards are now fully clickable
- Tap anywhere on the account card to view its transactions
- InkWell ripple effect provides visual feedback on tap
- Shortcut navigation directly to transaction details for selected account
- Card acts as both information display and navigation element

#### **Add Transaction -TEST- Feature**
- **NEW**: Test feature to manually add transactions to accounts
- Orange "Add Transaction -TEST-" button above "View Transactions" button
- Opens dialog box with transaction input form
- **IMPORTANT**: Transactions are stored in memory only (not persisted to JSON file)
- Useful for testing balance calculations and UI updates

**Dialog Fields:**
- **Account**: Dropdown list showing all account numbers
- **Description**: Text field (max 20 characters)
- **Type**: Dropdown to select "Add (Deposit)" or "Subtract (Withdrawal)"
- **Value**: Decimal number field (must be positive)
- **Add Transaction** button: Validates and submits the form

**Behavior:**
- Validates all fields before submission
- Automatically calculates transaction amount based on type (positive/negative)
- Uses current date (YYYY-MM-DD format)
- Closes dialog and refreshes account list after successful submission
- Updates account balances immediately to reflect new transaction

#### **Simplified Navigation**
- **Single "View Transactions" button** below all account cards
- Opens transaction screen with account selector dropdown
- User selects desired account from dropdown in transaction screen
- Cleaner, more streamlined navigation flow

**Technical Implementation:**
- Modified `_loadAccounts()` to calculate net activity correctly (addition, not subtraction)
- Store original balances in `_originalBalances` map
- Pass all accounts and original balances to transaction screen
- Single button navigates to transaction screen with default account (first in list)
- Wrapped AccountCard content with InkWell widget for tap detection
- onTap callback navigates to TransactionDetailsScreen with selected account
- Added `_transactionsCache` to BankDataService for in-memory transaction storage
- Implemented `addTransaction()` method in BankDataService
- Created `_showAddTransactionDialog()` with StatefulBuilder for reactive form
- Form validation ensures all required fields are filled correctly

---

## Features

### 🏠 Welcome Screen
- Professional bank logo display
- Welcome message with bank branding
- Current date display
- Navigation to account list

### 💰 Account List
- Displays all bank accounts from JSON data
- Shows account type (Chequing/Savings)
- Displays account number and **current balance** (original balance + net activity)
- Beautiful card-based layout with gradient backgrounds
- **Clickable account cards** - tap to view transactions for that account
- **Single "View Transactions" button** below account cards
- Account selection done via dropdown in transaction screen

### 📊 Transaction Details
- **Dropdown selector** in AppBar to switch between accounts
- Displays transaction history for selected account
- Shows transaction date, description, and amount
- Color-coded transactions (green for deposits, red for withdrawals)
- Transaction summary card with statistics:
  - Total number of deposits
  - Total number of withdrawals
  - **Net activity amount (left side)** - color-coded red/green
  - **Current balance (right side)** - calculated as Original Balance + Net Activity
- Sorted by date (most recent first)
- Dynamic updates when switching accounts

## Navigation Flow

```
Welcome Screen → Account List → Transaction Details
     ↓               ↓               ↓
  [Start]      [View Accounts]  [Back Button]
                    ↓               ↓
              [View Transactions]  [Back to Accounts]
                                    ↓
                              [Back to Welcome]
```

## Project Structure

```
flutter_bank/
├── lib/
│   ├── main.dart                 # App entry point with theming
│   ├── models/
│   │   ├── account.dart         # Account data model
│   │   └── transaction.dart     # Transaction data model
│   ├── data/
│   │   └── bank_data_service.dart  # JSON data loading service
│   ├── screens/
│   │   ├── welcome_screen.dart     # Welcome/home screen
│   │   ├── account_list_screen.dart # Account listing screen
│   │   └── transaction_details_screen.dart # Transaction history screen
│   └── widgets/
│       ├── account_card.dart       # Reusable account card widget
│       └── transaction_tile.dart   # Reusable transaction list tile
├── assets/
│   ├── data/
│   │   ├── accounts.json        # Account data
│   │   └── transactions.json    # Transaction data
│   └── images/
│       └── (placeholder for bank logo)
└── pubspec.yaml                 # Project dependencies

```

## Data Format

### accounts.json
```json
{
  "accounts": [
    {
      "type": "Chequing",
      "account_number": "CHQ123456789",
      "balance": 2500.00
    },
    {
      "type": "Savings",
      "account_number": "SAV987654321",
      "balance": 5000.00
    }
  ]
}
```

### transactions.json
```json
{
  "transactions": {
    "Chequing": [...],
    "Savings": [...]
  }
}
```

## Design Highlights

### Visual Appeal
- ✅ Professional blue color scheme (associated with trust and security)
- ✅ Gradient backgrounds for visual depth
- ✅ Card-based layouts with shadows and rounded corners
- ✅ Consistent spacing and typography
- ✅ Color-coded transaction types (green for credits, red for debits)
- ✅ Material Design 3 principles

### User Experience
- ✅ Intuitive navigation with clear action buttons
- ✅ Loading states for async operations
- ✅ Error handling with retry functionality
- ✅ Smooth transitions between screens
- ✅ Icon-based visual indicators
- ✅ Summary statistics for quick insights

### Code Quality
- ✅ Comprehensive code comments for maintainability
- ✅ Modular architecture with separation of concerns
- ✅ Reusable widget components
- ✅ Type-safe data models with JSON serialization
- ✅ Error handling throughout the app
- ✅ Async data loading patterns

## Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **Material Design 3**: UI design system
- **intl**: Internationalization and date/number formatting

## Requirements Met

1. ✅ **Visual Design**: Professional appearance with well-organized layout, clear navigation, consistent styling, and effective use of branding
2. ✅ **Flutter Implementation**: Smooth performance, efficient JSON data retrieval, correct navigation between screens
3. ✅ **Specifications**: All required features implemented including welcome screen, account list, transaction details, and proper navigation flow
4. ✅ **User Experience**: Seamless banking experience with intuitive interface and working features
5. ✅ **Code Comments**: Extensive documentation throughout the codebase for easy future maintenance

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/esBrunoL/mobile-bank.git
   cd mobile-bank
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   
   For web:
   ```bash
   flutter run -d chrome
   ```
   
   For mobile/desktop:
   ```bash
   flutter run
   ```

### Build for Production

**Web:**
```bash
flutter build web --release
```

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Deployment

This application is automatically deployed to GitHub Pages using GitHub Actions.

### Automatic Deployment
- Every push to the `main` branch triggers an automatic build and deployment
- The app is built using Flutter web and deployed to GitHub Pages
- Live URL: https://esBrunoL.github.io/mobile-bank/

### Manual Deployment
To manually deploy:
1. Build the web version:
   ```bash
   flutter build web --release --base-href /mobile-bank/
   ```
2. Push changes to the `main` branch
3. GitHub Actions will automatically deploy the build

### GitHub Pages Setup
1. Go to repository Settings → Pages
2. Source: "GitHub Actions"
3. The workflow file (`.github/workflows/deploy.yml`) handles the deployment

## Project Structure

```
flutter_bank/
├── lib/
│   ├── data/
│   │   └── bank_data_service.dart    # JSON data loading & caching
│   ├── models/
│   │   ├── account.dart              # Account data model
│   │   └── transaction.dart          # Transaction data model
│   ├── screens/
│   │   ├── welcome_screen.dart       # Landing page
│   │   ├── account_list_screen.dart  # Account overview
│   │   └── transaction_details_screen.dart  # Transaction history
│   ├── widgets/
│   │   ├── account_card.dart         # Reusable account card
│   │   └── transaction_tile.dart     # Reusable transaction item
│   └── main.dart                     # App entry point
├── assets/
│   ├── data/
│   │   ├── accounts.json             # Account data
│   │   └── transactions.json         # Transaction data
│   └── images/
│       └── bank_logo.png             # Bank logo
├── .github/
│   └── workflows/
│       └── deploy.yml                # GitHub Actions deployment
└── pubspec.yaml                      # Project dependencies
```

## Future Enhancements

- Add authentication and user login
- Implement transaction filtering and search
- Add ability to transfer money between accounts
- Include transaction receipts and PDF export
- Add push notifications for new transactions
- Implement biometric authentication
- Add multi-language support

---

**Built with ❤️ using Flutter**
