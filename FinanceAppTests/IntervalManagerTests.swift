
import XCTest
@testable import FinanceApp

final class IntervalManagerTests: XCTestCase {
    
    var intervalManager: IntervalManager!
    
    override func setUp() {
        super.setUp()
        intervalManager = IntervalManager()
    }
    
    override func tearDown() {
        super.tearDown()
        intervalManager = nil
    }
    
    func testIntervalChange() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        
        let dayStartDate = Date(timeIntervalSince1970: 946_674_000)
        let dayEndDate = Date(timeIntervalSince1970: 946_760_400)
        let dayInterval = DateInterval(start: dayStartDate, end: dayEndDate)
        intervalManager.interval = dayInterval
        
        intervalManager.intervalType = .day
        XCTAssertEqual(intervalManager.interval, dayInterval)
        
        let weekStartDate = Date(timeIntervalSince1970: 946_242_000)
        let weekEndDate = Date(timeIntervalSince1970: 946_846_800)
        let weekInterval = DateInterval(start: weekStartDate, end: weekEndDate)
        intervalManager.intervalType = .week
        XCTAssertEqual(intervalManager.interval, weekInterval)
        
        let monthStartDate = Date(timeIntervalSince1970: 946_674_000)
        let monthEndDate = Date(timeIntervalSince1970: 949_352_400)
        let monthInterval = DateInterval(start: monthStartDate, end: monthEndDate)
        intervalManager.intervalType = .month
        XCTAssertEqual(intervalManager.interval, monthInterval)
        
        let yearStartDate = Date(timeIntervalSince1970: 946_674_000)
        let yearEndDate = Date(timeIntervalSince1970: 978_296_400)
        let yearInterval = DateInterval(start: yearStartDate, end: yearEndDate)
        intervalManager.intervalType = .year
        XCTAssertEqual(intervalManager.interval, yearInterval)
        
        let customStartDate = Date(timeIntervalSince1970: 715_513_583)
        let customEndDate = Date(timeIntervalSince1970: 715_600_643)
        let customInterval = DateInterval(start: customStartDate, end: customEndDate)
        intervalManager.intervalType = .custom(interval: customInterval)
        XCTAssertEqual(intervalManager.interval, customInterval)
    }
    
}
