
import UIKit

class DefaultViewControllerFabric: ViewControllersFabric {
    func makeMenuVC(callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable {
        return MainMenuViewController()
    }
    
    func makeChartVC(callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable {
        return ChartViewController()
    }
    
    func makeAddCategoryVC(callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable {
        return CategoryManagementViewController()
    }
    
    func makeEditCategoryVC(category: any IdentifiableCategory, callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable {
        return mock()
    }
    
    func makeAddTransactionVC(callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable {
        return mock()
    }
    
    func makeEditTransactionVC(transaction: any IdentifiableTransaction, callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable {
        return mock()
    }
    
    func makeIntervalSummaryVC(interval: DateInterval, category: (any IdentifiableCategory)?, callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable {
        return mock()
    }
    
    func makeIntervalSelectorVC(for type: IntervalType, callback: ((any Coordinatable) -> (Void))?) -> any Coordinatable {
        return mock()
    }
    
    
}

class mock: UIViewController, Coordinatable {
    var callback: ((any Coordinatable) -> (Void))?
    
    var coordinator: (any Coordinator)?
    
    
}
