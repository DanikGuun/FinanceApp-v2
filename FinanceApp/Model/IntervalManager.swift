
import Foundation

class IntervalManager {
    
    var interval: DateInterval {
        get{ return getCurrentInterval() }
        set{  setInterval(newValue) }
    }
    var intervalType: IntervalType = .day
    var calendar = Calendar.current
    
    private var referenceDate = Date()
    
    @discardableResult func increment() -> DateInterval {
        if intervalType != .custom(interval: DateInterval()) {
            referenceDate = calendar.date(byAdding: intervalType.calendarComponent() ?? .day, value: 1, to: referenceDate) ?? Date()
        }
        return interval
    }
    
    @discardableResult func decrement() -> DateInterval {
        if intervalType != .custom(interval: DateInterval()) {
            referenceDate = calendar.date(byAdding: intervalType.calendarComponent() ?? .day, value: -1, to: referenceDate) ?? Date()
        }
        return interval
    }
    
    private func getCurrentInterval() -> DateInterval {
        switch intervalType {
        case .custom(let interval):
            return interval
        default:
            return calendar.dateInterval(of: intervalType.calendarComponent() ?? .day, for: referenceDate) ?? DateInterval()
        }
    }
    
    private func setInterval(_ interval: DateInterval) {
        switch intervalType {
        case .custom(_):
            self.intervalType = .custom(interval: interval)
        default:
            self.referenceDate = interval.start
        }
    }

}
