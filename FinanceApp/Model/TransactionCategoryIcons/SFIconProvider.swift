
import UIKit

final class SFIconProvider: TransactionCategoryIconProvider{
    
    private let icons: [any TransactionCategoryIcon] = [
        SFCategoryIcon("plus", id: "plus", kind: .base)
    ]
    
    func getIcons() -> [any TransactionCategoryIcon] {
        return icons
    }
    
    func getIcon(id: String) -> (any TransactionCategoryIcon)? {
        return icons.first { $0.id == id }
    }
    
    func getIconsWithType() -> [TransactionCategoryIconKind : [any TransactionCategoryIcon]] {
        
        var dict: [TransactionCategoryIconKind : [any TransactionCategoryIcon]] = [:]
        icons.forEach { dict[$0.kind, default: []].append($0) }
        return dict
        
    }
    
}

private class SFCategoryIcon: TransactionCategoryIcon {
    
    let id: String
    let kind: TransactionCategoryIconKind
    let image: UIImage
    
    init(_ imageName: String, id: String, kind: TransactionCategoryIconKind) {
        self.id = id
        self.image = UIImage(systemName: imageName) ?? UIImage()
        self.kind = kind
    }
    
}
