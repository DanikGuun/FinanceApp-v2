
import UIKit

class MainMenuViewController: UIViewController, Coordinatable {
    
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let b = UIButton(type: .system)
        b.frame = CGRect(x: 50, y: 100, width: 100, height: 50)
        b.setTitle("Чарты", for: .normal)
        b.tintColor = .systemBlue
        view.addSubview(b)
        b.addAction(UIAction(handler: { _ in
            self.coordinator?.showChartVC(callback: nil)
        }), for: .touchUpInside)
        
        let b2 = UIButton(type: .system)
        b2.frame = CGRect(x: 50, y: 150, width: 100, height: 50)
        b2.setTitle("Категории", for: .normal)
        b2.tintColor = .systemBlue
        view.addSubview(b2)
        b2.addAction(UIAction(handler: { _ in
            self.coordinator?.showAddCategoryVC(callback: nil)
        }), for: .touchUpInside)
        
    }
    
}
