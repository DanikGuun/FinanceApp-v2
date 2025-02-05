
import UIKit

class CategoriesSummaryChartView: UIView, CategoriesSummaryWithIntervalPresenter {
    
    var interval: DateInterval {
        get{
            return getCurrentInterval()
        }
        set{
            setInterval(newValue)
        }
    }
    
    var intervalType: IntervalType = .day { didSet { intervalTypeHasBeenUpdated() } }
    var calendar = Calendar.current
    
    var delegate: (any CategoriesSummaryDelegate)?
    var dataSource: (any CategoriesSummaryDataSource)?
    
    private var referenceDate = Date()
    
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
    private func getCurrentInterval() -> DateInterval {
        switch intervalType {
        case .custom(let interval):
            return interval
        default:
            return calendar.dateInterval(of: intervalType.calendarComponent() ?? .day, for: referenceDate) ?? DateInterval()
        }
    }
    
    private func setInterval(_ interval: DateInterval) {
        
        var newInterval: DateInterval
        switch intervalType {
        case .custom(_):
            self.intervalType = .custom(interval: interval)
            newInterval = interval
        default:
            self.referenceDate = interval.start
            newInterval = self.interval
        }
        
        if let delegate = self.delegate as? CategoriesSummaryWithIntervalDelegate {
            delegate.categoriesSummary(self, didSelectInterval: newInterval)
        }
        
    }
    
    private func intervalTypeHasBeenUpdated() {
        if let delegate = self.delegate as? CategoriesSummaryWithIntervalDelegate {
            delegate.categoriesSummary(self, didSelectInterval: getCurrentInterval())
        }
    }
    
}
