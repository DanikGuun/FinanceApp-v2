
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
    
    func getInitialCategory() -> (any Category)? {
        let category = categoryDatabase.getCategory(id: editingCategoryId)
        return DefaultCategory(name: "Категория", color: .cyan)
    }
    
    func getPerformButtonTitle() -> String {
        return "Сохранить"
    }
    
    func getPerformButtonImage() -> UIImage? {
        let image = UIImage(systemName: "checkmark")
        return image
    }
    
    func getAdditionalBarItem() -> UIBarButtonItem? {
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
