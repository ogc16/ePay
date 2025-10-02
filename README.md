# 💳 ePay – Ecommerce Mobile App  

<p align="center">
  <a href="https://expo.dev/"><img src="https://img.shields.io/badge/Expo-React%20Native-blue?logo=expo" alt="Expo"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT"></a>
  <a href="https://github.com/ogc16/epay/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square" alt="PRs Welcome"></a>
  <a href="https://github.com/ogc16"><img src="https://img.shields.io/badge/Made%20with-%E2%9D%A4-red.svg" alt="Made with Love"></a>
  <a href="https://github.com/ogc16/epay/stargazers"><img src="https://img.shields.io/github/stars/ogc16/epay?style=social" alt="GitHub Stars"></a>
  <a href="https://github.com/ogc16/epay/network/members"><img src="https://img.shields.io/github/forks/ogc16/epay?style=social" alt="GitHub Forks"></a>
  <a href="https://github.com/ogc16/epay/commits/main"><img src="https://img.shields.io/github/last-commit/ogc16/epay" alt="Last Commit"></a>
  <a href="https://github.com/ogc16/epay/issues"><img src="https://img.shields.io/github/issues/ogc16/epay" alt="Issues"></a>
  <a href="https://github.com/ogc16/epay/pulls"><img src="https://img.shields.io/github/issues-pr/ogc16/epay" alt="Pull Requests"></a>
</p>
---

A **cross-platform ecommerce mobile app** built with **React Native** and **Expo**, designed for **seamless shopping, secure payments, and efficient order management**.  
Optimized for **retail businesses in emerging markets**, ePay offers a fast, reliable, and scalable mobile commerce solution.  

---

## ✨ Features  

- 🛍️ **Product browsing** with categories, search, and filters  
- 🛒 **Shopping cart & checkout** with real-time price updates  
- 🚚 **Order tracking** and status notifications  
- 💳 **Mobile payments** via integrated gateways  
- 🔐 **User authentication & profile management**  
- 📊 **Admin dashboard** for inventory and orders *(optional)*  

---

## 🧰 Tech Stack  

- ⚛️ **React Native** + **Expo** (cross-platform development)  
- 🛣️ **Expo Router** (navigation)  
- 🔥 **Firebase / Supabase** *(or custom backend integration)*  
- 🔐 Secure storage & payment modules  
- 🌐 Web browser integration for payments  

---

## 📦 Installation  

Clone the repository and install dependencies:  

```sh
git clone https://github.com/ogc16/epay.git
cd epay
npm install   # or pnpm install
```
## 📱 Running the App
```sh
npx expo start
```
Scan the QR code with Expo Go App

Or run on Android/iOS emulator

## ⚙️ Configuration
Create a .env file in the root directory:

```env
API_URL=https://your-api.com
PAYMENT_KEY=your_payment_gateway_key
```

## 🚀 Deployment
Build with Expo Application Services (EAS):

```bash
eas build --platform android
```
Then distribute via:

  * Google Play Store (Android)

  * Apple App Store (iOS)

(Update app.json with app name, icons, and credentials before publishing.)

## 🤝 Contributing
Contributions are welcome! 🎉

- Fork the repo

- Create a feature branch (git checkout -b feature-name)

- Commit changes (git commit -m "Add feature")

- Push and open a pull request

 For major changes, please open an issue first to discuss your ideas.

## 📄 License
MIT License © 2025 Caleb Ngeno
