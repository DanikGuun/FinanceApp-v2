
import Foundation

protocol CategoryDatabase{
    
    func getCategory(id: UUID) -> (any IdentifiableCategory)?
    func getAllCategories() -> [any IdentifiableCategory]
    func getCategories(of type: CategoryType) -> [any IdentifiableCategory]
    
    @discardableResult func addCategory(_ category: any Category) -> (any IdentifiableCategory)?
    func updateCategory(id: UUID, with newCategory: any Category)
    func removeCategory(id: UUID)
    
}
