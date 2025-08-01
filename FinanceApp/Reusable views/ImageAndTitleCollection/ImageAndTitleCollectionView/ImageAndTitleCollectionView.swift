
import UIKit

class ImageAndTitleCollectionView: UICollectionView, ImageAndTitleCollection, UICollectionViewDelegate {

    var selectedItem: ImageAndTitleItem? { getSelectedItem() }
    private(set) var items: [ImageAndTitleItem] = []
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<UUID, UUID>!
    var isSelectionAllowed: Bool = true
    var maxItemsCount: Int = 6
    
    convenience init(isScrollEnabled: Bool, selectionAsPrimaryAction: Bool = true) {
        self.init()
        self.isScrollEnabled = isScrollEnabled
        self.isSelectionAllowed = selectionAsPrimaryAction
    }
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: Self.makeLayout())
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.allowsSelection = true
        self.delegate = self
        setupDataSource()
        setupSnapshot()
    }
    
    //MARK: - Items Handling
    func selectItem(_ item: ImageAndTitleItem) {
        guard let indexPath = diffableDataSource.indexPath(for: item.id) else { return }
        selectItem(at: indexPath)
    }
    
    func selectItem(at index: Int) {
        guard 0 <= index && index < items.count else { return }
        let indexPath = IndexPath(item: index, section: 0)
        selectItem(at: indexPath)
    }
    
    private func selectItem(at indexPath: IndexPath) {
        if delegate?.collectionView?(self, shouldSelectItemAt: indexPath) ?? true {
            self.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            delegate?.collectionView?(self, didSelectItemAt: indexPath)
        }
    }
    
    func insertItem(_ item: ImageAndTitleItem, at index: Int, needSaveLastItem: Bool = false) {
        guard index < maxItemsCount else { print("Index out of bounds"); return }
        defer { reloadSnapshot() }
        
        if items.count < maxItemsCount {
            let availableIndex = min(index, items.count)
            items.insert(item, at: availableIndex)
        }
        else {
            insertItemWithSlicing(item, at: index, needSaveLastItem: needSaveLastItem)
        }
    }
    
    private func insertItemWithSlicing(_ item: ImageAndTitleItem, at index: Int, needSaveLastItem: Bool) {
        guard items.count >= maxItemsCount else { print("Index out of bounds"); return }
        if needSaveLastItem {
            guard index < maxItemsCount - 1 else { print("Index out of bounds"); return } //если надо сохранить последний предмет, а мы пытаемся на его место поставить
            items = Array(items[0 ..< index]) + [item] + Array(items[index ..< maxItemsCount-2]) + [items.last!]
        }
        else {
            items = Array(items[0 ..< index]) + [item] + Array(items[index ..< maxItemsCount-1])
        }
    }
    
    func setItems(_ items: [ImageAndTitleItem]) {
        let maxItems = min(items.count, maxItemsCount)
        self.items = Array(items[0 ..< maxItems])
        reloadSnapshot()
    }
    
    private func getSelectedItem() -> ImageAndTitleItem? {
        guard let indexPath = self.indexPathsForSelectedItems?.first else { return nil }
        return getItemByIndexPath(indexPath)
    }
    
    //MARK: - Collection Delegate
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let item = getItemByIndexPath(indexPath) else { return true }
        item.action?(item)
        return item.allowSelection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelectionAllowed == false {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    //MARK: - Data source, Snapshot, Layout
    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<UUID, UUID>(collectionView: self, cellProvider: { [weak self] (collectionView, indexPath, id) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            var conf = ImageAndTitleCollectionConfiguration()
            let item = self?.items.first(where: { $0.id == id })
            conf.item = item
            cell.contentConfiguration = conf
            return cell
        })
    }
    
    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(items.map{ $0.id })
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func reloadSnapshot() {
        var snapshot = diffableDataSource.snapshot()
        guard let sectionID = snapshot.sectionIdentifiers.first else { return }
        snapshot.deleteSections([sectionID])
        snapshot.appendSections([UUID()])
        snapshot.appendItems(items.map { $0.id })
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .estimated(130))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
        group.interItemSpacing = .fixed(DC.collectionItemSpacing*1.5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: DC.collectionItemSpacing, leading:  DC.collectionItemSpacing, bottom:  DC.collectionItemSpacing, trailing:  DC.collectionItemSpacing)
        section.interGroupSpacing =  DC.collectionItemSpacing*1.5
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //MARK: - Other
    private func getItemByIndexPath(_ indexPath: IndexPath) -> ImageAndTitleItem? {
        guard let id = diffableDataSource.itemIdentifier(for: indexPath) else { return nil }
        guard let item = items.first(where: { $0.id == id }) else { return nil }
        return item
    }
}
