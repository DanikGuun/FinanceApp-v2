
import XCTest
@testable import FinanceApp

final class DefaultCoordinatorTests: XCTestCase {
    
    var coordinator: DefaultCoordinator!
    var window: UIWindow!
    
    override func setUp() {
        
        window = UIWindow(frame: .zero)
        window.makeKeyAndVisible()
        
        coordinator = DefaultCoordinator(window: window, viewControllersFabric: MockFabric())
        coordinator.needAnimate = false
        super.setUp()
    }
    
    override func tearDown() {
        coordinator = nil
        window = nil
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
    
    func testShowCategoryListVC() {
        coordinator.showCategoryListVC(callback: nil)
        assertCurrentTitle("categoryList")
    }
    
    func testShowAddCategoryVC() {
        coordinator.showAddCategoryVC(callback: nil)
        assertCurrentTitle("addCategory")
    }
    
    func testShowEditCategoryVC() {
        let category = DefaultCategory()
        coordinator.showEditCategoryVC(categoryId: category.id, callback: nil)
        assertCurrentTitle("editCategory")
    }
    
    func testShowIconPickerVC() {
        coordinator.showIconPickerVC(delegate: nil, startColor: .black, callback: nil)
        assertCurrentTitle("iconPicker")
    }
    
    func testShowAddTransactionVC() {
        coordinator.showAddTransactionVC(callback: nil)
        assertCurrentTitle("addTransaction")
    }
    
    func testShowEditTransactionVC() {
        let transaction = DefaultTransaction()
        coordinator.showEditTransactionVC(transactionId: transaction.id, callback: nil)
        assertCurrentTitle("editTransaction")
    }
    
    func testIntervalSummaryVC() {
        coordinator.showIntervalSummaryVC(interval: DateInterval(), categoryId: nil, callback: nil)
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
        assertCurrentTitle("menu")
    }
    
    func testMainVCCoordinator() {
        XCTAssertNotNil(coordinator.currentVC?.coordinator)
    }
    
    func testNewControllerCoordinator() {
        coordinator.showChartVC(callback: nil)
        XCTAssertNotNil(coordinator.currentVC?.coordinator)
    }
    
    func testCallbacks() {
        let category = DefaultCategory()
        let transaction = DefaultTransaction()
        var callbackTitle = ""
        let callback = { (vc: any Coordinatable) in
            callbackTitle = vc.title ?? ""
        }
        coordinator.showChartVC(callback: callback)
        XCTAssertEqual(callbackTitle, coordinator.currentVC?.title)
        coordinator.showAddCategoryVC(callback: callback)
        XCTAssertEqual(callbackTitle, coordinator.currentVC?.title)
        coordinator.showEditCategoryVC(categoryId: category.id, callback: callback)
        XCTAssertEqual(callbackTitle, coordinator.currentVC?.title)
        coordinator.showAddTransactionVC(callback: callback)
        XCTAssertEqual(callbackTitle, coordinator.currentVC?.title)
        coordinator.showEditTransactionVC(transactionId: transaction.id, callback: callback)
        XCTAssertEqual(callbackTitle, coordinator.currentVC?.title)
        coordinator.showIntervalSummaryVC(interval: DateInterval(), categoryId: category.id, callback: callback)
        XCTAssertEqual(callbackTitle, coordinator.currentVC?.title)
        coordinator.showIntervalSelectorVC(for: .day, callback: callback)
        XCTAssertEqual(callbackTitle, coordinator.currentVC?.title)
        coordinator.showCategoryListVC(callback: callback)
        XCTAssertEqual(callbackTitle, coordinator.currentVC?.title)
        
    }
    
    
}

class MockFabric: ViewControllersFactory {
    
    func makeMenuVC() -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "menu")
        return vc
    }
    
    func makeChartVC() -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "chart")
        return vc
    }
    
    func makeCategoryListVC() -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "categoryList")
        return vc
    }
    
    func makeAddCategoryVC() -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "addCategory")
        return vc
    }
    
    func makeEditCategoryVC(categoryId: UUID) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "editCategory")
        return vc
    }
    
    func makeIconPickerVC(startColor: UIColor) -> any Coordinatable {
        let vc = MockController(title: "iconPicker")
        return vc
    }
    
    func makeAddTransactionVC() -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "addTransaction")
        return vc
    }
    
    func makeEditTransactionVC(transactionId: UUID) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "editTransaction")
        return vc
    }
    
    func makeIntervalSummaryVC(interval: DateInterval, categoryId: UUID?) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "intervalSummary")
        return vc
    }
    
    func makeIntervalSelectorVC(for type: FinanceApp.IntervalType) -> any FinanceApp.Coordinatable {
        let vc = MockController(title: "intervalSelector")
        return vc
    }
    
}

class MockController: UIViewController, Coordinatable {
    var callback: ((any FinanceApp.Coordinatable) -> (Void))? { didSet { callback?(self) } }
    
    weak var coordinator: (any FinanceApp.Coordinator)?
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MockWindowScene: UIWindowScene {
    var _windows: [UIWindow] = []
    override var windows: [UIWindow] { _windows }
}
