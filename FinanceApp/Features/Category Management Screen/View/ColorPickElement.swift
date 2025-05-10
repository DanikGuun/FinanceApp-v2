
import UIKit

class ColorPickElement: UIControl {
    
    var color: UIColor = .black { didSet { colorLayer.fillColor = color.cgColor } }
    
    private let strokeColor: UIColor = .systemGray2
    private let strokeWidth: CGFloat = 3
    private let animationDuration = 0.25
    private var radius: CGFloat {
        return min(self.frame.width, self.frame.height) / 2
    }
    private var boundsCenter: CGPoint { return CGPoint(x: self.bounds.midX, y: self.bounds.midY) }
    
    private let colorLayer = CAShapeLayer()
    private let strokeLayer = CAShapeLayer()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.layer.addSublayer(colorLayer)
        self.layer.addSublayer(strokeLayer)
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.strokeColor = strokeColor.cgColor
        strokeLayer.lineWidth = 0
        self.addAction(UIAction(handler: touchUpInsideAction), for: .touchUpInside)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorLayer.path = UIBezierPath(arcCenter: boundsCenter, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
        strokeLayer.path = UIBezierPath(arcCenter: boundsCenter, radius: radius - strokeWidth / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
    }
    
    private func touchUpInsideAction(_ sender: UIAction) {
        self.isSelected.toggle()
        selectAnimation()
        print(self.isSelected)
    }
    
    private func selectAnimation() {
        selectAnimationColor()
        selectAnimationStroke()
    }
    
    private func selectAnimationColor() {
        let radiusOffset: CGFloat = self.isSelected ? strokeWidth + 1 : 0
        let newPath = UIBezierPath(arcCenter: boundsCenter, radius: radius - radiusOffset, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
        let anim = CABasicAnimation()
        anim.keyPath = "path"
        anim.fromValue = colorLayer.path
        anim.toValue = newPath
        anim.duration = animationDuration
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        colorLayer.path = newPath
        
        colorLayer.add(anim, forKey: "path")
    }
    
    private func selectAnimationStroke() {
        let width: CGFloat = self.isSelected ? strokeWidth : 0
        let anim = CABasicAnimation()
        anim.keyPath = "lineWidth"
        anim.fromValue = strokeLayer.lineWidth
        anim.duration = animationDuration
        anim.toValue = width
        strokeLayer.lineWidth = width
    }
    
}
