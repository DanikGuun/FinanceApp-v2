
import UIKit

public class AddTransactionModel: BaseTransactionManagmentModel {

    override func perform(transaction: any Transaction) {
        transactionDatabase.addTransaction(transaction)
    }
    
    override func getPerformButtonTitle() -> String {
        return "Добавить"
    }
    
    override func getPerformButtonImage() -> UIImage? {
        return UIImage(systemName: "plus.square")
    }
    
}

