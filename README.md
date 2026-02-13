<img width="1206" height="2622" alt="Authentication" src="https://github.com/user-attachments/assets/acf1ae6c-1580-446d-a62c-a79dbc23c695" />
<img width="1206" height="2622" alt="Profile" src="https://github.com/user-attachments/assets/f1d165b1-3a8d-4b5a-af21-8a5080868e87" />
<img width="1206" height="2622" alt="Shopping Cart" src="https://github.com/user-attachments/assets/999ee6dd-2733-41f2-99c3-d64b4e271c70" />
<img width="1206" height="2622" alt="Booking:Appointment" src="https://github.com/user-attachments/assets/5e1c0ac5-d762-41bf-8d1a-73457d882363" />
<img width="1206" height="2622" alt="Favorites" src="https://github.com/user-attachments/assets/0f8a5fb1-ff06-47c6-9fd7-6bad5c1496f3" />
<img width="1206" height="2622" alt="Home:Main" src="https://github.com/user-attachments/assets/be04d379-fc38-4845-9523-ebbb450960ac" />


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
