
import UIKit

class DefaultViewControllerFactory: ViewControllersFactory {
    
    let database: DatabaseFacade
    
    init(database: DatabaseFacade) {
        self.database = database
    }
    
    func makeMenuVC() -> any Coordinatable {
        return MainMenuViewController()
    }
    
    func makeChartVC() -> any Coordinatable {
        let controller = ChartViewController()
        return controller
    }
    
    func makeAddCategoryVC() -> any Coordinatable {
        let model = AddCategoryModel(categoryDatabase: database, iconProvider: database, colorProvider: database)
        return CategoryManagementViewController(model: model)
    }
    
    func makeEditCategoryVC(categoryId: UUID) -> any Coordinatable {
        return mock()
    }
    
    func makeAddTransactionVC() -> any Coordinatable {
        return mock()
    }
    
    func makeEditTransactionVC(transactionId: UUID) -> any Coordinatable {
        return mock()
    }
    
    func makeIntervalSummaryVC(interval: DateInterval, categoryId: UUID?) -> any Coordinatable {
        return mock()
    }
    
    func makeIntervalSelectorVC(for type: IntervalType) -> any Coordinatable {
        return mock()
    }
    
    
}

class mock: UIViewController, Coordinatable {
    var callback: ((any Coordinatable) -> (Void))?
    
    var coordinator: (any Coordinator)?
    
    
}
