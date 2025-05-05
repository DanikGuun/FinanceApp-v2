
import UIKit

extension UIView {
    
    public func makeCornersAndShadow(radius: CGFloat = 15, color: UIColor = .label, opacity: Float = 0.3) {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
    }
    
}
