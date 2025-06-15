import Foundation
import UIKit

final class DefaultCoordinator: NSObject, Coordinator {

    var mainVC: UINavigationController
    var currentVC: (any Coordinatable)? { return mainVC.viewControllers.last as? any Coordinatable}
    private let viewControllersFabric: ViewControllersFactory
    
    init(viewControllersFabric: ViewControllersFactory){
        self.viewControllersFabric = viewControllersFabric
        let menuVC = viewControllersFabric.makeMenuVC()
        self.mainVC = UINavigationController(rootViewController: menuVC)
        super.init()
        configMainVC()
        currentVC?.coordinator = self
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
        mainVC.popToRootViewController(animated: true)
    }
    
    func showChartVC(callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFabric.makeChartVC()
        vc.callback = callback
        push(vc)
    }
    
    func showAddCategoryVC(callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFabric.makeAddCategoryVC()
        vc.callback = callback
        push(vc)
    }
    
    func showEditCategoryVC(category: any IdentifiableCategory, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFabric.makeEditCategoryVC(category: category)
        vc.callback = callback
        push(vc)
    }
    
    func showAddTransactionVC(callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFabric.makeAddTransactionVC()
        vc.callback = callback
        push(vc)
    }
    
    func showEditTransactionVC(transaction: any IdentifiableTransaction, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFabric.makeEditTransactionVC(transaction: transaction)
        vc.callback = callback
        push(vc)
    }
    
    func showIntervalSummaryVC(interval: DateInterval, category: (any IdentifiableCategory)?, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFabric.makeIntervalSummaryVC(interval: interval, category: category)
        vc.callback = callback
        push(vc)
    }
    
    func showIntervalSelectorVC(for type: IntervalType, callback: ((any Coordinatable) -> (Void))?) {
        let vc = viewControllersFabric.makeIntervalSelectorVC(for: type)
        vc.callback = callback
        push(vc)
    }
    
    func popVC() {
        mainVC.popViewController(animated: false)
    }
    
    private func push(_ vc: any Coordinatable) {
        mainVC.pushViewController(vc, animated: true)
        vc.coordinator = self
    }
    
}
