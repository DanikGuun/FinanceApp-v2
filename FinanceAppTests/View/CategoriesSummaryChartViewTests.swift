

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
    
    func testActiveChartItemsFetching() {
        let item1 = ChartCollectionItem()
        let id = item1.id
        let item2 = ChartCollectionItem()
        let item3 = ChartCollectionItem()
        
        var activeItems = ActiveChartItems()
        activeItems.first = item1
        activeItems.second = item2
        activeItems.third = item3
        
        let itemByID = activeItems.item(id: id)
        XCTAssertEqual(itemByID, item1)
    }
    
    func testActiveChartItemsAppending() {
        let item1 = ChartCollectionItem()
        let item2 = ChartCollectionItem()
        let item3 = ChartCollectionItem()
        let item4 = ChartCollectionItem()
        let item5 = ChartCollectionItem()
        var activeItems = ActiveChartItems()
        activeItems.first = item2
        activeItems.second = item3
        activeItems.third = item4
        
        activeItems.appendRight(item5)
        XCTAssertEqual(activeItems.first, item3)
        XCTAssertEqual(activeItems.second, item4)
        XCTAssertEqual(activeItems.third, item5)
        
        activeItems.appendLeft(item1)
        XCTAssertEqual(activeItems.first, item1)
        XCTAssertEqual(activeItems.second, item3)
        XCTAssertEqual(activeItems.third, item4)
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

class MockDataSource: CategoriesSummaryDataSource {
    
    let categories: [CategoryItemWithDate]
    
    init(categories: [CategoryItemWithDate]) {
        self.categories = categories
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, getSummaryItemsFor interval: DateInterval) -> [CategoriesSummaryItem] {
        return categories.filter { interval.contains($0.date) }.map { $0.item }
    }
    
    
    
}

struct CategoryItemWithDate {
    var date = Date()
    var item: CategoriesSummaryItem
}
