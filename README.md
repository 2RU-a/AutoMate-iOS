# AutoMate-iOS
AutoService and Store app

Tech stack (SwiftUI, UIKit, Firebase, MVVM)

# AutoMate - Your Personal Auto Assistant

AutoMate არის iOS აპლიკაცია, რომელიც ეხმარება მძღოლებს ავტომობილის სერვისების მართვაში, ავტონაწილების მოძიებასა და სპეციალური შეთავაზებების მიღებაში.

## ფუნქციები (Features)

- **ავტორიზაციის მრავალფეროვნება**: 
  - Email/Password ავტორიზაცია.
  - Google Sign-In ინტეგრაცია.
  - Phone Auth (SMS კოდით შესვლა) Firebase-ის მეშვეობით.
  - ანონიმური შესვლა (Guest Mode).
- **მრავალენოვანი მხარდაჭერა (Localization)**: სრული მხარდაჭერა ქართულ და ინგლისურ ენებზე (UI და მონაცემთა ბაზა).
- **პროდუქტების კატალოგი**: დინამიური მონაცემები Firebase Firestore-იდან (Categories, Special Offers, Hot Deals).
- **სერვისების ისტორია**: მომხმარებლის მიერ შესრულებული სერვისების ჩაწერა და შენახვა თითოეული ავტომობილისთვის.
- **ფავორიტები (Favorites Sync)**: მოწონებული ნივთების სინქრონიზაცია Cloud-ში, რაც უზრუნველყოფს მონაცემების შენარჩუნებას მოწყობილობის შეცვლისას.

## ტექნოლოგიური სტეკი (Tech Stack)

- **Swift & SwiftUI**: თანამედროვე UI დეკლარაციული სტილით.
- **Firebase Auth**: მომხმარებელთა მართვისა და უსაფრთხო ავტორიზაციისთვის.
- **Firebase Firestore**: რეალურ დროში მომუშავე NoSQL მონაცემთა ბაზა.
- **Combine**: მონაცემების ნაკადებისა და State-ის სამართავად.
- **MVVM Pattern**: აპლიკაციის არქიტექტურული მოდელი.

## პროექტის სტრუქტურა

```text
AutoMate/
├── Core/                # ძირითადი მენეჯერები, ექსტენშენები და ლოკალიზაცია
├── Models/              # მონაცემთა მოდელები (Product, Category, Offer, etc.)
├── Features/            # აპლიკაციის ფუნქციური მოდულები (Home, Auth, Profile)
│   ├── Authentication/  # Login, Register, PhoneLogin Views
│   ├── Home/           # HomeView, ViewModels
│   └── Garage/         # Vehicle management and Service history
├── Resources/           # Assets და კონფიგურაციის ფაილები
