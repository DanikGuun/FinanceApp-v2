
import XCTest
@testable import FinanceApp

final class DefaultCoordinatorTests: XCTestCase {
    
    var coordinator: Coordinator!
    
    override func setUp() {
        self.coordinator = DefaultCoordinator(viewControllersFabric: MockFabric())
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func assertCurrentTitle(_ title: String) {
        let currentTitle = coordinator.currentVC?.title ?? ""
        XCTAssertEqual(currentTitle, title)
    }
    
    func testShowMenuVC() {
        coordinator.showMenuVC(callback: nil)
        assertCurrentTitle("menu")
    }
    
    func testShowChartVC() {
        coordinator.showChartVC(callback: nil)
        assertCurrentTitle("chart")
    }
    
    func testShowAddCategoryVC() {
        coordinator.showAddCategoryVC(callback: nil)
        assertCurrentTitle("addCategory")
    }
    
    func testShowEditCategoryVC() {
        let category = DefaultCategory()
        coordinator.showEditCategoryVC(category: category, callback: nil)
        assertCurrentTitle("editCategory")
    }
    
    func testShowAddTransactionVC() {
        coordinator.showAddTransactionVC(callback: nil)
        assertCurrentTitle("addTransaction")
    }
    
    func testShowEditTransactionVC() {
        let transaction = DefaultTransaction()
        coordinator.showEditTransactionVC(transaction: transaction, callback: nil)
        assertCurrentTitle("editTransaction")
    }
    
    func testIntervalSummaryVC() {
        coordinator.showIntervalSummaryVC(interval: DateInterval(), category: nil, callback: nil)
        assertCurrentTitle("intervalSummary")
    }
    
    func testIntervalSelectorVC() {
        coordinator.showIntervalSelectorVC(for: .day,callback: nil)
        assertCurrentTitle("intervalSelector")
    }
    
    func testPopVC() {
        coordinator.showChartVC(callback: nil)
        coordinator.popVC()
        assertCurrentTitle("menu")
    }
    
    func testPopToMenu() {
        coordinator.showChartVC(callback: nil)
        coordinator.showAddCategoryVC(callback: nil)
        coordinator.showAddTransactionVC(callback: nil)
        coordinator.showMenuVC(callback: nil)
        let exp = expectation(description: "exp")
        let _ = XCTWaiter.wait(for: [exp], timeout: 1)
        assertCurrentTitle("menu")
    }
    
    func testMainVCCoordinator() {
        XCTAssertNotNil(coordinator.currentVC?.coordinator)
    }
    
}

class MockFabric: ViewControllersFabricProtcol {
    func makeMenuVC(callback: ((any FinanceApp.Coordinatable) -> (Void))?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "menu")
        return vc
    }
    
    func makeChartVC(callback: ((any FinanceApp.Coordinatable) -> (Void))?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "chart")
        return vc
    }
    
    func makeAddCategoryVC(callback: ((any FinanceApp.Coordinatable) -> (Void))?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "addCategory")
        return vc
    }
    
    func makeEditCategoryVC(category: any FinanceApp.IdentifiableCategory, callback: ((any FinanceApp.Coordinatable) -> (Void))?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "editCategory")
        return vc
    }
    
    func makeAddTransactionVC(callback: ((any FinanceApp.Coordinatable) -> (Void))?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "addTransaction")
        return vc
    }
    
    func makeEditTransactionVC(transaction: any FinanceApp.IdentifiableTransaction, callback: ((any FinanceApp.Coordinatable) -> (Void))?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "editTransaction")
        return vc
    }
    
    func makeIntervalSummaryVC(interval: DateInterval, category: (any FinanceApp.IdentifiableCategory)?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "intervalSummary")
        return vc
    }
    
    func makeIntervalSelectorVC(for type: FinanceApp.IntervalType, callback: ((any FinanceApp.Coordinatable) -> (Void))?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "intervalSelector")
        return vc
    }
    
}

class MockController: UIViewController, Coordinatable {
    var callback: ((any FinanceApp.Coordinatable) -> (Void))?
    
    weak var coordinator: (any FinanceApp.Coordinator)?
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
