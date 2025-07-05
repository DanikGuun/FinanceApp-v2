
import UIKit

protocol CategoryManagmentModel {
    func perform(category: any Category)
    func getInitialCategory() -> (any Category)?
    func getPerformButtonTitle() -> String
    func getPerformButtonImage() -> UIImage?
    func getAdditionalBarItem(additionalAction: (()->())?) -> UIBarButtonItem?
    func getIcon(id: String) -> UIImage?
    func getIcons() -> [any Icon]
    func getColors() -> [UIColor]
}

class BaseCategoryManagmentModel: CategoryManagmentModel {
    
    var categoryDatabase: CategoryDatabase
    var iconProvider: IconProvider
    var colorProvider: ColorProvider
    
    init(categoryDatabase: CategoryDatabase, iconProvider: IconProvider, colorProvider: ColorProvider) {
        self.categoryDatabase = categoryDatabase
        self.iconProvider = iconProvider
        self.colorProvider = colorProvider
    }
    
    func perform(category: any Category) {}
    
    func getInitialCategory() -> (any Category)? { return nil }
    
    func getPerformButtonTitle() -> String { return "" }
    
    func getPerformButtonImage() -> UIImage? { return nil }
    
    func getAdditionalBarItem(additionalAction: (()->())?) -> UIBarButtonItem? { return nil }
    
    func getIcon(id: String) -> UIImage? {
        return iconProvider.getIcon(id: id)?.image
    }
    
    func getIcons() -> [any Icon] {
        return iconProvider.getIcons()
    }
    
    func getColors() -> [UIColor] {
        return colorProvider.getColors()
    }
    
    
}
