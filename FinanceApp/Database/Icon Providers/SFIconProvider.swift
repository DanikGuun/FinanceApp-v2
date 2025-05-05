
import UIKit

final class SFIconProvider: IconProvider{
    
    private let icons: [any Icon] = [
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

private class SFCategoryIcon: Icon {
    
    let id: String
    let kind: IconKind
    let image: UIImage
    
    init(_ imageName: String, id: String, kind: IconKind) {
        self.id = id
        self.image = UIImage(systemName: imageName) ?? UIImage()
        self.kind = kind
    }
    
}
