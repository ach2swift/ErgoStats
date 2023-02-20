//
//  Extensions.swift
//  ErgoStats
//
//  Created by Alin Chitas on 07.02.2023.
//

import Foundation
import SwiftUI

extension  View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension String {
    func formatAddrRanges() -> String {
        if self.hasPrefix("ge_") {
            let start = index(startIndex, offsetBy: 3)
            let truncatedString = String(self[start...])
            let replacedString = truncatedString.replacingOccurrences(of: "p", with: ".")
            return replacedString
        } else {
            return self
        }
    }
    
    func formatTopString() -> String{
        switch self {
        case "top_1_prc":
            return "Top 1%"
        case "top_1k":
            return "Top 1K"
        case "top_10":
            return "Top 10"
        case "top_100":
            return "Top 100"
        default:
            return self
        }
    }
    
    func formatAddrDaily() -> String {
        if self.hasPrefix("daily") {
            let start = index(startIndex, offsetBy: 6)
            let truncatedString = String(self[start...])
            let replacedString = truncatedString
            return replacedString
        } else {
            return self
        }
    }
}

extension Double {
    /// Converts a double into a currency with 2-6 decimal places
    ///```
    /// Convert 1234.56 to $1,234.56
    ///```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    /// Converts a double into a currency as a String with 2-6 decimal places
    ///```
    /// Convert 1234.56 to "$1,234.56"
    ///```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    func toDateFromUnixTimestamp() -> Date? {
        let timeInterval = TimeInterval(self)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    func fromIntToStringUSD() -> String {
        return String(format: "%.0f", self / 10000000 )
    }
    
    var formatted: String {
        let number = self
        
        if number >= 1_000_000 {
            return String(format: "%.0f mil", number / 1_000_000)
        } else if number >= 1000 {
            return String(format: "%.0f k", number / 1_000)
        } else if number >= 1{
            return String(format: "%.2f", number)
        } else {
            return String(format: "%.3f", number)
        }
    }
}

extension Int {
    func abbreviated() -> String {

        let billion = 1_000_000_000
        let million = 1_000_000
        let thousand = 1_000
        
        switch self {
        case 0..<thousand:
            return "\(self)"
        case thousand..<million:
            return "\(self / thousand)k"
        case million..<billion:
            return "\(self / million)mil"
        default:
            return "\(self/billion)bn"
        }
    }
    
    func toDateFromUnixTimestamp() -> Date {
        return Date(timeIntervalSince1970: Double(self) / 1000)
    }
    
    func fromNanoToErg() -> Int {
        return self / 1_000_000_000
    }
    
    func fromNanoToErgAgeUSD() -> Double {
        return Double(self) / 1_000_0000
    }
    
    func fromNanoToErgAgeRSV() -> Double {
        return Double(self) / 1_000_000_000
    }
}

extension Optional where Wrapped == Double {
    func toStringPerc() -> String {
        guard let doubleValue = self else { return ""}
        return String(format: "%.2f%%", doubleValue)
    }
    
    func toPlainString() -> String {
        guard let doubleValue = self else { return ""}
        return String(format: "%.0f%", doubleValue)
    }
    
    func toPlainString2F() -> String {
        guard let doubleValue = self else { return ""}
        return String(format: "%.2f%", doubleValue)
    }
}


extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(miliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(miliseconds) / 1000)
    }
    
    var unixTimestampInMilliseconds: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    var unixTimestampOneMonthago: Int64 {
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: self) ?? self
        return Int64(oneMonthAgo.timeIntervalSince1970 * 1000)
    }
    
}
