
import UIKit

class IconPickerViewController: UIViewController, Coordinatable {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Иконка"
        view.backgroundColor = .systemBackground
    }
    
}
