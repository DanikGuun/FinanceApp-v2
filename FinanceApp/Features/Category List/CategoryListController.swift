
import UIKit

final class CategoryListController: UIViewController, Coordinatable {
    var model: CategoryListModel!
    var callback: ((any Coordinatable) -> (Void))?
    var coordinator: (any Coordinator)?
    
    private var categoryTypeControl = UISegmentedControl()
    private var collectionView: ImageAndTitleCollection = ImageAndTitleCollectionView(isScrollEnabled: true, selectionAsPrimaryAction: false)
    
    private var currentCategoryType: CategoryType {
        [CategoryType.expense, .income][categoryTypeControl.selectedSegmentIndex]
    }
    
    convenience init(model: CategoryListModel) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback?(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Категории"
        setupUI()
        updateCollectionItems()
    }
    
    private func setupUI() {
        setupTypeControl()
        setupCollectionView()
    }
    
    private func setupTypeControl() {
        view.addSubview(categoryTypeControl)
        categoryTypeControl.translatesAutoresizingMaskIntoConstraints = false
        categoryTypeControl.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(14)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }
        
        categoryTypeControl.insertSegment(withTitle: "Расходы", at: 0, animated: false)
        categoryTypeControl.selectedSegmentIndex = 0
        categoryTypeControl.insertSegment(withTitle: "Доходы", at: 1, animated: false)
        categoryTypeControl.addAction(UIAction(handler: { [weak self] _ in
            self?.updateCollectionItems()
        }), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(categoryTypeControl.snp.bottom).offset(DC.innerItemSpacing)
            maker.leading.trailing.equalToSuperview().inset(DC.standartInset)
            maker.bottom.equalToSuperview()
        }
        
        collectionView.maxItemsCount = Int.max
    }
    
    private func updateCollectionItems() {
        let type = [CategoryType.expense, .income][categoryTypeControl.selectedSegmentIndex]
        var items = model.getCategories(type: type).map {
            ImageAndTitleItem(id: $0.id, title: $0.name, image: model.getImage(iconId: $0.iconId), color: $0.color, action: itemDidPressed)
        }
        items += [getCreateCategoryItem()]
        collectionView.setItems(items)
    }
    
    private func itemDidPressed(category: ImageAndTitleItem) {
        coordinator?.showEditCategoryVC(categoryId: category.id, callback: { [weak self] _ in
            self?.updateCollectionItems()
        })
    }
    
    private func getCreateCategoryItem() -> ImageAndTitleItem {
        let conf = UIImage.SymbolConfiguration(paletteColors: [.systemBlue])
        let image = UIImage(systemName: "plus.square")?.withConfiguration(conf)
        let item = ImageAndTitleItem(id: UUID(), title: "Добавить", image: image, color: .clear, action: addItemDidPressed)
        return item
    }
    
    private func addItemDidPressed(item: ImageAndTitleItem) {
        coordinator?.showAddCategoryVC(startType: currentCategoryType, callback: { [weak self] _ in
            self?.updateCollectionItems()
        })
    }
    
}
