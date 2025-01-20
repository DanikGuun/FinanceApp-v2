
import UIKit

final class SFIconProvider: TransactionCategoryIconProvider {
    
    private let icons = [
        SFCategoryIcon("plus", kind: .base)
    ]
    
    func getIcons() -> [any TransactionCategoryIcon] {
        return icons
    }
    
}

private class SFCategoryIcon: TransactionCategoryIcon {
    
    var kind: TransactionCategoryIconKind
    var image: UIImage
    
    init(_ imageName: String, kind: TransactionCategoryIconKind) {
        self.image = UIImage(systemName: imageName) ?? UIImage()
        self.kind = kind
    }
    
}
