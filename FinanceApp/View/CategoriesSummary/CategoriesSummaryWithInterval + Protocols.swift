
import Foundation

protocol CategoriesSummaryWithIntervalPresenter: CategoriesSummaryPresenter{
    var interval: DateInterval { get set }
    var intervalType: IntervalType { get set }
}

protocol CategoriesSummaryWithIntervalDelegate: CategoriesSummaryDelegate {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, requestToOpenIntervalPicker type: IntervalType)
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, didSelectInterval interval: DateInterval)
}

extension CategoriesSummaryWithIntervalDelegate {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, requestToOpenIntervalPicker type: IntervalType) {}
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, didSelectInterval interval: DateInterval) {}
}
