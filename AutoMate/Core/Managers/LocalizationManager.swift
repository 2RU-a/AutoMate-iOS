//
//  LocalizationManager.swift
//  AutoMate
//
//  Created by oto rurua on 25.01.26.
//

import Foundation
import SwiftUI
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @AppStorage("selected_language") var selectedLanguage: String = "ka"
    
    private let translations: [String: [String: String]] = [
        "Home": ["ka": "მთავარი", "en": "Home"],
        "Saved": ["ka": "შენახული", "en": "Saved"],
        "My car": ["ka": "ჩემი მანქანა", "en": "My car"],
        "Cart": ["ka": "კალათა", "en": "Cart"],
        "Profile": ["ka": "პროფილი", "en": "Profile"],
        
        // HomeView-სთვის)
        "Hot Deals": ["ka": "ცხელი შეთავაზებები", "en": "Hot Deals"],
        "Search": ["ka": "ძებნა", "en": "Search"],
        "Add to Cart": ["ka": "კალათაში დამატება", "en": "Add to Cart"],
        
        "profile": ["ka": "პროფილი", "en": "Profile"],
        "user": ["ka": "მომხმარებელი", "en": "User"],
        "delivery": ["ka": "მიწოდება", "en": "Delivery"],
        "address": ["ka": "მისამართების მართვა", "en": "Manage Addresses"],
        "no_address": ["ka": "მისამართი არ არის მითითებული", "en": "No address specified"],
        "my_cars": ["ka": "ჩემი ავტომობილები", "en": "My Vehicles"],
        "garage": ["ka": "ავტოფარეხი", "en": "Garage"],
        "activity": ["ka": "აქტივობა", "en": "Activity"],
        "orders": ["ka": "შეკვეთების ისტორია", "en": "Order History"],
        "service_history": ["ka": "სერვისების ისტორია", "en": "Service History"],
        "settings": ["ka": "პარამეტრები", "en": "Settings"],
        "language": ["ka": "ენა", "en": "Language"],
        "faq": ["ka": "ხშირად დასმული კითხვები", "en": "FAQ"],
        "privacy_policy": ["ka": "კონფიდენციალურობის პოლიტიკა", "en": "Privacy Policy"],
        
        // ავტორიზაცია და გასვლა
        "logout": ["ka": "გასვლა", "en": "Log Out"],
        "login": ["ka": "შესვლა / რეგისტრაცია", "en": "Sign In / Register"],
        "cancel": ["ka": "გაუქმება", "en": "Cancel"],
        "logout_confirm": ["ka": "ნამდვილად გსურთ გასვლა?", "en": "Are you sure you want to log out?"],
        "ok": ["ka": "გავიგე", "en": "OK"],
        
        // იმეილის შეცვლის გვერდი
        "change_email": ["ka": "იმეილის შეცვლა", "en": "Change Email"],
        "current": ["ka": "მიმდინარე", "en": "Current"],
        "new_email": ["ka": "ახალი ელ-ფოსტა", "en": "New Email"],
        "confirmation": ["ka": "დადასტურება", "en": "Confirmation"],
        "password_required_hint": ["ka": "უსაფრთხოებისთვის საჭიროა პაროლის შეყვანა.", "en": "Password is required for security purposes."],
        "enter_password": ["ka": "შეიყვანეთ პაროლი", "en": "Enter Password"],
        "request_update": ["ka": "განახლების მოთხოვნა", "en": "Request Update"],
        "close": ["ka": "დახურვა", "en": "Close"],
        "link_sent": ["ka": "ბმული გაიგზავნა", "en": "Link Sent"],
        "email_verification_msg": ["ka": "იმეილის შესაცვლელად დააჭირეთ დასტურის ბმულს, რომელიც გაიგზავნა", "en": "To change your email, please click the verification link sent to"],
        "update_error": ["ka": "შეცდომა განახლებისას", "en": "Update Error"],
        
        "Search parts...": ["ka": "მოძებნე ნაწილები...", "en": "Search parts..."],
        "Search results": ["ka": "ძებნის შედეგები", "en": "Search results"],
        "Special Offers": ["ka": "სპეციალური შეთავაზებები", "en": "Special Offers"],
        "Categories": ["ka": "კატეგორიები", "en": "Categories"],
        "Hot Offers": ["ka": "ცხელი შეთავაზებები", "en": "Hot Offers"],
        "Product not found": ["ka": "პროდუქტი ვერ მოიძებნა", "en": "Product not found"],
        "Offer details": ["ka": "შეთავაზების დეტალები", "en": "Offer details"],
        "offer_description_long": [
            "ka": "მოცემული შეთავაზება მოქმედებს AutoMate-ის ყველა პარტნიორ ფილიალში. ფასდაკლების მისაღებად წარადგინეთ აპლიკაციაში არსებული QR კოდი ან დაუკავშირდით ცხელ ხაზს.",
            "en": "This offer is valid at all AutoMate partner branches. To receive the discount, present the QR code in the app or contact our hotline."
        ],
        
        // MyCarView Keys
        "garage_title": ["ka": "თქვენი ავტო-ფარეხი", "en": "Your Garage"],
        "garage_guest_message": ["ka": "მანქანების დასამატებლად და სერვისების სამართავად საჭიროა გაიაროთ რეგისტრაცია", "en": "To add vehicles and manage services, please register"],
        "add_new_car": ["ka": "ახალი ავტომობილის დამატება", "en": "Add New Vehicle"],
        "Book Service": ["ka": "სერვისის დაჯავშნა", "en": "Book Service"],
        "book_service_subtitle": ["ka": "ჩაინიშნე მომავალი ვიზიტი", "en": "Schedule your next visit"],
        "add_car_first_hint": ["ka": "სერვისის დასაჯავშნად ჯერ დაამატეთ ავტომობილი", "en": "Add a vehicle first to book a service"],
        "select_car_hint": ["ka": "აირჩიეთ კონკრეტული ავტომობილი სერვისის დასაჯავშნად", "en": "Select a vehicle to book a service"],
        "Upcoming Services": ["ka": "დაგეგმილი სერვისები", "en": "Upcoming Services"],
        "Attention Required": ["ka": "ყურადღება მისაქცევი", "en": "Attention Required"],
        "Overdue": ["ka": "ვადა გადაცილებულია", "en": "Overdue"],
        "no_upcoming_services": ["ka": "დაგეგმილი სერვისები არ გაქვთ", "en": "No upcoming services scheduled"],
        "QR კოდი": ["ka": "QR კოდი", "en": "QR Code"],

        // Favorites Keys
        "No favorites": ["ka": "შენახული პროდუქტები არ მოიძებნა", "en": "No saved items yet"],
        
        "history_empty": ["ka": "ისტორია ცარიელია", "en": "History is empty"],
        "history_empty_desc": ["ka": "თქვენ ჯერ არ გაქვთ დასრულებული სერვისები.", "en": "You have no completed services yet."],
        "mileage": ["ka": "გარბენი", "en": "Mileage"],
        "km": ["ka": "კმ", "en": "km"],
        
        "service_details": ["ka": "სერვისის დეტალები", "en": "Service Details"],
        "service_type": ["ka": "სერვისის ტიპი", "en": "Service Type"],
        "select": ["ka": "აირჩიეთ", "en": "Select"],
        "current_mileage_km": ["ka": "მიმდინარე გარბენი (კმ)", "en": "Current Mileage (km)"],
        "date": ["ka": "თარიღი", "en": "Date"],
        "additional_note": ["ka": "დამატებითი შენიშვნა", "en": "Additional Note"],
        "note_placeholder": ["ka": "მაგ: რა უნდა გაითვალისწინოს ხელოსანმა", "en": "e.g. what the mechanic should know"],
        "add_service_title": ["ka": "სერვისის დამატება", "en": "Add Service"],
        "oil_change": ["ka": "ძრავის ზეთის შეცვლა", "en": "Engine Oil Change"],
        "belt_change": ["ka": "ძრავის ღვედის შეცვლა", "en": "Timing Belt Change"],
        "brake_pads": ["ka": "სამუხრუჭე ხუნდების შეცვლა", "en": "Brake Pads Replacement"],
        "brake_fluid": ["ka": "სამუხრუჭე სითხის შეცვლა", "en": "Brake Fluid Change"],
        "tech_inspection": ["ka": "ტექ. დათვალიერება", "en": "Technical Inspection"],
        "air_filter": ["ka": "ჰაერის ფილტრის შეცვლა", "en": "Air Filter Replacement"],
        "tire_change": ["ka": "საბურავების შეცვლა", "en": "Tire Change"],
        "suspension_repair": ["ka": "სავალი ნაწილის შეკეთება", "en": "Suspension Repair"]
    ]
    
    func t(_ key: String) -> String {
        return translations[key]?[selectedLanguage] ?? key
    }
}
