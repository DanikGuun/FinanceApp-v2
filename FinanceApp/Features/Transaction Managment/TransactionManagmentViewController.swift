
import UIKit

final public class TransactionManagmentViewController: UIViewController, Coordinatable {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?(self)
    }
    
}
