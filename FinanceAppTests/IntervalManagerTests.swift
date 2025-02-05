
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
    
    func intervalShiftTest(start: Double, end: Double, expectedStart: Double, expectedEnd: Double, intervalType: IntervalType, isIncrement: Bool) {
        let startDate = Date(timeIntervalSince1970: start)
        let endDate = Date(timeIntervalSince1970: end)
        let interval = DateInterval(start: startDate, end: endDate)
        let expectedStartDate = Date(timeIntervalSince1970: expectedStart)
        let expectedEndDate = Date(timeIntervalSince1970: expectedEnd)
        let expectedInterval = DateInterval(start: expectedStartDate, end: expectedEndDate)
        
        intervalManager.intervalType = intervalType
        intervalManager.interval = interval
        if isIncrement { intervalManager.increment() }
        else { intervalManager.decrement() }
        
        XCTAssertEqual(intervalManager.interval, expectedInterval)
    }
    
    func testDayIncrement() {
        intervalShiftTest(start: 946_674_000, end: 946_760_400,
                          expectedStart: 946_760_400, expectedEnd: 946_846_800,
                          intervalType: .day, isIncrement: true)
    }
    
    func testDayDecrement() {
        intervalShiftTest(start: 946_760_400, end: 946_846_800,
                          expectedStart: 946_674_000, expectedEnd: 946_760_400,
                          intervalType: .day, isIncrement: false)
    }
    
    func testWeekIncrement() {
        intervalShiftTest(start: 948_056_400, end: 948_661_200,
                          expectedStart: 948_661_200, expectedEnd: 949_266_000,
                          intervalType: .week, isIncrement: true)
    }
    
    func testWeekDecrement() {
        intervalShiftTest(start: 948_661_200, end: 949_266_000,
                          expectedStart: 948_056_400, expectedEnd: 948_661_200,
                          intervalType: .week, isIncrement: false)
    }
    
    func testMonthIncrement() {
        intervalShiftTest(start: 946_674_000, end: 949_352_400,
                          expectedStart: 949_352_400, expectedEnd: 951_858_000,
                          intervalType: .month, isIncrement: true)
    }
    
    func testMonthDecrement() {
        intervalShiftTest(start: 949_352_400, end: 951_858_000,
                          expectedStart: 946_674_000, expectedEnd: 949_352_400,
                          intervalType: .month, isIncrement: false)
    }
    
    func testYearIncrement() {
        intervalShiftTest(start: 946_674_000, end: 978_296_400,
                          expectedStart: 978_296_400, expectedEnd: 1_009_832_400,
                          intervalType: .year, isIncrement: true)
    }
    
    func testYearDecrement() {
        intervalShiftTest(start: 978_296_400, end: 1_009_832_400,
                          expectedStart: 946_674_000, expectedEnd: 978_296_400,
                          intervalType: .year, isIncrement: false)
    }
    
    func testCustomIntervalIncrement() {
        intervalShiftTest(start: 978_296_400, end: 1_009_832_400,
                          expectedStart: 978_296_400, expectedEnd: 1_009_832_400,
                          intervalType: .custom(interval: DateInterval()), isIncrement: false)
    }
    
    func testCustomIntervalDecrement() {
        intervalShiftTest(start: 978_296_400, end: 1_009_832_400,
                          expectedStart: 978_296_400, expectedEnd: 1_009_832_400,
                          intervalType: .custom(interval: DateInterval()), isIncrement: true)
    }
    
}
