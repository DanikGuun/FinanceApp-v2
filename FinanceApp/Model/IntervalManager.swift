
import Foundation

class IntervalManager {
    
    var interval: DateInterval {
        get{ return getCurrentInterval() }
        set{  setInterval(newValue) }
    }
    var intervalType: IntervalType = .day
    var calendar = Calendar.current
    
    private var referenceDate = Date()
    
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
