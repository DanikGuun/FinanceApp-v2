
import UIKit

class ImageAndTitleCollectionView: UICollectionView, ImageAndTitleCollection, UICollectionViewDelegate {

    private var diffableDataSource: UICollectionViewDiffableDataSource<UUID, UUID>!
    var isSelectionPrimaryAction: Bool = true
    
    convenience init(isScrollEnabled: Bool, selectionAsPrimaryAction: Bool = true) {
        self.init()
        self.isScrollEnabled = isScrollEnabled
        self.isSelectionPrimaryAction = selectionAsPrimaryAction
    }
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: Self.makeLayout())
        for _ in 0..<6 {
            let title: String? = Int.random(in: 0...124321).description
            let image = UIImage(systemName: "trash")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(hierarchicalColor: .white))
            let item = ImageAndTitleItem(id: UUID(), title: title, image: image, color: .systemGreen, action: nil, allowSelection: [false, true].randomElement()!)
            items.append(item)
        }
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.allowsSelection = true
        self.delegate = self
        setupDataSource()
        reloadSnapshot()
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelectionPrimaryAction == false {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = diffableDataSource.itemIdentifier(for: indexPath)
        let item = items.first(where: { $0.id == id })
        return item?.allowSelection ?? true
    }
    
    
    var items: [ImageAndTitleItem] = []
    var maxItemsCount: Int = 6
    
    var selectedItem: ImageAndTitleItem?
    
    func selectItem(_ item: ImageAndTitleItem) {
        
    }
    
    func selectItem(at id: Int) {
        
    }
    
    func setItems(_ items: [ImageAndTitleItem]) {
        
    }
    
    func insertItem(_ item: ImageAndTitleItem, needSaveLastItem: Bool) {
        
    }
    
    //MARK: - Data source
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
    
    private func reloadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UUID, UUID>()
        snapshot.appendSections([UUID()])
        snapshot.appendItems(items.map{ $0.id })
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
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
}
