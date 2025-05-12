

import XCTest
@testable import FinanceApp

final class LineColorPickerTests: XCTestCase {
    
    private var picker: LineColorPicker!
    private var delegate: MockDelegate!
    private let colorsSet = [UIColor.purple, .blue, .red, .cyan, .green, .orange]
    
    override func setUp() {
        picker = LineColorPicker()
        delegate = MockDelegate()
        picker.delegate = delegate
        super.setUp()
    }
    
    override func tearDown() {
        picker = nil
        delegate = nil
        super.tearDown()
    }
    
    private func setupDefaultColors() {
        let colors = Array(colorsSet[0 ..< picker.maxColorsCount])
        picker.setColors(colors)
    }
    
    private func testColorsAndPickerForOnes(_ colors: [UIColor]) {
        let colorPickers = picker.colorPickerElements.map { $0.color }
        XCTAssertEqual(colorPickers, colors)
        XCTAssertEqual(picker.colors, colors)
    }
    
    func testSetColorsThatEqualToMaxCount() {
        let colors = Array(colorsSet[0 ..< picker.maxColorsCount])
        picker.setColors(colors)
        testColorsAndPickerForOnes(colors)
    }
    
    func testSetColorsTahtMoreThanMaxCount() {
        let colors = Array(colorsSet[0 ..< picker.maxColorsCount + 1])
        picker.setColors(colors)
        testColorsAndPickerForOnes(colors.dropLast())
    }
    
    func testSetColorsThatLessThanMaxCount() {
        let colors = Array(colorsSet[0 ..< picker.maxColorsCount - 1])
        picker.setColors(colors)
        testColorsAndPickerForOnes(colors)
    }
    
    func testSelectColorByIndexInBounds() {
        setupDefaultColors()
        picker.selectColor(at: 1)
        XCTAssertEqual(picker.selectedColor, colorsSet[1])
    }
    
    func testSelectColorByIndexOutOfBounds() {
        setupDefaultColors()
        picker.selectColor(at: 0)
        let previousSelected = picker.selectedColor
        picker.selectColor(at: picker.maxColorsCount + 1)
        XCTAssertEqual(picker.selectedColor, previousSelected)
    }
    
    func testSelectColorByColorExists() {
        setupDefaultColors()
        picker.selectColor(colorsSet[1])
        XCTAssertEqual(picker.selectedColor, colorsSet[1])
    }
    
    func testSelectColorByPressingPicker() {
        setupDefaultColors()
        let color = picker.colorPickerElements[0].color
        picker.colorPickerElements[0].isSelected = true
        XCTAssertEqual(picker.selectedColor, color)
    }
    
    func testSelectColorsByColorDoesNotExist() {
        setupDefaultColors()
        picker.selectColor(at: 0)
        let previousSelected = picker.selectedColor
        picker.selectColor(UIColor(red: 2.5, green: 1.53, blue: 2.53, alpha: 0))
        XCTAssertEqual(picker.selectedColor, previousSelected)
    }
    
    func testSelectColorPickerElement() {
        let color = colorsSet[0]
        setupDefaultColors()
        picker.selectColor(color)
        let element = picker.colorPickerElements.first(where: { $0.color == color })
        XCTAssertTrue(element?.isSelected ?? false)
    }
    
    func testDeselectColorPickerElement() {
        let firstColor = colorsSet[0]
        let secondColor = colorsSet[1]
        setupDefaultColors()
        picker.selectColor(firstColor)
        picker.selectColor(secondColor)
        let element = picker.colorPickerElements.first(where: { $0.color == secondColor })
        XCTAssertTrue(element?.isSelected ?? false)
    }
    
    func testDelegateSelect() {
        setupDefaultColors()
        picker.selectColor(at: 0)
        XCTAssertEqual(delegate.lastSelectedColor, colorsSet[0])
    }
    
    func testDelegateRequestOpenExtendedPicker() {
        setupDefaultColors()
        picker.requestToOpenExtendedPickerButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(delegate.isRequestToOpenExtendedPickerCalled)
    }
    
    func testInsertNewColor() {
        setupDefaultColors()
        var colors = Array(picker.colors.dropLast())
        let newColor = UIColor(red: 0.52, green: 0.2, blue: 0.75, alpha: 1)
        colors.insert(newColor, at: 0)
        picker.insertNewColor(newColor)
        XCTAssertEqual(picker.colors, colors)
    }
}

fileprivate class MockDelegate: ColorPickerDelegate {
    
    var isRequestToOpenExtendedPickerCalled = false
    var lastSelectedColor: UIColor?
    
    func colorPicker(_ picker: any ColorPicker, didSelectColor color: UIColor) {
        lastSelectedColor = color
    }
    
    func colorPickerRequestToOpenExtendedPicker(_ picker: any ColorPicker) {
        isRequestToOpenExtendedPickerCalled = true
    }
}
