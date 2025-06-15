
import UIKit

final class EditCategoryModel: CategoryManagmentModel {
    
    var editingCategoryId: UUID
    var categoryDatabase: CategoryDatabase
    
    init(editingCategoryId: UUID, categoryDatabase: CategoryDatabase) {
        self.editingCategoryId = editingCategoryId
        self.categoryDatabase = categoryDatabase
    }
    
    func perform(category: any Category) {
        categoryDatabase.updateCategory(id: editingCategoryId, with: category)
    }
    
    func getInitialCategory() -> any Category {
        return DefaultCategory()
    }
    
    func getPerformButtonTitle() -> String {
        return ""
    }
    
    func getPerformButtonImage() -> UIImage {
        return UIImage()
    }
    
    func getAdditionalBarItem() -> UITabBarItem? {
        return nil
    }
    
    
}
