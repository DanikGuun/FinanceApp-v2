
import UIKit

class DefaultViewControllerFactory: ViewControllersFactory {
    func makeMenuVC() -> any Coordinatable {
        return MainMenuViewController()
    }
    
    func makeChartVC() -> any Coordinatable {
        let controller = ChartViewController()
        return controller
    }
    
    func makeAddCategoryVC() -> any Coordinatable {
        let model = EditCategoryModel(editingCategoryId: UUID(), categoryDatabase: CategoryDatabaseFactory.getDatabase())
        return CategoryManagementViewController(model: model)
    }
    
    func makeEditCategoryVC(category: any IdentifiableCategory) -> any Coordinatable {
        return mock()
    }
    
    func makeAddTransactionVC() -> any Coordinatable {
        return mock()
    }
    
    func makeEditTransactionVC(transaction: any IdentifiableTransaction) -> any Coordinatable {
        return mock()
    }
    
    func makeIntervalSummaryVC(interval: DateInterval, category: (any IdentifiableCategory)?) -> any Coordinatable {
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
