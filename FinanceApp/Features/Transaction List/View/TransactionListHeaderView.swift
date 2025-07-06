
import UIKit

class TransactionListCollectionHeaderView: UICollectionReusableView {
    
    var text: String? { didSet { label.text = text } }
    
    private var label = UILabel()
    
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(DC.standartInset)
            maker.top.bottom.equalToSuperview()
        }
        label.font = DC.Font.medium(size: 18)
    }
}
