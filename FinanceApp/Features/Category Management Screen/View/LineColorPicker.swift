
import UIKit

class LineColorPicker: UIStackView, ColorPicker {
    var delegate: (any ColorPickerDelegate)?
    
    var selectedColor: UIColor = .black
    
    convenience init() {
        self.init(frame: .zero)
        setup()
        
        colors()
    }
    
    private func setup() {
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .center
    }
    
    func colors() {
        for color in [UIColor.black, .blue, .red, .cyan, .green, .orange] {
            let v = UIView()
            v.backgroundColor = color
            self.addArrangedSubview(v)
        }
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.height
        for color in self.arrangedSubviews {
            color.snp.updateConstraints { maker in
                maker.size.equalTo(height)
            }
        }
    }
    
    func selectColor(at index: Int) {
        
    }
    
    func setColors(_ colors: [UIColor]) {
        
    }
    
    
}
