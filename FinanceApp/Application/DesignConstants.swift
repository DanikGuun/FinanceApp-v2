import Foundation
import UIKit

public struct DC {
    
    static let standartInset = 25
    static let interItemSpacing = 25
    static let innerItemSpacing: CGFloat = 7
    static let titleAndItemSpacing = 10
    static let collectionItemSpacing: CGFloat = 10
    static let titleInset: CGFloat = 10
    static let standartButtonHeight: CGFloat = 44
    
    public struct Font {
        public static func regular(size: CGFloat) -> UIFont {
            return UIFont(name: "SF Pro Rounded Regular", size: size)!
        }
        public static func medium(size: CGFloat) -> UIFont {
            return UIFont(name: "SF Pro Rounded Medium", size: size)!
        }
        public static func semibold(size: CGFloat) -> UIFont {
            return UIFont(name: "SF Pro Rounded Semibold", size: size)!
        }
    }
    
}

