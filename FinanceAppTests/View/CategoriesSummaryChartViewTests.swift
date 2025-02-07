

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
    
    func testRequestToOpenIntervalSummary() {
        let start = Date(timeIntervalSince1970: 1530)
        let end = Date(timeIntervalSince1970: 15330)
        let interval = DateInterval(start: start, end: end)
        
        chartView.intervalType = .custom(interval: interval)
        chartView.requestToOpenIntervalSummary()
        
        XCTAssertEqual(delegate.lastRequestedInterval, interval)
        XCTAssertEqual(delegate.lastRequestedCategory, nil)
    }
    
}

class MockDelegate: CategoriesSummaryWithIntervalDelegate {
    
    var lastSelectedInterval: DateInterval?
    var lastRequestedCalendarType: IntervalType?
    var lastRequestedInterval: DateInterval?
    var lastRequestedCategory: CategoriesSummaryItem?
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, didSelectInterval interval: DateInterval) {
        lastSelectedInterval = interval
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, requestToOpenIntervalPicker type: IntervalType) {
        lastRequestedCalendarType = type
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem?) {
        lastRequestedInterval = interval
        lastRequestedCategory = category
    }
    
}
