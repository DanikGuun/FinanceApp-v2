import Foundation

extension Calendar{
    
    func weekInMonth(of date: Date) -> [DateInterval]?{
        
        var weeks: [DateInterval] = []
        
        let startMonthComps = self.dateComponents([.year, .month], from: date)
        guard var currentDate = self.date(from: startMonthComps) else { return nil }
        
        guard let countOfWeeks = self.range(of: .weekOfMonth, in: .month, for: date) else { return nil }
        
        for _ in countOfWeeks{
            guard let weekInterval = self.dateInterval(of: .weekOfMonth, for: currentDate) else { continue }
            weeks.append(weekInterval)
            
            guard let newDate = self.date(byAdding: .weekOfMonth, value: 1, to: currentDate) else { return nil }
            currentDate = newDate
        }

        return weeks
    }
    
}
