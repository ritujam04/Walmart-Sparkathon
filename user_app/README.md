# 🛒 Community Replenishment Marketplace – User App
**Walmart Hackathon 2025**

The **Community Replenishment Marketplace User App** is a Flutter-based mobile application that enables Walmart customers in rural and semi-urban areas to:

- **Browse and add products to cart**  
- **Place grouped orders with neighbors**  
- **Select a nearby Champion (local delivery agent)**  
- **Complete the checkout process seamlessly**  

👉 This app is designed **only for end users (customers)**.

---

## 📱 Features

- 🔑 **Authentication** – User login & signup  
- 🛍️ **Cart Management** – Add, remove, and update products  
- 📦 **Order Placement** – Place orders with selected champion  
- 🏆 **Champion Selection** – Fetch nearby available champions (within 35 km radius)  
- 📄 **QR Screen** – Scan order QR codes *(planned feature)*  
- 🎨 **Walmart-Inspired UI** – Clean, user-friendly design  

---

## 🗂️ Folder Structure
```
lib/
├── constants.dart (This contains the ip address setting for local testing you need to change it according to yourself)
├── main.dart
├── models/
│ ├── cart_item.dart
│ ├── champion.dart
│ ├── order.dart
│ ├── product.dart
│ └── user.dart
├── providers/
│ ├── auth_provider.dart
│ ├── cart_provider.dart
│ ├── order_provider.dart
│ └── order_services.dart
├── screens/
│ ├── auth/ # Login & Signup screens
│ ├── cart/ # Cart UI
│ ├── categories/ # Product categories
│ ├── home_screen.dart
│ ├── main_screen.dart
│ ├── order/ # Order details
│ ├── profile/ # User profile
│ └── qr_screen.dart # QR scanner
├── services/
│ └── auth_service.dart
├── utils/
│ └── snackbar_helper.dart
└── widgets/
├── order_card.dart
└── product_card.dart
```

---

## 🔌 API Usage

This app communicates with the **FastAPI backend** through REST APIs.

### Auth
- **POST** `/signup` → Register new user  
- **POST** `/login` → Authenticate user  

### Champions
- **GET** `/champions/nearby` → Fetch champions within 35 km radius & available  

### Orders
- **POST** `/place-order` → Place an order with cart items + selected champion ID  

---

## ⚡ Installation & Run

### Prerequisites
- Flutter SDK installed  
- Android/iOS emulator or real device  

### Run the App
```bash
cd demoapp
flutter pub get
flutter run
```

---

## 🔮 Future Roadmap

- 📩 **Push notifications** for order updates  
- 💳 **In-app payments** integration  
- 🌐 **Multilingual support** (English + local languages)  
- 📦 **Offline order caching**
