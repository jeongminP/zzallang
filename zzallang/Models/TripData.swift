//
//  TripData.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/07.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI
import Foundation

struct TripData: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var userId: String
    var startingDate: String
    var finishingDate: String
    var currency: Currency
    var totalExpenditure: Int
    var sharedDateList: [SharedDailyItem]
    var personalList: [PersonalListItem]
    
    static func makeNewTripData() -> TripData {
        let id = 1001   //추후 수정
        let defaultDate = Date().toString()
        let newTrip = TripData(id: id, name: "", userId: "", startingDate: defaultDate, finishingDate: defaultDate, currency: .krw, totalExpenditure: 0, sharedDateList: [], personalList: [])
        return newTrip
    }
    
    func totalCashExpenditure() -> Int {
        var total: Int = 0
        self.sharedDateList.forEach({
            total += $0.dailyCashExpenditure()
        })
        return total
    }
    
    func totalCardExpenditure() -> Int {
        var total: Int = 0
        self.sharedDateList.forEach({
            total += $0.dailyCardExpenditure()
        })
        return total
    }
    
    func sharedExpenditure(of userId: String) -> Int {
        var total: Int = 0
        self.sharedDateList.forEach({
            total += $0.dailySharedExpenditure(of: userId)
        })
        return total
    }
}

struct SharedDailyItem: Hashable, Codable {
    var date: String
    var dailyTitle: String
    var dailyExpenditure: Int
    var expenditureList: [SharedExpenditureItem]
    
    func dailyCashExpenditure() -> Int {
        var total: Double = 0.0
        self.expenditureList.forEach({
            if $0.payment == .cash {
                total += Double($0.price) * $0.currency.exchangeRate()
            }
        })
        return Int(total)
    }
    
    func dailyCardExpenditure() -> Int {
        var total: Double = 0.0
        self.expenditureList.forEach({
            if $0.payment == .card {
                total += Double($0.price) * $0.currency.exchangeRate()
            }
        })
        return Int(total)
    }
    
    func dailySharedExpenditure(of userId: String) -> Int {
        var total: Double = 0.0
        self.expenditureList.forEach({
            if $0.payer == userId {
                total += Double($0.price) * $0.currency.exchangeRate()
            }
        })
        return Int(total)
    }
}

struct SharedExpenditureItem: Hashable, Codable {
    var title: String
    var payment: Payment
    var currency: Currency
    var price: Int
    var category: Category
    var time: String
    var memo: String
    var payer: String
    var related: [String]
    
    static func makeNewExpenditureItem() -> SharedExpenditureItem {
        let newItem = SharedExpenditureItem(title: "", payment: .cash, currency: .krw, price: 0, category: .etc, time: "00:00", memo: "", payer: "", related: [])
        return newItem
    }
}

struct PersonalListItem: Hashable, Codable {
    var userId: String
    var personalTotalExpenditure: Int
    var dateList: [PersonalDailyItem]
    
    func personalExpenditure() -> Int {
        var total: Int = 0
        self.dateList.forEach({
            total += $0.dailyCashExpenditure()
            total += $0.dailyCardExpenditure()
        })
        return total
    }
}

struct PersonalDailyItem: Hashable, Codable {
    var date: String
    var dailyTitle: String
    var dailyExpenditure: Int
    var expenditureList: [PersonalExpenditureItem]
    
    func dailyCashExpenditure() -> Int {
        var total: Double = 0.0
        self.expenditureList.forEach({
            if $0.payment == .cash {
                total += Double($0.price) * $0.currency.exchangeRate()
            }
        })
        return Int(total)
    }
    
    func dailyCardExpenditure() -> Int {
        var total: Double = 0.0
        self.expenditureList.forEach({
            if $0.payment == .card {
                total += Double($0.price) * $0.currency.exchangeRate()
            }
        })
        return Int(total)
    }
}

struct PersonalExpenditureItem: Hashable, Codable {
    var title: String
    var payment: Payment
    var currency: Currency
    var price: Int
    var category: Category
    var time: String
    var memo: String
    
    static func makeNewExpenditureItem() -> PersonalExpenditureItem {
        let newItem = PersonalExpenditureItem(title: "", payment: .cash, currency: .krw, price: 0, category: .etc, time: "00:00", memo: "")
        return newItem
    }
}

enum Payment: String, CaseIterable, Codable, Hashable {
    case cash = "cash"
    case card = "card"
    
    func toKoreanString() -> String {
        switch self {
        case .cash:
            return "현금"
        case .card:
            return "카드"
        }
    }
}

enum Category: String, CaseIterable, Codable, Hashable {
    case food = "food"
    case shopping = "shopping"
    case tourism = "tourism"
    case traffic = "traffic"
    case lodgement = "lodgement"
    case etc = "etc"
    
    func image() -> Image {
        switch self {
        case .food:
            return Image(systemName: "smiley") //추후 다른 이미지로 대체
        case .shopping:
            return Image(systemName: "bag")
        case .tourism:
            return Image(systemName: "flag")
        case .traffic:
            return Image(systemName: "airplane")
        case .lodgement:
            return Image(systemName: "bed.double")
        case .etc:
            return Image(systemName: "checkmark.circle")    //추후 다른 이미지로 대체
        }
    }
}

enum Currency: String, Codable, Hashable, CaseIterable {
    case krw = "KRW"
    case usd = "USD"
    case cad = "CAD"
    case hkd = "HKD"
    case eur = "EUR"
    case jpy = "JPY"
    case cny = "CNY"
    case twd = "TWD"
    case aud = "AUD"
    case thb = "THB"
    
    func exchangeRate() -> Double {
        switch self {
        case .krw:
            return 1.0
        case .usd:
            return 1158.0
        case .cad:
            return 888.68
        case .hkd:
            return 149.31
        case .eur:
            return 1286.94
        case .jpy:
            return 1059.71
        case .cny:
            return 167.32
        case .twd:
            return 38.69
        case .aud:
            return 796.01
        case .thb:
            return 38.21
        }
    }
    
    func toString() -> String {
        return self.rawValue
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString:String = dateFormatter.string(from: self)
        return dateString
    }
    
    static func invertToDate(with dateString: String) -> Date {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date:Date = dateFormatter.date(from: dateString) {
            return date
        }
        return Date()
    }
    
    static func invertToString(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString:String = dateFormatter.string(from: date)
        return dateString
    }
    
    static func invertToTime(with timeString: String) -> Date {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH:mm"
        if let date:Date = dateFormatter.date(from: timeString) {
            return date
        }
        return Date()
    }
    
    static func invertTimeToString(with time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let timeString:String = dateFormatter.string(from: time)
        return timeString
    }
}
