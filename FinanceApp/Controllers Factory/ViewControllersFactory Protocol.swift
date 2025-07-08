
import UIKit

protocol ViewControllersFactory {
    func makeMenuVC(coordinator: Coordinator) -> any Coordinatable
    func makeChartVC()  -> any Coordinatable
    func makeCategoryListVC() -> any Coordinatable
    func makeAddCategoryVC(startType: CategoryType)  -> any Coordinatable
    func makeIconPickerVC(startColor: UIColor)  -> any Coordinatable
    func makeEditCategoryVC(categoryId: UUID)  -> any Coordinatable
    func makeAddTransactionVC(startType: CategoryType)  -> any Coordinatable
    func makeEditTransactionVC(transactionId: UUID)  -> any Coordinatable
    func makeTransactionListVC(interval: DateInterval, categoryId: UUID)  -> any Coordinatable
    func makeTransactionListVC(interval: DateInterval, categoryType: CategoryType)  -> any Coordinatable
    func makeIntervalSelectorVC(for type: IntervalType)  -> any Coordinatable
}
