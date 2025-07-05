
import UIKit

protocol TransactionManagmentModel {
    func perform(transaction: any Transaction)
    func getInitialTransaction() -> (any Transaction)?
    func getPerformButtonTitle() -> String
    func getPerformButtonImage() -> UIImage?
    func getAdditionalBarItem(additionalAction: (()->())?) -> UIBarButtonItem?
    func getCategories(of type: CategoryType) -> [any IdentifiableCategory]
    func getCategory(id: UUID) -> (any IdentifiableCategory)?
    func getIcon(iconId: String) -> UIImage?
}

public class BaseTransactionManagmentModel: TransactionManagmentModel {
    
    let transactionDatabase: TransactionDatabase
    let categoryDatabase: CategoryDatabase
    let iconProvider: IconProvider
    
    init(transactionDatabase: TransactionDatabase, categoryDatabase: CategoryDatabase, iconProvider: IconProvider) {
        self.transactionDatabase = transactionDatabase
        self.categoryDatabase = categoryDatabase
        self.iconProvider = iconProvider
    }
    
    func perform(transaction: any Transaction) {}
    
    func getInitialTransaction() -> (any Transaction)? { nil }
    
    func getPerformButtonTitle() -> String { "" }
    
    func getPerformButtonImage() -> UIImage? { nil }
    
    func getAdditionalBarItem(additionalAction: (() -> ())?) -> UIBarButtonItem? { nil }
    
    func getCategories(of type: CategoryType) -> [any IdentifiableCategory] {
        let categories = categoryDatabase.getCategories(of: type)
        if categories.count > 5 { return Array(categories[0..<5]) }
        return categories
    }
    
    func getCategory(id: UUID) -> (any IdentifiableCategory)? {
        return categoryDatabase.getCategory(id: id)
    }
    
    func getIcon(iconId: String) -> UIImage? {
        return iconProvider.getIcon(id: iconId)?.image
    }
}

