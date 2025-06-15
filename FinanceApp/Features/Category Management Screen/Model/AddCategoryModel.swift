
import UIKit

final class AddCategoryModel: CategoryManagmentModel {
    
    var categoryDatabase: CategoryDatabase
    
    init(categoryDatabase: CategoryDatabase) {
        self.categoryDatabase = categoryDatabase
    }
    
    func perform(category: any Category) {
        categoryDatabase.addCategory(category)
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
