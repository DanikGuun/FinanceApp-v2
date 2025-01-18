
import Foundation

protocol TransactionCategoryDatabase{
    
    func allCategories() -> [any IdentifiableTransactionCategory]
    func categories(of type: TransactionType) -> [any IdentifiableTransactionCategory]
    func category(id: UUID) -> (any IdentifiableTransactionCategory)?
    
    @discardableResult func add(_ category: any TransactionCategory) -> (any IdentifiableTransactionCategory)?
    func update(_ category: any IdentifiableTransactionCategory, with newCategory: any TransactionCategory)
    func remove(category: any IdentifiableTransactionCategory)
}
