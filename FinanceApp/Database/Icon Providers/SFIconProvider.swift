
import UIKit

final class SFIconProvider: IconProvider{
    
    private let icons: [any Icon] = [
        SFCategoryIcon("bus.fill", id: "bus.fill", kind: .base),
        SFCategoryIcon("display", id: "display", kind: .base),
        SFCategoryIcon("personalhotspot", id: "personalhotspot", kind: .base),
        SFCategoryIcon("microphone.fill", id: "microphone.fill", kind: .base),
        SFCategoryIcon("car.side.rear.open.fill", id: "car.side.rear.open.fill", kind: .base),
        
        SFCategoryIcon("display", id: "display", kind: .base2),
        SFCategoryIcon("personalhotspot", id: "personalhotspot", kind: .base2),
        SFCategoryIcon("microphone.fill", id: "microphone.fill", kind: .base2),
        SFCategoryIcon("car.side.rear.open.fill", id: "car.side.rear.open.fill", kind: .base2),
        SFCategoryIcon("plus", id: "plus", kind: .base2)
    ]
    
    func getIcons() -> [any Icon] {
        return icons
    }
    
    func getIcon(id: String) -> (any Icon)? {
        return icons.first { $0.id == id }
    }
    
    func getIconsWithKind() -> [IconKind : [any Icon]] {
        var dict: [IconKind : [any Icon]] = [:]
        icons.forEach { dict[$0.kind, default: []].append($0) }
        return dict
    }
    
}

private struct SFCategoryIcon: Icon {
    
    let id: String
    let kind: IconKind
    let image: UIImage
    
    init(_ imageName: String, id: String, kind: IconKind) {
        self.id = id
        let imageConf = UIImage.SymbolConfiguration(paletteColors: [.systemBackground])
        self.image = UIImage(systemName: imageName)?.withConfiguration(imageConf) ?? UIImage()
        self.kind = kind
    }
    
}
