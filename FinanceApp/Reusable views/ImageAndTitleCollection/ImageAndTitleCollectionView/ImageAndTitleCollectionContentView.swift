
import UIKit

class ImageAndTitleCollectionContentView: UIView, UIContentView {
    var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
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
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        imageBackgroundView.backgroundColor = conf.item?.color
        imageView.image = conf.item?.image
        titleLabel.text = conf.item?.title
        animateFade(isIn: conf.isSelected || conf.isHighlighted)
    }
    
    private func setupUI() {
        self.backgroundColor = .systemBackground
        self.layer.borderColor = UIColor.clear.cgColor
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
        imageBackgroundView.isUserInteractionEnabled = false
        imageBackgroundView.contentMode = .scaleAspectFit
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
        titleLabel.font = UIFont(name: "SF Pro Rounded Regular", size: 15)
        titleLabel.isUserInteractionEnabled = false
    }
    
    private func setupImageView() {
        imageBackgroundView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(DC.innerItemSpacing + 7)
        }
        imageView.isUserInteractionEnabled = false
        imageBackgroundView.tintColor = .systemBackground
    }
    
    func animateFade(isIn: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundColor = isIn ? .systemGray4 : .systemBackground
            self.layer.borderWidth = isIn ? 2 : 0
            self.layer.borderColor = isIn ? UIColor.systemGray3.cgColor : UIColor.clear.cgColor
        })
    }
    
    func getConfiguration() -> ImageAndTitleCollectionConfiguration {
        if let conf = configuration as? ImageAndTitleCollectionConfiguration { return conf }
        return ImageAndTitleCollectionConfiguration()
    }

}
