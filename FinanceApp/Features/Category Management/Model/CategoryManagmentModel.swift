
import UIKit

protocol CategoryManagmentModel {
    func perform(category: any Category)
    func getInitialCategory() -> (any Category)?
    func getPerformButtonTitle() -> String
    func getPerformButtonImage() -> UIImage?
    func getAdditionalBarItem(additionalAction: (()->())?) -> UIBarButtonItem?
    func getIcon(id: String) -> UIImage?
    func getIcons() -> [any Icon]
    func getColors() -> [UIColor]
}
