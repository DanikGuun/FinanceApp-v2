
import UIKit

protocol ViewControllersFactory {
    func makeMenuVC() -> any Coordinatable
    func makeChartVC()  -> any Coordinatable
    func makeAddCategoryVC()  -> any Coordinatable
    func makeEditCategoryVC(category: any IdentifiableCategory)  -> any Coordinatable
    func makeAddTransactionVC()  -> any Coordinatable
    func makeEditTransactionVC(transaction: any IdentifiableTransaction)  -> any Coordinatable
    func makeIntervalSummaryVC(interval: DateInterval, category: (any IdentifiableCategory)?)  -> any Coordinatable
    func makeIntervalSelectorVC(for type: IntervalType)  -> any Coordinatable
}
