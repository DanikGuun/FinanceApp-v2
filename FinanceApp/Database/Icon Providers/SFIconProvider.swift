
import UIKit

final class SFIconProvider: IconProvider{
    
    private let icons: [any Icon] = [
        SFCategoryIcon("bus.fill", id: "bus.fill", kind: .base),
        SFCategoryIcon("display", id: "display", kind: .base),
        SFCategoryIcon("personalhotspot", id: "personalhotspot", kind: .base),
        SFCategoryIcon("microphone.fill", id: "microphone.fill", kind: .base),
        SFCategoryIcon("car.side.rear.open.fill", id: "car.side.rear.open.fill", kind: .base),
        SFCategoryIcon("plus", id: "plus", kind: .base)
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
        self.image = UIImage(systemName: imageName)?.withTintColor(.systemBackground, renderingMode: .alwaysTemplate) ?? UIImage()
        self.kind = kind
    }
    
}
