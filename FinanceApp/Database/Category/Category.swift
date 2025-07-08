import UIKit

protocol Category: Equatable {
    var name: String { get set }
    var type: CategoryType { get set }
    var iconId: String { get set }
    var color: UIColor { get set }
}

protocol IdentifiableCategory: Category, Identifiable, Equatable {
    var id: UUID { get }
}

enum CategoryType: String, CustomStringConvertible {
    
    case income = "Income"
    case expense = "Expense"
    
    var index: Int {
        switch self{
        case .expense: 0
        case .income: 1
        }
    }
    
    var description: String {
        return "Category type: \(rawValue)"
    }
    
    static let allCases: [CategoryType] = [.expense, .income]
    
}
