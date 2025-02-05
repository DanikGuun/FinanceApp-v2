

import XCTest
import Foundation
@testable import FinanceApp

final class CategoriesSummaryChartViewTests: XCTestCase {
    
    var delegate: MockDelegate!
    var chartView: CategoriesSummaryChartView!

    override func setUp() {
        super.setUp()
        delegate = MockDelegate()
        chartView = CategoriesSummaryChartView()
        chartView.delegate = delegate
    }
    
    override func tearDown() {
        super.tearDown()
        delegate = nil
        chartView = nil
    }
    
    func testRequestToOpenIntervalPicker() {
        chartView.intervalType = .day
        chartView.requestToOpenIntervalPicker()
        XCTAssertEqual(delegate.lastRequestedCalendarType, .day)
        chartView.intervalType = .week
        chartView.requestToOpenIntervalPicker()
        XCTAssertEqual(delegate.lastRequestedCalendarType, .week)
        chartView.intervalType = .month
        chartView.requestToOpenIntervalPicker()
        XCTAssertEqual(delegate.lastRequestedCalendarType, .month)
        chartView.intervalType = .year
        chartView.requestToOpenIntervalPicker()
        XCTAssertEqual(delegate.lastRequestedCalendarType, .year)
        
        let interval = DateInterval(start: Date(timeIntervalSince1970: 0), duration: 0)
        chartView.intervalType = .custom(interval: interval)
        chartView.requestToOpenIntervalPicker()
        XCTAssertEqual(delegate.lastRequestedCalendarType, .custom(interval: interval))
    }
    
    func testIntervalChange() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ru_RU")
        chartView.calendar = calendar
        
        let dayStartDate = Date(timeIntervalSince1970: 946_674_000)
        let dayEndDate = Date(timeIntervalSince1970: 946_760_400)
        let dayInterval = DateInterval(start: dayStartDate, end: dayEndDate)
        chartView.interval = dayInterval
        
        chartView.intervalType = .day
        XCTAssertEqual(chartView.interval, dayInterval)
        XCTAssertEqual(delegate.lastSelectedInterval, dayInterval)
        
        let weekStartDate = Date(timeIntervalSince1970: 946_242_000)
        let weekEndDate = Date(timeIntervalSince1970: 946_846_800)
        let weekInterval = DateInterval(start: weekStartDate, end: weekEndDate)
        chartView.intervalType = .week
        XCTAssertEqual(chartView.interval, weekInterval)
        XCTAssertEqual(delegate.lastSelectedInterval!, weekInterval)
        
        let monthStartDate = Date(timeIntervalSince1970: 946_674_000)
        let monthEndDate = Date(timeIntervalSince1970: 949_352_400)
        let monthInterval = DateInterval(start: monthStartDate, end: monthEndDate)
        chartView.intervalType = .month
        XCTAssertEqual(chartView.interval, monthInterval)
        XCTAssertEqual(delegate.lastSelectedInterval!, monthInterval)
        
        let yearStartDate = Date(timeIntervalSince1970: 946_674_000)
        let yearEndDate = Date(timeIntervalSince1970: 978_296_400)
        let yearInterval = DateInterval(start: yearStartDate, end: yearEndDate)
        chartView.intervalType = .year
        XCTAssertEqual(chartView.interval, yearInterval)
        XCTAssertEqual(delegate.lastSelectedInterval!, yearInterval)
        
        let customStartDate = Date(timeIntervalSince1970: 715_513_583)
        let customEndDate = Date(timeIntervalSince1970: 715_600_643)
        let customInterval = DateInterval(start: customStartDate, end: customEndDate)
        chartView.intervalType = .custom(interval: customInterval)
        XCTAssertEqual(chartView.interval, customInterval)
        XCTAssertEqual(delegate.lastSelectedInterval!, customInterval)
    }
    
}

class MockDelegate: CategoriesSummaryWithIntervalDelegate {
    
    var lastSelectedInterval: DateInterval?
    var lastRequestedCalendarType: IntervalType?
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, didSelectInterval interval: DateInterval) {
        lastSelectedInterval = interval
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, requestToOpenIntervalPicker type: IntervalType) {
        lastRequestedCalendarType = type
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem) {
        
    }
    
}
