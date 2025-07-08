
import UIKit

class MenuCellContentView: UIView, UIContentView {
    var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private var titleLabel = UILabel()
    private var imageView = UIImageView()
    
    convenience init(configuration: any UIContentConfiguration) {
        self.init(frame: .zero)
        self.configuration = configuration
    }
    
    override init(frame: CGRect) {
        configuration = MenuCellConfiguration()
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        titleLabel.text = conf.title
        imageView.image = conf.image
        alpha = conf.isSelected ? 0.6 : 1
    }
    
    private func setupUI() {
        setupTitleLabel()
        setupImageView()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(10)
            maker.leading.equalToSuperview().inset(15)
        }
        titleLabel.snp.contentCompressionResistanceHorizontalPriority = 250
        
        titleLabel.font = DC.Font.regular(size: 18)
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.bottom.equalToSuperview().inset(DC.innerItemSpacing)
            maker.width.equalTo(imageView.snp.height)
            maker.trailing.equalToSuperview().inset(DC.innerItemSpacing)
            maker.leading.equalTo(self.titleLabel.snp.trailing).priority(500)
        }
        
        imageView.contentMode = .scaleAspectFit
    }
    
    private func getConfiguration() -> MenuCellConfiguration {
        if let conf = configuration as? MenuCellConfiguration { return conf }
        return MenuCellConfiguration()
    }
}
