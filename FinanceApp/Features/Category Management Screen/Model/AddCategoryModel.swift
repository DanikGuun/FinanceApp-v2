
import UIKit

final class AddCategoryModel: CategoryManagmentModel {
    
    var categoryDatabase: CategoryDatabase
    
    init(categoryDatabase: CategoryDatabase) {
        self.categoryDatabase = categoryDatabase
    }
    
    func perform(category: any Category) {
        categoryDatabase.addCategory(category)
    }
    
    func getInitialCategory() -> (any Category)? {
        return nil
    }
    
    func getPerformButtonTitle() -> String {
        return "Добавить"
    }
    
    func getPerformButtonImage() -> UIImage? {
        let image = UIImage(systemName: "plus.app")
        return image
    }
    
    func getAdditionalBarItem() -> UIBarButtonItem? {
        return nil
    }
    
    
}
