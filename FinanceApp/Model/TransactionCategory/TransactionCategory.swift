import UIKit

protocol TransactionCategory {
    var name: String { get set }
    var type: TransactionType { get set }
    var iconID: String { get set }
    var color: UIColor { get set }
}
