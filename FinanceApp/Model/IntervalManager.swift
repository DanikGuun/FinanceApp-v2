
import Foundation

class IntervalManager {
    
    var interval: DateInterval {
        get{ return getCurrentInterval() }
        set{ setInterval(newValue) }
    }
    var intervalType: IntervalType = .day
    var calendar = Calendar.current
    
    private var referenceDate = Date()
    
    func increment() {
        self.interval = incremented()
    }
    
    func incremented() -> DateInterval {
        if intervalType != .custom(interval: DateInterval()) {
            let incrmenetedDate = calendar.date(byAdding: intervalType.calendarComponent() ?? .day, value: 1, to: referenceDate) ?? Date()
            return getInterval(for: incrmenetedDate)
        }
        return interval
    }
    
    func decrement() {
        self.interval = decremented()
    }
    
    func decremented() -> DateInterval {
        if intervalType != .custom(interval: DateInterval()) {
            let decrmenetedDate = calendar.date(byAdding: intervalType.calendarComponent() ?? .day, value: -1, to: referenceDate) ?? Date()
            return getInterval(for: decrmenetedDate)
        }
        return interval
    }

    func reload() {
        referenceDate = Date()
    }
    
    private func getCurrentInterval() -> DateInterval {
        return getInterval(for: referenceDate)
    }
    
    private func getInterval(for referenceDate: Date) -> DateInterval {
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

enum IntervalType: Equatable {
    
    case day
    case week
    case month
    case year
    case custom(interval: DateInterval = DateInterval())
    
    func calendarComponent() -> Calendar.Component? {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekOfYear
        case .month:
            return .month
        case .year:
            return .year
        case .custom:
            return nil
        }
    }
    
    static func allCases() -> [IntervalType] {
        return [.day, .week, .month, .year, .custom()]
    }
    
    var description: String {
        switch self {
        case .day:
            return "День"
        case .week:
            return "Неделя"
        case .month:
            return "Месяц"
        case .year:
            return "Год"
        case .custom(_):
            return "Пероид"
        }
    }
    
}
