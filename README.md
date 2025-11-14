# Holdings Assignment (iOS)

An iOS app built using UIKit and MVVM architecture to display a list of user holdings and portfolio summary.

---

## 📱 Features

- Fetches holdings data from a mock API: https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/
- Displays each holding’s information including quantity, LTP, and investment details.
- Portfolio summary with expanded/collapsed UI state.
- Real-time calculations:
- **Current Value** = Σ (LTP × Quantity)
- **Total Investment** = Σ (Average Price × Quantity)
- **Total PNL** = Current Value − Total Investment
- **Today’s PNL** = Σ ((Close − LTP) × Quantity)

---

## 🧱 Architecture

- **Pattern:** MVVM (Model–View–ViewModel)
- **UI:** UIKit (programmatic)
- **Networking:** URLSession-based lightweight service layer
- **Utilities:** Extensions for formatting & calculation
- **Tests:** XCTest for Unit & UI tests

---

## 🧩 Project Structure

Abhishek-Task/
├── Models/
├── Networking/
├── Utils/
├── View/
│ ├── Components/
│ ├── ViewControllers/
│ └── ViewModels/
├── Tests/
│ ├── NetworkingTests/
│ ├── UtilsTests/
│ └── ViewModelTests/
└── UITests/

---

## 🧪 Unit Tests

Covers:
- Network client & endpoints
- ViewModel calculations
- Utility functions

Run tests via: ⌘ + U

---

## 🧰 Requirements

- **Xcode:** 15+
- **iOS:** 17+
- **Swift:** 5.9+

---

## 🧑‍💻 Author

**Abhishek Singh**  
[GitHub Profile](https://github.com/abhisheks043)

---


