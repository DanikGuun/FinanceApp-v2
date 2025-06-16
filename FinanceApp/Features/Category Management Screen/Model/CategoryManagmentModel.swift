
import UIKit

protocol CategoryManagmentModel {
    func perform(category: any Category)
    func getInitialCategory() -> (any Category)?
    func getPerformButtonTitle() -> String
    func getPerformButtonImage() -> UIImage?
    func getAdditionalBarItem() -> UIBarButtonItem?
    func getIcon(id: String) -> UIImage?
}
