
import UIKit

protocol IconProvider {
    func getIcons() -> [Icon]
    func getIcon(id: String) -> Icon?
    func getIconsWithKind() -> [IconKind: [Icon]]
}

protocol Icon{
    var id: String { get }
    var image: UIImage { get }
    var kind: IconKind { get }
}

enum IconKind: String {
    case base = "Первая категория", base2 = "Вторая категория"
}

struct DefaultIcon: Icon {
    var id: String = ""
    var image: UIImage = UIImage()
    var kind: IconKind = .base
}
