
import UIKit

protocol CategoryListModel {
    func getCategories(type: CategoryType) -> [any IdentifiableCategory]
    func getImage(iconId: String) -> UIImage?
}

final class BaseCategoryListModel: CategoryListModel {
    
    let categoryDatabase: CategoryDatabase
    let iconProvider: IconProvider
    
    init(categoryDatabase: CategoryDatabase, iconProvider: IconProvider) {
        self.categoryDatabase = categoryDatabase
        self.iconProvider = iconProvider
    }
    
    func getCategories(type: CategoryType) -> [any IdentifiableCategory] {
        return categoryDatabase.getCategories(of: type)
    }
    func getImage(iconId: String) -> UIImage? {
        return iconProvider.getIcon(id: iconId)?.image
    }
}
