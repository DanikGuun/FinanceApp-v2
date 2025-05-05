
import UIKit

protocol ViewControllersFabric {
    func makeMenuVC(callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable
    func makeChartVC(callback: ((any Coordinatable) -> (Void))?)  -> any Coordinatable
    func makeAddCategoryVC(callback: ((any Coordinatable) -> (Void))?)  -> any Coordinatable
    func makeEditCategoryVC(category: any IdentifiableCategory, callback: ((any Coordinatable) -> (Void))?)  -> any Coordinatable
    func makeAddTransactionVC(callback: ((any Coordinatable) -> (Void))?)  -> any Coordinatable
    func makeEditTransactionVC(transaction: any IdentifiableTransaction, callback: ((any Coordinatable) -> (Void))?)  -> any Coordinatable
    func makeIntervalSummaryVC(interval: DateInterval, category: (any IdentifiableCategory)?, callback: ((any Coordinatable) -> (Void))?)  -> any Coordinatable
    func makeIntervalSelectorVC(for type: IntervalType, callback: ((any Coordinatable) -> (Void))?)  -> any Coordinatable
}
