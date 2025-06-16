
import UIKit

final class AddCategoryModel: CategoryManagmentModel {
    
    var categoryDatabase: CategoryDatabase
    var iconPtovider: IconProvider
    
    init(categoryDatabase: CategoryDatabase, iconProvider: IconProvider) {
        self.categoryDatabase = categoryDatabase
        self.iconPtovider = iconProvider
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
    
    func getIcon(id: String) -> UIImage? {
        return iconPtovider.getIcon(id: id)?.image
    }
    
}
