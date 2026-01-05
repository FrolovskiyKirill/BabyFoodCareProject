//
//  ToastStyle.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 31.12.2024.
//

import UIKit

enum ToastStyle {
    case negative
    case neutral
    case positive
    
    var backgroundColor: UIColor {
        switch self {
        case .negative:
            return UIColor.systemRed
        case .neutral:
            return UIColor.black
        case .positive:
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .white : .systemGreen
            }
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .negative, .neutral:
            return UIColor.white
        case .positive:
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .black : .white
            }
        }
    }
    
    var iconName: String {
        switch self {
        case .negative:
            return "exclamationmark.circle.fill"
        case .neutral:
            return "info.circle.fill"
        case .positive:
            return "checkmark.circle.fill"
        }
    }
}
