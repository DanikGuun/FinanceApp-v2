
import UIKit

public class PopUpView: UIView {
    
    public func show() {
        let duration = 0.3
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: { [weak self] in
            self?.alpha = 1
        })
        UIView.animate(withDuration: 0.6, delay: duration, options: [.curveEaseInOut], animations: { [weak self] in
            self?.alpha = 0
        })
    }
    
}
