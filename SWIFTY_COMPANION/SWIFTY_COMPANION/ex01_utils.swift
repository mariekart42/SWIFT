//
//  ex01_utils.swift
//  SWIFTY_COMPANION
//
//  Created by Marie Mensing on 10/15/23.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: opacity
        )
    }
}

func myStoCGFloat(result: String) -> CGFloat {
    if let resultInFloat = Float(result) {
        return CGFloat(resultInFloat)
    }
    return -1 // never checking for that lol
}


func getValueAt(row: Int, column: Int) -> String {
    switch row {
    case 0:
        switch column {
        case 0:
            return "AC"
        case 1:
            return "💀" // dis +/- sign
        case 2:
            return "💀" // dis % sign
        case 3:
            return "÷"
        default:
            return "lol"
        }
    case 1:
        switch column {
        case 0:
            return "7"
        case 1:
            return "8"
        case 2:
            return "9"
        case 3:
            return "×"
        default:
            return "lol"
        }
    case 2:
        switch column {
        case 0:
            return "4"
        case 1:
            return "5"
        case 2:
            return "6"
        case 3:
            return "−"
        default:
            return "lol"
        }
    case 3:
        switch column {
        case 0:
            return "1"
        case 1:
            return "2"
        case 2:
            return "3"
        case 3:
            return "+"
        default:
            return "lol"
        }
    case 4:
        switch column {
        case 0:
            return "0"
        case 1:
            return "0"
        case 2:
            return ","
        case 3:
            return "="
        default:
            return "lol"
        }
    default:
        return "lol"
    }
}
