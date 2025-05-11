
import UIKit

protocol ColorPicker: UIView {
    var delegate: ColorPickerDelegate? { get set }
    var selectedColor: UIColor? { get }
    
    func selectColor(at index: Int)
    func selectColor(_ color: UIColor)
    func setColors(_ colors: [UIColor])
}

protocol ColorPickerDelegate {
    func colorPicker(_ picker: ColorPicker, didSelectColor color: UIColor)
    func colorPickerRequestToOpenExtendedPicker(_ picker: ColorPicker)
}

extension ColorPickerDelegate {
    func colorPicker(_ picker: ColorPicker, didSelectColor color: UIColor) {}
    func colorPickerRequestToOpenExtendedPicker(_ picker: ColorPicker) {}
}
