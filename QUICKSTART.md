# 🚀 Quick Start Guide - Flutter Bank App

## Getting Started

### Prerequisites
- Flutter SDK installed (3.0.0 or higher)
- Dart SDK (comes with Flutter)
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)
- iOS Simulator (Mac) or Android Emulator

### Installation Steps

1. **Navigate to the project directory:**
   ```bash
   cd c:\Users\bruno\Documents\mobileApp\fluttter-bank
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify everything is set up correctly:**
   ```bash
   flutter doctor
   ```

4. **Run the app:**
   
   For Windows/Android:
   ```bash
   flutter run
   ```
   
   For iOS Simulator (Mac only):
   ```bash
   flutter run -d ios
   ```
   
   For Chrome (Web):
   ```bash
   flutter run -d chrome
   ```

### Testing the App

1. **Launch Screen**: You'll see the Welcome screen with:
   - Flutter Bank logo
   - Welcome message
   - Today's date
   - "View My Accounts" button

2. **Account List**: Click "View My Accounts" to see:
   - Chequing Account: CHQ123456789 - $2,500.00
   - Savings Account: SAV987654321 - $5,000.00
   - "View Transactions" button on the Chequing account

3. **Transaction Details**: Click "View Transactions" to see:
   - Transaction summary with deposits/withdrawals count
   - List of all transactions for the Chequing account
   - Transactions sorted by date (most recent first)
   - Green color for deposits, red for withdrawals

### Navigation Testing

✅ **Forward Navigation:**
- Welcome Screen → Account List (Click "View My Accounts")
- Account List → Transaction Details (Click "View Transactions" on Chequing)

✅ **Back Navigation:**
- Transaction Details → Account List (Use back button or arrow)
- Account List → Welcome Screen (Use back button or arrow)

### Features to Test

#### Welcome Screen
- [ ] Bank logo displays correctly
- [ ] Welcome message is visible
- [ ] Current date shows today's date
- [ ] Button navigates to Account List

#### Account List
- [ ] Both accounts display correctly
- [ ] Account numbers are visible
- [ ] Balances are formatted as currency
- [ ] Only Chequing account has "View Transactions" button
- [ ] Gradient background on cards looks good
- [ ] Back button returns to Welcome screen

#### Transaction Details
- [ ] Account type and number show in app bar
- [ ] Transaction summary card displays
- [ ] All transactions load from JSON
- [ ] Transactions are sorted by date (newest first)
- [ ] Credits show in green with down arrow
- [ ] Debits show in red with up arrow
- [ ] Net activity calculation is correct
- [ ] Back button returns to Account List

### Project Files Overview

**Core Files:**
- `lib/main.dart` - App entry point with theming
- `pubspec.yaml` - Dependencies configuration

**Data Models:**
- `lib/models/account.dart` - Account data structure
- `lib/models/transaction.dart` - Transaction data structure

**Screens:**
- `lib/screens/welcome_screen.dart` - Landing page
- `lib/screens/account_list_screen.dart` - Account overview
- `lib/screens/transaction_details_screen.dart` - Transaction history

**Widgets:**
- `lib/widgets/account_card.dart` - Reusable account card
- `lib/widgets/transaction_tile.dart` - Reusable transaction item

**Services:**
- `lib/data/bank_data_service.dart` - JSON data loader

**Assets:**
- `assets/data/accounts.json` - Account data
- `assets/data/transactions.json` - Transaction data

### Customization Guide

#### Change App Colors
Edit `lib/main.dart` around line 50:
```dart
primaryColor: const Color(0xFF1565C0), // Change this hex color
```

#### Modify Account Data
Edit `assets/data/accounts.json`:
```json
{
  "type": "Your Account Type",
  "account_number": "YOUR123456789",
  "balance": 0000.00
}
```

#### Modify Transaction Data
Edit `assets/data/transactions.json`:
```json
{
  "date": "2024-MM-DD",
  "description": "Your Description",
  "amount": 00.00
}
```

### Troubleshooting

**Problem**: App won't run
- **Solution**: Run `flutter doctor` and fix any issues reported

**Problem**: JSON data not loading
- **Solution**: Run `flutter pub get` and restart the app

**Problem**: Compilation errors
- **Solution**: Run `flutter clean` then `flutter pub get`

**Problem**: Layout issues on different screen sizes
- **Solution**: This is a basic implementation; responsive design can be added

### Hot Reload During Development

While the app is running:
- Press `r` in the terminal for hot reload (fast refresh)
- Press `R` in the terminal for hot restart (full restart)
- Press `q` to quit the app

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS (Mac only):**
```bash
flutter build ios --release
```

---

**Need Help?** Check the main README.md for more detailed information!
