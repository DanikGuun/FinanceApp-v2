
import UIKit

struct DefaultCategory: IdentifiableCategory{
    var id = UUID()
    var name: String = ""
    var type: CategoryType = .expense
    var iconId: String = ""
    var color: UIColor = .tintColor
}
