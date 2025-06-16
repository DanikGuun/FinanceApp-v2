
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

enum IconKind{
    case base
}

struct DefaultIcon: Icon {
    var id: String
    var image: UIImage
    var kind: IconKind
}
