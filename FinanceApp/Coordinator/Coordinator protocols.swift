import UIKit

protocol Coordinator: AnyObject {
    var mainVC: UINavigationController { get }
    var currentVC: (any Coordinatable)? { get }
    
    func showMenuVC(callback: ((any Coordinatable) -> (Void))?)
    func showChartVC(callback: ((any Coordinatable) -> (Void))?)
    func showAddCategoryVC(callback: ((any Coordinatable) -> (Void))?)
    func showEditCategoryVC(category: any IdentifiableCategory, callback: ((any Coordinatable) -> (Void))?)
    func showAddTransactionVC(callback: ((any Coordinatable) -> (Void))?)
    func showEditTransactionVC(transaction: any IdentifiableTransaction, callback: ((any Coordinatable) -> (Void))?)
    func showIntervalSummaryVC(interval: DateInterval, category: (any IdentifiableCategory)?, callback: ((any Coordinatable) -> (Void))?)
    func showIntervalSelectorVC(for type: IntervalType, callback: ((any Coordinatable) -> (Void))?)
    func popVC()
}

protocol Coordinatable: UIViewController {
    var callback: ((any Coordinatable) -> (Void))? { get set }
    var coordinator: (any Coordinator)? { get set }
}
