
import UIKit
import SnapKit

final class TransactionListContentView: UIView, UIContentView {
    var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private var imageBackgroundView = UIView()
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    
    init(configuration: any UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        imageBackgroundView.backgroundColor = conf.color
        imageView.image = conf.image
        titleLabel.text = conf.title
        subtitleLabel.text = conf.subtitle
        alpha = conf.isHighlighted ? 0.6 : 1
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        self.makeCornersAndShadow(radius: 12, opacity: 0.2)
        setupImageBackgroundView()
        setupImageView()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    private func setupImageBackgroundView() {
        addSubview(imageBackgroundView)
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.leading.top.bottom.equalToSuperview().inset(DC.innerItemSpacing)
            maker.width.equalTo(self.imageBackgroundView.snp.height)
        }
        
        imageBackgroundView.layer.cornerRadius = 8
    }
    
    private func setupImageView() {
        imageBackgroundView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(DC.innerItemSpacing)
        }
        
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.bottom.equalToSuperview()
            maker.leading.equalTo(self.imageBackgroundView.snp.trailing).offset(DC.innerItemSpacing)
        }
        titleLabel.snp.contentCompressionResistanceHorizontalPriority = 250
    
        titleLabel.font =  DC.Font.regular(size: 16)
    }
    
    private func setupSubtitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.bottom.equalToSuperview()
            maker.trailing.equalToSuperview().inset(DC.innerItemSpacing*2)
            maker.leading.equalTo(self.titleLabel.snp.trailing).priority(260)
        }
        subtitleLabel.snp.contentHuggingHorizontalPriority = 1000
        
        subtitleLabel.font =  DC.Font.semibold(size: 16)
        subtitleLabel.textColor = .secondaryLabel
    }
    
    private func getConfiguration() -> TransactionListConfiguration {
        if let conf = configuration as? TransactionListConfiguration {
            return conf
        }
        return TransactionListConfiguration()
    }
    
}
