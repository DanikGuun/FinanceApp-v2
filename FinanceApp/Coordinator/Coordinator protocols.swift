import UIKit

protocol Coordinator: AnyObject {
    var mainVC: UINavigationController! { get }
    var currentVC: (any Coordinatable)? { get }
    
    func showMenuVC(callback: ((any Coordinatable) -> (Void))?)
    func showChartVC(callback: ((any Coordinatable) -> (Void))?)
    func showCategoryListVC(callback: ((any Coordinatable) -> (Void))?)
    func showAddCategoryVC(startType: CategoryType, callback: ((any Coordinatable) -> (Void))?)
    func showEditCategoryVC(categoryId: UUID, callback: ((any Coordinatable) -> (Void))?)
    func showIconPickerVC(delegate: ExtendedIconPickerDelegate?, startColor: UIColor, callback: ((any Coordinatable) -> (Void))?)
    func showAddTransactionVC(startType: CategoryType, callback: ((any Coordinatable) -> (Void))?)
    func showEditTransactionVC(transactionId: UUID, callback: ((any Coordinatable) -> (Void))?)
    func showTransactionListVC(interval: DateInterval, categoryId: UUID, callback: ((any Coordinatable) -> (Void))?)
    func showTransactionListVC(interval: DateInterval, categoryType: CategoryType, callback: ((any Coordinatable) -> (Void))?)
    func showIntervalSelectorVC(for type: IntervalType, callback: ((any Coordinatable) -> (Void))?)
    func popVC()
}

protocol Coordinatable: UIViewController {
    var callback: ((any Coordinatable) -> (Void))? { get set }
    var coordinator: (any Coordinator)? { get set }
}
