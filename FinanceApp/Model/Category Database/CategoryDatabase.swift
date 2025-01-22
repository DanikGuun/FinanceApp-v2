
import Foundation

protocol CategoryDatabase{
    
    func category(id: UUID) -> (any IdentifiableCategory)?
    func allCategories() -> [any IdentifiableCategory]
    func categories(of type: CategoryType) -> [any IdentifiableCategory]
    
    @discardableResult func add(_ category: any Category) -> (any IdentifiableCategory)?
    func update(_ category: any IdentifiableCategory, with newCategory: any Category)
    func remove(_ category: any IdentifiableCategory)
    
}
