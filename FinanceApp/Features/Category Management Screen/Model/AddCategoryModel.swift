
import UIKit

final class AddCategoryModel: BaseCategoryManagmentModel {
    
    override func perform(category: any Category) {
        categoryDatabase.addCategory(category)
    }
    
    override func getPerformButtonTitle() -> String {
        return "Добавить"
    }
    
    override func getPerformButtonImage() -> UIImage? {
        let image = UIImage(systemName: "plus.app")
        return image
    }
    
    override func getAdditionalBarItem() -> UIBarButtonItem? {
        return nil
    }
    
    override func getIcon(id: String) -> UIImage? {
        return iconProvider.getIcon(id: id)?.image
    }
    
}
