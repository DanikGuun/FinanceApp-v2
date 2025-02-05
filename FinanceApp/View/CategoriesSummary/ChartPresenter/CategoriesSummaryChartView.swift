
import UIKit

class CategoriesSummaryChartView: UIView, CategoriesSummaryWithIntervalPresenter {
    
    var interval: DateInterval {
        get { return dateManager.interval }
        set {
            dateManager.interval = newValue
            intervalHasBeenUpdated()
        }
    }
    
    var intervalType: IntervalType {
        get { return dateManager.intervalType }
        set {
            dateManager.intervalType = newValue
            intervalHasBeenUpdated()
        }
    }
    
    var delegate: (any CategoriesSummaryDelegate)?
    var dataSource: (any CategoriesSummaryDataSource)?

    private var dateManager = IntervalManager()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func requestToOpenIntervalPicker() {
        guard let delegate = delegate as? CategoriesSummaryWithIntervalDelegate else { return }
        delegate.categoriesSummary(self, requestToOpenIntervalPicker: intervalType)
    }
    
    func reloadData() {
        
    }
    
    //MARK: - Helpers

    private func intervalHasBeenUpdated() {
        guard let delegate = self.delegate as? CategoriesSummaryWithIntervalDelegate else { return }
        delegate.categoriesSummary(self, didSelectInterval: interval)
    }
    
}
