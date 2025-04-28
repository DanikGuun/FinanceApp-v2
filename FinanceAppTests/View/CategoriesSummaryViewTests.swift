

import XCTest
@testable import FinanceApp

fileprivate final class CategoriesSummaryViewTests: XCTestCase {
    
    var delegate: MockDelegate!
    var dataSource: MockDataSource!
    var categoriesSummaryView: CategorySummaryView!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        try super.setUpWithError()
    }
    
    override func setUp() {
        super.setUp()
        self.delegate = MockDelegate()
        self.dataSource = MockDataSource()
        self.categoriesSummaryView = CategorySummaryView()
        categoriesSummaryView.delegate = delegate
        categoriesSummaryView.dataSource = dataSource
    }
    
    override func tearDownWithError() throws {
        continueAfterFailure = false
        try super.tearDownWithError()
    }
    
    override func tearDown() {
        super.tearDown()
        delegate = nil
        dataSource = nil
        categoriesSummaryView = nil
    }
    
    func testRequestToOpenCategoriesSummary() {
        let id = UUID()
        let interval = DateInterval(start: Date(timeIntervalSince1970: 12), end: Date(timeIntervalSince1970: 532))
        var item = CategoriesSummaryItem()
        item.id = id
        dataSource.categories = [item]
        
        categoriesSummaryView.interval = interval
        categoriesSummaryView.requestToOpenIntervalSummary(for: item)
        
        XCTAssertEqual(delegate.lastRequestedCategory, item)
        XCTAssertEqual(delegate.lasrRequestedInterval, interval)
    }
    
    func testDataSourceInterval() {
        let interval = DateInterval(start: Date(timeIntervalSince1970: 12), end: Date(timeIntervalSince1970: 532))
        
        categoriesSummaryView.interval = interval
        categoriesSummaryView.reloadData()
        
        XCTAssertEqual(dataSource.lastRequestesDateInterval, interval)
    }
    
}

fileprivate class MockDelegate: CategoriesSummaryDelegate {
    
    var lastRequestedCategory: CategoriesSummaryItem?
    var lasrRequestedInterval: DateInterval?
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem?) {
        self.lastRequestedCategory = category
        self.lasrRequestedInterval = interval
    }
    
}

fileprivate class MockDataSource: CategoriesSummaryDataSource {
    
    var categories: [CategoriesSummaryItem]
    var lastRequestesDateInterval: DateInterval?
    
    init(categories: [CategoriesSummaryItem] = []) {
        self.categories = categories
    }
    
    func categoriesSummary(_ presenter: any CategoriesSummaryPresenter, getSummaryItemsFor interval: DateInterval) -> [CategoriesSummaryItem] {
        self.lastRequestesDateInterval = interval
        return categories
    }
    
}
