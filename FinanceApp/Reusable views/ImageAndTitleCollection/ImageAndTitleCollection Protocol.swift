
import UIKit

protocol ImageAndTitleCollection: UIView {
    
    var items: [ImageAndTitleItem] { get }
    var maxItemsCount: Int { get }
    var selectedItem: ImageAndTitleItem? { get }
    
    func selectItem(_ item: ImageAndTitleItem)
    func selectItem(at id: Int)
    
    func setItems(_ items: [ImageAndTitleItem])
    func insertItem(_ item: ImageAndTitleItem, needSaveLastItem: Bool)
    
}

struct ImageAndTitleItem {
    var id: UUID
    var title: String?
    var image: UIImage?
    var color: UIColor?
    var action: ((ImageAndTitleItem) -> Void)?
    var allowSelection: Bool = true
}
