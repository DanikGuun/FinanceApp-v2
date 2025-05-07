
import UIKit

class CategoryManagementViewController: UIViewController, Coordinatable {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    
    private var categoryTypeControl = UISegmentedControl()
    private var nameTextfield = UnderlinedTextfield()
    private var colorLabel = UILabel()
    private var colorPicker = LineColorPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        setupCategoryTypeControl()
        setupNameTextfield()
        setupColorLabel()
        setupColorPicker()
    }
    
    //MARK: - Segmented control
    
    private func setupCategoryTypeControl() {
        view.addSubview(categoryTypeControl)
        categoryTypeControl.translatesAutoresizingMaskIntoConstraints = false
        categoryTypeControl.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(2)
        }
        
        categoryTypeControl.insertSegment(withTitle: "Расходы", at: 0, animated: false)
        categoryTypeControl.insertSegment(withTitle: "Доходы", at: 1, animated: false)
        categoryTypeControl.selectedSegmentIndex = 0
    }
    
    //MARK: - Name Textfield
    private func setupNameTextfield() {
        view.addSubview(nameTextfield)
        nameTextfield.translatesAutoresizingMaskIntoConstraints = false
        nameTextfield.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.categoryTypeControl.snp.bottom).offset(DC.interItemSpacing)
            maker.leading.equalTo(self.view.safeAreaLayoutGuide).inset(DC.standartInset)
            maker.width.greaterThanOrEqualTo(self.view.snp.width).dividedBy(3)
            maker.trailing.lessThanOrEqualTo(self.view.safeAreaLayoutGuide).inset(DC.standartInset)
        }
        nameTextfield.placeholder = "Название..."
    }
    
    //MARK: - Color Picker
    private func setupColorLabel() {
        view.addSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.nameTextfield.snp.bottom).offset(DC.interItemSpacing)
            maker.leading.equalTo(self.view.safeAreaLayoutGuide).inset(DC.standartInset)
        }
        
        colorLabel.text = "Цвет"
        colorLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
    }
    
    private func setupColorPicker() {
        view.addSubview(colorPicker)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        colorPicker.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.colorLabel.snp.bottom).offset(DC.titleAndItemSpacing)
            maker.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(DC.standartInset)
            maker.height.equalTo(40)
        }
    }
    
}
