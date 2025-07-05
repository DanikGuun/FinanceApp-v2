
import UIKit

final public class TransactionManagmentViewController: UIViewController, Coordinatable {
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    
    private var transactionTypeControl = UISegmentedControl()
    private var amountTextField = UnderlinedTextfield()
    private var nameTextField = UnderlinedTextfield()
    private var categoryLabel = UILabel()
    private var categoryPicker: ImageAndTitleCollection = ImageAndTitleCollectionView()
    private var dateLabel = UILabel()
    private var datePicker = UIDatePicker()
    private var actionButton = UIButton(configuration: .filled())
    
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
        setupNameTextField()
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
        amountTextField.rightUnderlineOffset = 30
        amountTextField.keyboardType = .decimalPad
    }
    
    private func setupNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(amountTextField.snp.bottom).offset(DC.interItemSpacing)
            maker.leading.equalToSuperview().inset(DC.standartInset)
        }
        
        nameTextField.placeholder = "Название..."
        nameTextField.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        nameTextField.leftUnderlineOffset = 10
        nameTextField.rightUnderlineOffset = 50
    }
    
    private func setupCategoryLabel() {
        view.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.nameTextField.snp.bottom).offset(DC.interItemSpacing)
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
        var items: [ImageAndTitleItem] = []
        for _ in 0..<6 {
            items.append(ImageAndTitleItem(title: "Title", image: UIImage(systemName: "book"), color: .systemMint))
        }
        categoryPicker.setItems(items)
    }
    
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
        conf?.title = "Добавить"
        conf?.imagePadding = 10
        conf?.image = UIImage(systemName: "plus.square")
        actionButton.configuration = conf
        
        actionButton.addAction(UIAction(handler: { [weak self] _ in

        }), for: .touchUpInside)
    }
}
