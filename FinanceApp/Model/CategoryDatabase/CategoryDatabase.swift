
import Foundation

protocol CategoryDatabase{
    
    func categories(of type: TransactionType) -> [any IdentifiableTransactionCategory]
    func category(id: UUID) -> any IdentifiableTransactionCategory
    
    func add(_ category: any TransactionCategory) -> any IdentifiableTransactionCategory
    func update(_ category: any IdentifiableTransactionCategory, with newCategory: any TransactionCategory)
    func remove(id: UUID)
}
