import Foundation

extension Calendar{
     
    func weeksInMonth(of date: Date) -> [DateInterval]?{
        
        var weeks: [DateInterval] = []
        
        var currentDate = getStartMonthDate(date)
        let countOfWeeks = getCountOfWeeks(inMonth: date)
        
        for _ in 0 ..< countOfWeeks{
            guard let weekInterval = self.dateInterval(of: .weekOfMonth, for: currentDate) else { continue }
            weeks.append(weekInterval)
            
            guard let newDate = self.date(byAdding: .weekOfMonth, value: 1, to: currentDate) else { return nil }
            currentDate = newDate
        }

        return weeks
    }
    
    private func getStartMonthDate(_ date: Date) -> Date {
        let startMonthComps = self.dateComponents([.year, .month], from: date)
        let currentDate = self.date(from: startMonthComps)
        return currentDate ?? Date()
    }
    
    private func getCountOfWeeks(inMonth date: Date) -> Int {
        return self.range(of: .weekOfMonth, in: .month, for: date)?.count ?? 0
    }
    
}
