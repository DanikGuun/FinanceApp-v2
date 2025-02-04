
import Foundation

public extension Numeric {
    func currency() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        
        let number = self as? NSNumber ?? 0
        let symbol = formatter.currencySymbol ?? ""
        return formatter.string(from: number)?.replacingOccurrences(of: formatter.currencyCode, with: symbol) ?? ""
    }
}
