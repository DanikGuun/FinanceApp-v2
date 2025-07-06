
import UIKit

protocol IconProvider {
    func getIcons() -> [any Icon]
    func getIcon(id: String) -> (any Icon)?
    func getIconsWithKind() -> [IconKind: [any Icon]]
}

protocol Icon: Equatable {
    var id: String { get }
    var image: UIImage { get }
    var kind: IconKind { get }
}

enum IconKind: String {
    case base = "Первая категория", base2 = "Вторая категория"
}

struct DefaultIcon: Icon, Equatable {
    var id: String = ""
    var image: UIImage = UIImage()
    var kind: IconKind = .base
}
