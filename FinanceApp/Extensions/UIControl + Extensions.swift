import UIKit

extension UIControl {
    
    func removeAllActions(){
        self.enumerateEventHandlers { (action, _, event, _) in
            if let action {
                self.removeAction(action, for: event)
            }
        }
    }
    
}
