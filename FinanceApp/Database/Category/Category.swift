import UIKit

protocol Category {
    var name: String { get set }
    var type: CategoryType { get set }
    var iconID: String { get set }
    var color: UIColor { get set }
}

protocol IdentifiableCategory: Category, Identifiable{
    var id: UUID { get }
}

enum CategoryType: String, CustomStringConvertible {
    
    case income = "Income"
    case expense = "Expense"
    
    var description: String{
        return "Category type: \(rawValue)"
    }
    
}
