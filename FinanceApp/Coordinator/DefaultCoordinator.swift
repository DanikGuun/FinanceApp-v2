import Foundation
import UIKit

final class DefaultCoordinator: NSObject, Coordinator {

    var mainVC: UINavigationController!
    var window: UIWindow?
    var currentVC: (any Coordinatable)? { getCurrentVC(base: window?.rootViewController) }
    private let viewControllersFactory: ViewControllersFactory
    
    var needAnimate = true
    
    init(window: UIWindow?, viewControllersFabric: ViewControllersFactory){
        self.viewControllersFactory = viewControllersFabric
        self.window = window
        super.init()
        
        let menuVC = viewControllersFabric.makeMenuVC(coordinator: self)
        self.mainVC = UINavigationController(rootViewController: menuVC)
        menuVC.coordinator = self
        configMainVC()
        
        window?.rootViewController = mainVC
    }
    
    private func configMainVC() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        mainVC.navigationBar.standardAppearance = appearance
        mainVC.navigationBar.scrollEdgeAppearance = appearance
        mainVC.navigationBar.compactAppearance = appearance
        mainVC.navigationBar.compactScrollEdgeAppearance = appearance
    }
    
    func showMenuVC(callback: ((any Coordinatable) -> (Void))?) {
        mainVC.popToRootViewController(animated: needAnimate)
    }
    
    func showChartVC(callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeChartVC()
        vc.callback = callback
        push(vc)
    }
    
    func showCategoryListVC(callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeCategoryListVC()
        vc.callback = callback
        push(vc)
    }
    
    func showAddCategoryVC(startType: CategoryType = .expense, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeAddCategoryVC(startType: startType)
        vc.callback = callback
        push(vc)
    }
    
    func showEditCategoryVC(categoryId: UUID, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeEditCategoryVC(categoryId: categoryId)
        vc.callback = callback
        push(vc)
    }
    
    func showIconPickerVC(delegate: ExtendedIconPickerDelegate?, startColor: UIColor, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeIconPickerVC(startColor: startColor)
        (vc as? IconPickerViewController)?.delegate = delegate
        vc.callback = callback
        vc.coordinator = self
        currentVC?.modalPresentationStyle = .formSheet
        mainVC.topViewController?.present(vc, animated: needAnimate)
    }
    
    func showAddTransactionVC(startType: CategoryType = .expense, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeAddTransactionVC(startType: startType)
        vc.callback = callback
        push(vc)
    }
    
    func showEditTransactionVC(transactionId: UUID, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeEditTransactionVC(transactionId: transactionId)
        vc.callback = callback
        push(vc)
    }
    
    func showTransactionListVC(interval: DateInterval, categoryId: UUID, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeTransactionListVC(interval: interval, categoryId: categoryId)
        vc.callback = callback
        push(vc)
    }
    
    func showTransactionListVC(interval: DateInterval, categoryType: CategoryType, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeTransactionListVC(interval: interval, categoryType: categoryType)
        vc.callback = callback
        push(vc)
    }
    
    func showIntervalSelectorVC(for type: IntervalType, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFactory.makeIntervalSelectorVC(for: type)
        vc.callback = callback
        push(vc)
    }
    
    func popVC() {
        mainVC.popViewController(animated: needAnimate)
    }
    
    private func push(_ vc: any Coordinatable) {
        mainVC.pushViewController(vc, animated: needAnimate)
        vc.coordinator = self
    }
    
    private func getCurrentVC(base: UIViewController?) -> (any Coordinatable)? {
        if let nav = base as? UINavigationController {
            return getCurrentVC(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getCurrentVC(base: selected)
        }
        if let presented = base?.presentedViewController {
            return getCurrentVC(base: presented)
        }
        return base as? any Coordinatable
    }
 
}
