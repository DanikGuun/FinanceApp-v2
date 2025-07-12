
import UIKit

extension UIView {
    
    public func makeCornersAndShadow(radius: CGFloat = 15, color: UIColor = .label, opacity: Float = 0.3) {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5
    }
    
    @discardableResult public func addPopUp(color: UIColor = .systemRed.withAlphaComponent(0.7), insets: UIEdgeInsets = .zero) -> PopUpView {
        let view = PopUpView()
        addSubview(view)
        view.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(-insets.top)
            maker.bottom.equalToSuperview().inset(-insets.bottom)
            maker.leading.equalToSuperview().inset(-insets.left)
            maker.trailing.equalToSuperview().inset(-insets.right)
        }
        view.makeCornersAndShadow(radius: 5, color: .clear, opacity: 0)
        view.backgroundColor = color
        view.alpha = 0
        return view
    }
    
    public func showPopUpIfExiste() {
        for view in self.subviews {
            if let view = view as? PopUpView {
                view.show()
            }
        }
    }
    
}
