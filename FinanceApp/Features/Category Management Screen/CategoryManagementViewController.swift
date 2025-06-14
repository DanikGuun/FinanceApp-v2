
import UIKit

class CategoryManagementViewController: UIViewController, Coordinatable {
    
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    var model: CategoryManagmentModel!
    
    private var categoryTypeControl = UISegmentedControl()
    private var nameTextfield = UnderlinedTextfield()
    private var colorLabel = UILabel()
    private var colorPicker = LineColorPicker()
    private var iconLabel = UILabel()
    private var iconPicker = ImageAndTitleCollectionView(isScrollEnabled: false, selectionAsPrimaryAction: true)
    private var actionButton = UIButton(configuration: .filled())
    
    convenience init(model: CategoryManagmentModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.model = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupInitialValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?(self)
    }
    
    private func setupUI() {
        setupCategoryTypeControl()
        setupNameTextfield()
        setupColorLabel()
        setupColorPicker()
        setupIconLabel()
        setupIconPicker()
        setupActionButton()
        setupBarAction()
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
        colorPicker.setColors([UIColor.black, .blue, .red, .cyan, .green, .orange])
    }
    
    //MARK: - Icon Picker
    private func setupIconLabel() {
        view.addSubview(iconLabel)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.colorPicker.snp.bottom).offset(DC.interItemSpacing)
            maker.leading.equalTo(self.view.safeAreaLayoutGuide).inset(DC.standartInset)
        }
        
        iconLabel.text = "Иконка"
        iconLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
    }
    
    private func setupIconPicker() {
        view.addSubview(iconPicker)
        iconPicker.translatesAutoresizingMaskIntoConstraints = false
        iconPicker.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.iconLabel.snp.bottom).offset(DC.titleAndItemSpacing)
            maker.height.equalTo(self.iconPicker.snp.width)
            maker.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(DC.standartInset)
        }
        
    }
    
    //MARK: - Action Button
    private func setupActionButton() {
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        actionButton.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(DC.standartInset)
            maker.height.equalTo(DC.standartButtonHeight)
            maker.centerX.equalToSuperview()
        }
        
        var conf = actionButton.configuration
        conf?.title = model.getPerformButtonTitle()
        conf?.imagePadding = 10
        conf?.image = model.getPerformButtonImage()
        actionButton.configuration = conf
        
        actionButton.addAction(UIAction(handler: { [weak self] _ in
            self?.model.perform(category: DefaultCategory())
        }), for: .touchUpInside)
    }
    
    //MARK: - Bar Action
    private func setupBarAction() {
        navigationItem.rightBarButtonItem = model.getAdditionalBarItem()
    }
    
    //MARK: - Initial Values
    private func setupInitialValues() {
        guard let category = model.getInitialCategory() else { return }
        title = category.name
        nameTextfield.text = category.name
        colorPicker.insertNewColor(category.color)
        colorPicker.selectColor(at: 0)
        iconPicker.insertItem(ImageAndTitleItem(id: UUID(), title: "Bus", image: UIImage(systemName: "bus"), color: .darkGray))
        iconPicker.selectItem(at: 0)
    }
    
}
