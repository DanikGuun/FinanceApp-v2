
import UIKit

final public class TransactionManagmentViewController: UIViewController, Coordinatable, UITextFieldDelegate {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    var model: TransactionManagmentModel!
    
    private var transactionTypeControl = UISegmentedControl()
    private var amountTextField = UnderlinedTextfield()
    private var categoryLabel = UILabel()
    private var categoryPicker: ImageAndTitleCollection = ImageAndTitleCollectionView()
    private var dateLabel = UILabel()
    private var datePicker = UIDatePicker()
    private var actionButton = UIButton(configuration: .filled())
    
    private var currentCategoryType: CategoryType {
        [CategoryType.expense, .income][transactionTypeControl.selectedSegmentIndex]
    }
    private var selectedCategoryId: UUID?
    
    convenience init(model: TransactionManagmentModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?(self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setupUI() {
        setupTransactionTypeControl()
        setupAmountTextField()
        setupCategoryLabel()
        setupCategoryPicker()
        setupDateLabel()
        setupDatePicker()
        setupActionButton()
    }
    
    private func setupTransactionTypeControl() {
        view.addSubview(transactionTypeControl)
        transactionTypeControl.translatesAutoresizingMaskIntoConstraints = false
        transactionTypeControl.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(14)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }
        
        transactionTypeControl.insertSegment(withTitle: "Расходы", at: 0, animated: false)
        transactionTypeControl.insertSegment(withTitle: "Доходы", at: 1, animated: false)
        transactionTypeControl.selectedSegmentIndex = 0
        transactionTypeControl.addAction(UIAction(handler: { [weak self] _ in
            self?.updateCategoryPickerItems()
        }), for: .valueChanged)
    }
    
    private func setupAmountTextField() {
        view.addSubview(amountTextField)
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(transactionTypeControl.snp.bottom).offset(DC.interItemSpacing)
            maker.centerX.equalToSuperview()
        }
        
        amountTextField.placeholder = "Сумма..."
        amountTextField.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        amountTextField.leftUnderlineOffset = 10
        amountTextField.rightUnderlineOffset = 10
        amountTextField.keyboardType = .decimalPad
        amountTextField.delegate = self
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    //MARK: - Category Picker
    private func setupCategoryLabel() {
        view.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.amountTextField.snp.bottom).offset(DC.interItemSpacing)
            maker.leading.equalToSuperview().inset(DC.titleInset)
        }
        
        categoryLabel.text = "Категория"
        categoryLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
    }
    
    private func setupCategoryPicker() {
        view.addSubview(categoryPicker)
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(categoryLabel.snp.bottom).offset(DC.titleAndItemSpacing)
            maker.leading.trailing.equalToSuperview().inset(DC.standartInset)
            maker.height.equalTo(280)
        }
        
        categoryPicker.maxItemsCount = 6
        (categoryPicker as? UIScrollView)?.isScrollEnabled = false
        updateCategoryPickerItems()
    }
    
    private func updateCategoryPickerItems() {
        let categoryItems = model.getCategories(of: currentCategoryType).map { category in
            let image = model.getIcon(iconId: category.iconId)
            let item =  ImageAndTitleItem(title: category.name, image: image, color: category.color, allowSelection: true, action: { [weak self] _ in
                self?.selectedCategoryId = category.id
            })
            return item
        }
        categoryPicker.setItems(categoryItems)
        categoryPicker.selectItem(at: 0)
        categoryPicker.insertItem(getMoreCategoriesItem(), at: 5, needSaveLastItem: false)
    }
    
    private func getMoreCategoriesItem() -> ImageAndTitleItem {
        let conf = UIImage.SymbolConfiguration(paletteColors: [.systemBlue])
        let image = UIImage(systemName: "ellipsis.circle", withConfiguration: conf)
        let item = ImageAndTitleItem(title: "Больше", image: image, color: .clear, allowSelection: false)
        return item
    }
    //
    
    private func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.categoryPicker.snp.bottom).offset(DC.interItemSpacing)
            maker.leading.equalToSuperview().offset(DC.titleInset)
        }
        
        dateLabel.text = "Дата"
        dateLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
    }
    
    private func setupDatePicker() {
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.equalTo(self.dateLabel.snp.trailing).offset(DC.interItemSpacing)
            maker.centerY.equalTo(self.dateLabel)
        }
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.actual
    }
    
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
            guard let transaction = self?.getCurrentTransaction() else { return }
            self?.model.perform(transaction: transaction)
        }), for: .touchUpInside)
    }
    
    private func getCurrentTransaction() -> DefaultTransaction {
        let amount = Double(amountTextField.text ?? "") ?? 0
        let date = datePicker.date
        let transaction = DefaultTransaction(categoryID: selectedCategoryId!, amount: amount, date: date)
        return transaction
    }
}
