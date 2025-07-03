
import UIKit

protocol ViewControllersFactory {
    func makeMenuVC() -> any Coordinatable
    func makeChartVC()  -> any Coordinatable
    func makeCategoryListVC() -> any Coordinatable
    func makeAddCategoryVC()  -> any Coordinatable
    func makeIconPickerVC()  -> any Coordinatable
    func makeEditCategoryVC(categoryId: UUID)  -> any Coordinatable
    func makeAddTransactionVC()  -> any Coordinatable
    func makeEditTransactionVC(transactionId: UUID)  -> any Coordinatable
    func makeIntervalSummaryVC(interval: DateInterval, categoryId: UUID?)  -> any Coordinatable
    func makeIntervalSelectorVC(for type: IntervalType)  -> any Coordinatable
}
