
import UIKit

class CategoryManagementViewController: UIViewController, Coordinatable, ColorPickerDelegate, ExtendedIconPickerDelegate {
    
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    var model: CategoryManagmentModel!
    var startType: CategoryType = .expense
    
    private var categoryTypeControl = UISegmentedControl()
    private var nameTextfield = UnderlinedTextfield()
    private var colorLabel = UILabel()
    private var colorPicker = LineColorPicker()
    private var iconLabel = UILabel()
    private var iconPicker: ImageAndTitleCollection = ImageAndTitleCollectionView(isScrollEnabled: false, selectionAsPrimaryAction: true)
    private var actionButton = UIButton(configuration: .filled())
    
    private var categoryName: String { nameTextfield.text ?? "" }
    private var categoryColor: UIColor { colorPicker.selectedColor ?? .systemBlue }
    private var categoryIconId = ""
    private var cateogryType: CategoryType { [CategoryType.expense, .income][categoryTypeControl.selectedSegmentIndex] }
    
    
    convenience init(model: CategoryManagmentModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.model = nil
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupInitialValues()
        setupInitialCategoryValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
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
        nameTextfield.addPopUp(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 15))
    }
    
    //MARK: - Color Picker
    private func setupColorLabel() {
        view.addSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.nameTextfield.snp.bottom).offset(DC.interItemSpacing)
            maker.leading.equalTo(self.view.safeAreaLayoutGuide).inset(DC.standartInset)
            maker.trailing.lessThanOrEqualTo(self.view.safeAreaLayoutGuide.snp.trailing).inset(DC.standartInset)
        }
        
        colorLabel.text = "Цвет"
        colorLabel.font = DC.Font.medium(size: 22)
    }
    
    private func setupColorPicker() {
        view.addSubview(colorPicker)
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        colorPicker.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.colorLabel.snp.bottom).offset(DC.titleAndItemSpacing)
            maker.leading.equalTo(self.view.safeAreaLayoutGuide).inset(DC.standartInset)
            maker.height.equalTo(40)
        }
        colorPicker.delegate = self
    }
    
    func colorPicker(_ picker: any ColorPicker, didSelectColor color: UIColor) {
        var items = iconPicker.items
        for index in items.indices {
            if index != 5 {
                items[index].color = color
            }
            else {
                items[index].image = getMoreIconsImage()
            }
        }
        iconPicker.setItems(items)
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
        iconLabel.font = DC.Font.medium(size: 22)
        iconLabel.addPopUp(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
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
        
        iconPicker.maxItemsCount = 6
    }
    
    func iconPicker(didSelectIcon id: String) {
        categoryIconId = id
    }
    
    private func moreIconsPressed() {
        coordinator?.showIconPickerVC(delegate: self, startColor: colorPicker.selectedColor ?? .systemBlue, callback: nil)
    }
    
    func extendedIconPicker(didSelectIcon id: String) {
        let icon = model.getIcon(id: id)
        let item = ImageAndTitleItem(id: UUID(), image: icon, color: colorPicker.selectedColor, allowSelection: true, action: { [weak self] _ in
            self?.iconPicker(didSelectIcon: id)
        })
        iconPicker.insertItem(item, at: 0, needSaveLastItem: true)
        iconPicker.selectItem(at: 0)
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
        
        actionButton.addAction(UIAction(handler: performAction), for: .touchUpInside)
    }
    
    private func performAction(_ action: UIAction) {
        guard checkCategoryValidity() else { return }
        let category = self.getCurrentCategoryValues()
       model.perform(category: category)
       coordinator?.popVC()
    }
    
    //MARK: - Bar Action
    private func setupBarAction() {
        let item = model.getAdditionalBarItem(additionalAction: { [weak self] in
            self?.coordinator?.popVC()
        })
        navigationItem.rightBarButtonItem = item
    }
    
    //MARK: - Values
    private func getCurrentCategoryValues() -> any Category {
        var category = DefaultCategory()
        category.name = nameTextfield.text ?? ""
        category.type = CategoryType.allCases[categoryTypeControl.selectedSegmentIndex]
        category.color = colorPicker.selectedColor ?? .black
        category.iconId = categoryIconId
        return category
    }
    
    private func getMoreIconsImage() -> UIImage {
        let conf = UIImage.SymbolConfiguration(paletteColors: [colorPicker.selectedColor ?? .black])
        let moreIconsImage = UIImage(systemName: "ellipsis.circle")?.withConfiguration(conf)
        return moreIconsImage ?? UIImage()
    }
    
    private func setupInitialValues() {
        categoryTypeControl.selectedSegmentIndex = startType.index
        title = "Новая категория"
        let colors = model.getColors()
        let icons = model.getIcons()[0..<5]
        
        colorPicker.setColors(colors)
        colorPicker.selectColor(at: 0)
        var iconItems = icons.map { icon in
            ImageAndTitleItem(id: UUID(), image: icon.image, color: colorPicker.selectedColor, allowSelection: true, action: { [weak self] _ in
                self?.iconPicker(didSelectIcon: icon.id)
            })
        }
        let moreIconsItem = ImageAndTitleItem(id: UUID(), image: getMoreIconsImage(), color: .clear, allowSelection: false, action: { [weak self] _ in
            self?.moreIconsPressed()
        })
        iconItems += [moreIconsItem]
        iconPicker.setItems(iconItems)
    }
    
    private func setupInitialCategoryValues() {
        guard let category = model.getInitialCategory() else { return }
        title = category.name
        nameTextfield.text = category.name
        colorPicker.insertNewColor(category.color)
        colorPicker.selectColor(at: 0)
        let icon = model.getIcon(id: category.iconId)
        let iconItem = ImageAndTitleItem(id: UUID(), image: icon, color: category.color, allowSelection: true, action: { [weak self] _ in
            self?.iconPicker(didSelectIcon: category.iconId)
        })
        iconPicker.insertItem(iconItem, at: 0, needSaveLastItem: true)
        iconPicker.selectItem(at: 0)
        if category.type == .income { categoryTypeControl.selectedSegmentIndex = 1 }
    }
    
    private func checkCategoryValidity() -> Bool {
        var flag = true
        if nameTextfield.text?.isEmpty ?? true {
            nameTextfield.showPopUpIfExiste()
            flag = false
        }
        if categoryIconId.isEmpty {
            iconLabel.showPopUpIfExiste()
        }
        return flag
    }
    
}
