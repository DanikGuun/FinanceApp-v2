
import UIKit

class DefaultViewControllerFactory: ViewControllersFactory {

    let database: DatabaseFacade
    
    init(database: DatabaseFacade) {
        self.database = database
    }
    
    func makeMenuVC(coordinator: Coordinator) -> any Coordinatable {
        let model = BaseMainMenuModel(coordinator: coordinator)
        return MainMenuViewController(model: model)
    }
    
    func makeChartVC() -> any Coordinatable {
        let model = BaseChartModel(database: database)
        return ChartViewController(model: model)
    }
    
    func makeCategoryListVC() -> any Coordinatable {
        let model = BaseCategoryListModel(categoryDatabase: database, iconProvider: database)
        return CategoryListController(model: model)
    }
    
    func makeAddCategoryVC(startType: CategoryType) -> any Coordinatable {
        let model = AddCategoryModel(categoryDatabase: database, iconProvider: database, colorProvider: database)
        let vc = CategoryManagementViewController(model: model)
        vc.startType = startType
        return vc
    }
    
    func makeEditCategoryVC(categoryId: UUID) -> any Coordinatable {
        let model = EditCategoryModel(editingCategoryId: categoryId, categoryDatabase: database, iconProvider: database, colorProvider: database)
        return CategoryManagementViewController(model: model)
    }
    
    func makeIconPickerVC(startColor: UIColor) -> any Coordinatable {
        let model = BaseIconPickerModel(iconProvider: database, startColor: startColor)
        return IconPickerViewController(model: model)
    }
    
    func makeAddTransactionVC(startType: CategoryType) -> any Coordinatable {
        let model = AddTransactionModel(transactionDatabase: database, categoryDatabase: database, iconProvider: database)
        let vc = TransactionManagmentViewController(model: model)
        vc.startType = startType
        return vc
    }
    
    func makeEditTransactionVC(transactionId: UUID) -> any Coordinatable {
        let model = EditTransactionModel(editingTransactionId: transactionId, transactionDatabase: database, categoryDatabase: database, iconProvider: database)
        return TransactionManagmentViewController(model: model)
    }
    
    func makeTransactionListVC(interval: DateInterval, categoryId: UUID) -> any Coordinatable {
        let model = BaseTransactionListModel(database: database)
        model.dateInterval = interval
        model.lastCategory = database.getCategory(id: categoryId)
        return TransactionListController(model: model)
    }
    
    func makeTransactionListVC(interval: DateInterval, categoryType: CategoryType) -> any Coordinatable {
        let model = BaseTransactionListModel(database: database)
        model.dateInterval = interval
        model.lastType = categoryType
        return TransactionListController(model: model)
    }
    
    func makeIntervalSelectorVC(for type: IntervalType) -> any Coordinatable {
        return mock()
    }
    
    
}

class mock: UIViewController, Coordinatable {
    var callback: ((any Coordinatable) -> (Void))?
    
    var coordinator: (any Coordinator)?
    
    
}
