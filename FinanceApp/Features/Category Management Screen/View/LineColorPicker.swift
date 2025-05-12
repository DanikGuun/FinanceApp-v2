
import UIKit

class LineColorPicker: UIStackView, ColorPicker {
    
    var delegate: (any ColorPickerDelegate)?
    
    var selectedColor: UIColor? { colorPickerElements.first(where: { $0.isSelected })?.color }
    var colors: [UIColor] { colorPickerElements.map { $0.color } }
    private(set) var maxColorsCount = 5
    private(set) var colorPickerElements: [ColorPickElement] = []
    private(set) var requestToOpenExtendedPickerButton = UIButton()
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        self.axis = .horizontal
        self.distribution = .equalSpacing
        self.alignment = .center
        setupExtendedColorPickerButton()
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
        guard index < colorPickerElements.count else { return }
        for (i, element) in colorPickerElements.enumerated() {
            element.isSelected = i == index
        }
        delegate?.colorPicker(self, didSelectColor: colors[index])
    }
    
    func selectColor(_ color: UIColor) {
        guard colors.contains(color) else { return }
        for element in colorPickerElements {
            element.isSelected = element.color == color
        }
        delegate?.colorPicker(self, didSelectColor: color)
    }
    
    func insertNewColor(_ color: UIColor) {
        var colors = Array(self.colors.dropLast())
        colors.insert(color, at: 0)
        setColors(colors)
        selectColor(at: 0)
    }
    
    func setColors(_ colors: [UIColor]) {
        let maxAvailableColorsCount = min(colors.count, maxColorsCount)
        let availableColors = Array(colors[0 ..< maxAvailableColorsCount])
        removeAllArrangedSubviews()
        for color in availableColors {
            configurePicker(color)
        }
        addArrangedSubview(requestToOpenExtendedPickerButton)
    }
    
    private func configurePicker(_ color: UIColor) {
        let picker = ColorPickElement()
        addArrangedSubview(picker)
        colorPickerElements.append(picker)
        picker.addAction(UIAction(handler: { [weak self] _ in
            self?.selectColor(color)
        }), for: .touchUpInside)
        picker.color = color
    }
    
    private func setupExtendedColorPickerButton() {
        var conf = UIButton.Configuration.plain()
        conf.imagePlacement = .all
        conf.image = UIImage(systemName: "ellipsis.circle.fill")
        conf.imagePadding = 0
        conf.imageReservation = 100
        conf.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        conf.baseForegroundColor = .systemGray3
        conf.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        requestToOpenExtendedPickerButton.configuration = conf
        requestToOpenExtendedPickerButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.colorPickerRequestToOpenExtendedPicker(self)
        }), for: .touchUpInside)
    }
    
    private func removeAllArrangedSubviews() {
        colorPickerElements.removeAll()
        for subview in arrangedSubviews {
            removeArrangedSubview(subview)
        }
    }
    
}
