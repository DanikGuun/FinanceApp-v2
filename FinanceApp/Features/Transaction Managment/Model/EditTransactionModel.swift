
import UIKit

public class EditTransactionModel: BaseTransactionManagmentModel {
    
    private var editingTransactionId: UUID
    
    convenience init(editingTransactionId: UUID, transactionDatabase: any TransactionDatabase, categoryDatabase: any CategoryDatabase, iconProvider: any IconProvider) {
        self.init(transactionDatabase: transactionDatabase, categoryDatabase: categoryDatabase, iconProvider: iconProvider)
        self.editingTransactionId = editingTransactionId
    }
    
    override init(transactionDatabase: any TransactionDatabase, categoryDatabase: any CategoryDatabase, iconProvider: any IconProvider) {
        self.editingTransactionId = UUID()
        super.init(transactionDatabase: transactionDatabase, categoryDatabase: categoryDatabase, iconProvider: iconProvider)
    }
    
    override func perform(transaction: any Transaction) {
        transactionDatabase.updateTransaction(id: editingTransactionId, with: transaction)
    }
    
    override func getAdditionalBarItem(additionalAction: (() -> ())?) -> UIBarButtonItem? {
        let alertController = UIAlertController(title: "Удаление операции", message: "Вы уверены, что хотите удалить операцию?", preferredStyle: .actionSheet)
        let undoAction = UIAlertAction(title: "Отмена", style: .cancel)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            additionalAction?()
            self?.removeTransaction()
        }
        alertController.addAction(undoAction)
        alertController.addAction(deleteAction)
        
        let barItem = UIBarButtonItem(image: UIImage(systemName: "trash"), primaryAction: UIAction(handler: { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let rootVC = windowScene!.windows.first?.rootViewController
            rootVC?.present(alertController, animated: true)
        }))
        barItem.tintColor = .systemRed
        return barItem
    }
    
    func removeTransaction() {
        transactionDatabase.removeTransaction(id: editingTransactionId)
    }
    
    override func getPerformButtonTitle() -> String {
        return "Сохранить"
    }
    
    override func getPerformButtonImage() -> UIImage? {
        return UIImage(systemName: "checkmark.square")
    }
    
}
