
import UIKit

class ImageAndTitleCollectionContentView: UIControl, UIContentView {
    var configuration: any UIContentConfiguration
    
    var imageBackgroundView = UIView()
    var imageView = UIImageView()
    var titleLabel = UILabel()
    
    init(configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        self.makeCornersAndShadow()
        setupImageBackgroundView()
        setupTitleLabel()
        setupImageView()
    }
    
    private func setupImageBackgroundView() {
        addSubview(imageBackgroundView)
        imageBackgroundView.makeCornersAndShadow(radius: 10, color: .clear, opacity: 0)
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalToSuperview().inset(DC.innerItemSpacing + 3)
            maker.leading.trailing.equalToSuperview().inset(DC.innerItemSpacing + 3)
            maker.height.equalTo(self.imageBackgroundView.snp.width)
        }
        imageBackgroundView.backgroundColor = .systemMint
    }
    
    private func getConfiguration() -> ImageAndTitleCollectionConfiguration {
        if let conf = configuration as? ImageAndTitleCollectionConfiguration { return conf }
        return ImageAndTitleCollectionConfiguration()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.imageBackgroundView.snp.bottom).offset(DC.innerItemSpacing)
            maker.leading.trailing.equalToSuperview().inset(DC.innerItemSpacing)
            maker.bottom.equalToSuperview().inset(DC.innerItemSpacing)
        }
        titleLabel.snp.contentHuggingVerticalPriority = 1000
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        titleLabel.text = "Транспорт"
    }
    
    private func setupImageView() {
        imageBackgroundView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(DC.innerItemSpacing + 3)
        }
        imageView.image = UIImage(systemName: "trash")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(hierarchicalColor: .systemBackground))
    }

}
