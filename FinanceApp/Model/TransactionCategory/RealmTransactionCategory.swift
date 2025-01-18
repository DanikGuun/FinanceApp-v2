import RealmSwift
import UIKit
import Foundation

class RealmTransactionCategory: Object, IdentifiableTransactionCategory {
    
    @Persisted var id: UUID = UUID()
    @Persisted var name: String
    @Persisted var _type: String
    @Persisted var _color: Data
    @Persisted var iconID: String
    
    var type: TransactionType {
        get { return TransactionType(rawValue: _type) ?? .expense }
        set { self._type = newValue.rawValue }
    }
    
    var color: UIColor{
        get { return UIColor(data: _color) ?? .black }
        set { _color = newValue.data }
    }
    
    func copyValues(from category: any TransactionCategory){
        self.name = category.name
        self._type = category.type.rawValue
        self._color = category.color.data
        self.iconID = category.iconID
    }
    
}
