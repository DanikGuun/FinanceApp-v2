
import UIKit

final class EditCategoryModel: BaseCategoryManagmentModel {
    
    var editingCategoryId: UUID
    
    convenience init(editingCategoryId: UUID, categoryDatabase: any CategoryDatabase, iconProvider: any IconProvider, colorProvider: any ColorProvider) {
        self.init(categoryDatabase: categoryDatabase, iconProvider: iconProvider, colorProvider: colorProvider)
        self.editingCategoryId = editingCategoryId
    }
    
    override init(categoryDatabase: any CategoryDatabase, iconProvider: any IconProvider, colorProvider: any ColorProvider) {
        self.editingCategoryId = UUID()
        super.init(categoryDatabase: categoryDatabase, iconProvider: iconProvider, colorProvider: colorProvider)
    }
    
    override func perform(category: any Category) {
        categoryDatabase.updateCategory(id: editingCategoryId, with: category)
    }
    
    override func getInitialCategory() -> (any Category)? {
        let category = categoryDatabase.getCategory(id: editingCategoryId)
        return category
    }
    
    override func getPerformButtonTitle() -> String {
        return "Сохранить"
    }
    
    override func getPerformButtonImage() -> UIImage? {
        let image = UIImage(systemName: "checkmark")
        return image
    }
    
    override func getAdditionalBarItem() -> UIBarButtonItem? {
        let alertController = UIAlertController(title: "Удаление категории", message: "Вы уверены, что хотите удалить категорию?", preferredStyle: .actionSheet)
        let undoAction = UIAlertAction(title: "Отмена", style: .cancel)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.removeCategory()
        }
        alertController.addAction(undoAction)
        alertController.addAction(deleteAction)
        
        
        let barItem = UIBarButtonItem(title: "Удалить", primaryAction: UIAction(handler: { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let rootVC = windowScene!.windows.first?.rootViewController
            rootVC?.present(alertController, animated: true)
        }))
        barItem.tintColor = .systemRed
        return barItem
    }
    
    func removeCategory() {
        categoryDatabase.removeCategory(id: editingCategoryId)
    }
    
}
