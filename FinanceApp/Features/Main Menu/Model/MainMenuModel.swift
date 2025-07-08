
import UIKit

public protocol MainMenuModel {
    func menuItems() -> [MenuItem]
}

public struct MenuItem: Identifiable {
    public var id = UUID()
    public var title = ""
    public var image: UIImage? = nil
    public var action: ((MenuItem) -> ())?
}

public class BaseMainMenuModel: MainMenuModel {
    
    private static let imageConf = UIImage.SymbolConfiguration(paletteColors: [.systemBlue])
    
    var items: [MenuItem] = []
    
    init(coordinator: Coordinator) {
        self.items = [
            MenuItem(title: "Статистика", image: UIImage(systemName: "list.clipboard", withConfiguration: BaseMainMenuModel.imageConf), action: { _ in
                coordinator.showChartVC(callback: nil)
            }),
            MenuItem(title: "Категории", image: UIImage(systemName: "folder", withConfiguration: BaseMainMenuModel.imageConf), action: { _ in
                coordinator.showCategoryListVC(callback: nil)
            })
        ]
    }
    
    public func menuItems() -> [MenuItem] {
        return items
    }
    
    
}
