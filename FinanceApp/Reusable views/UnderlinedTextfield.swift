
import UIKit

class UnderlinedTextfield: UITextField {
    
    var rightUnderlineOffset: CGFloat = 8 { didSet { updateUnderline() } }
    var leftUnderlineOffset: CGFloat = 4 { didSet { updateUnderline() } }
    var underlineWidth: CGFloat = 2 { didSet { updateUnderline() } }
    
    private var underline = UIView()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextfield()
        setupUnderline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextfield() {
        font = DC.Font.regular(size: 16)
    }
    
    private func setupUnderline() {
        self.addSubview(underline)
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.top.equalTo(self.snp.bottom)
            maker.height.equalTo(self.underlineWidth)
            maker.leading.equalToSuperview().offset(-self.leftUnderlineOffset).priority(.medium)
            maker.trailing.equalToSuperview().offset(self.rightUnderlineOffset).priority(.medium)
        }
        
        underline.backgroundColor = .systemGray3
        underline.layer.cornerRadius = underlineWidth / 2
    }
    
    private func updateUnderline() {
        underline.snp.updateConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.height.equalTo(self.underlineWidth)
            maker.leading.equalToSuperview().offset(-self.leftUnderlineOffset).priority(.medium)
            maker.trailing.equalToSuperview().offset(self.rightUnderlineOffset).priority(.medium)
        }
    }
    
}
