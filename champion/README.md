**Community Replenishment Marketplace — Champion App**


**Walmart Hackathon 2025**


The Champion App is a Flutter mobile application designed for local delivery agents ("Champions") who receive and fulfill grouped community orders placed by Walmart customers. Champions register, choose dates they are available to receive grouped orders, and confirm deliveries by scanning a unique QR code shown by the customer on the scheduled delivery date.




**What this app does**


Registers Champions (name, contact, address, pin code, password)


Lets Champions select availability date(s) on which they can receive grouped orders from Walmart


Posts Champion availability to the backend so customers can be matched to Champions when placing grouped orders


Supports QR-based delivery verification: customers show a unique QR (from their order) and Champions scan it to mark delivery




**Key Features**


🔐 Authentication — Champion signup \& login


📆 Availability scheduling — Champions pick dates to receive deliveries


📍 Location-aware matching — backend returns top-5 nearest available Champions for a customer’s delivery date


📸 QR verification — scan customer order QR to confirm delivery


✅ Delivery lifecycle — Accept, pick, deliver, confirm




**Folder Structure**


lib/


├── main.dart


└── screens/


├── create\_account\_page.dart


├── home\_page.dart


└── login\_page.dart




**API Usage**


**Auth**


POST /create\_account — register champion (name, email, phone, address, pin\_code, password)


POST /login — authenticate champion



**Availability**


POST /availability — champion posts selected availability date(s)


Request payload example:{ "champion\_email": "xyz@example.com", "selected\_date": "2025-12-15" }


Response example:{ "message": "Availability saved", "cutoff\_at": "2025-12-10T18:00:00" }



**Matching (used by User App)**


GET /champions/nearby?lat={lat}\&lng={lng}\&date={yyyy-mm-dd}


Returns top-5 nearest champions available on the requested date, sorted by distance.



**Orders \& QR**


POST /place-order (User App) — creates order and returns order\_id and qr\_payload/qr\_url to the customer


POST /orders/{order\_id}/verify-qr — champion verifies scanned QR


Request example: { "champion\_email": "xyz@example.com", "qr\_payload": "<scanned\_string>" }


Response: 200 OK if QR is valid and maps to the pending delivery




**⚡ Installation \& Run**


**Prerequisites**


Flutter SDK installed Android/iOS emulator or real device


**Run the App**


flutter pub get


flutter run

