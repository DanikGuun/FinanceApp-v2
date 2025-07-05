
import UIKit

protocol ImageAndTitleCollection: UIView {
    
    var items: [ImageAndTitleItem] { get }
    var maxItemsCount: Int { get set }
    var selectedItem: ImageAndTitleItem? { get }
    
    func selectItem(_ item: ImageAndTitleItem)
    func selectItem(at index: Int)
    func setItems(_ items: [ImageAndTitleItem])
    func insertItem(_ item: ImageAndTitleItem, at: Int, needSaveLastItem: Bool)
    
}

struct ImageAndTitleItem: Equatable {
    var id: UUID = UUID()
    var title: String?
    var image: UIImage?
    var color: UIColor?
    var allowSelection: Bool = true
    var action: ((ImageAndTitleItem) -> Void)?
    
    static func == (lhs: ImageAndTitleItem, rhs: ImageAndTitleItem) -> Bool {
        return lhs.id == rhs.id
    }
}
