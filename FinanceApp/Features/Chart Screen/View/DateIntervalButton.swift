
import UIKit
import Foundation

class DateIntervalButton: UIButton {
    
    var interval = DateInterval() { didSet { updateTitle() } }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration = UIButton.Configuration.plain()
        updateTitle()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConfiguration() {
        updateTitle()
    }
    
    private func updateTitle() {
        var conf = self.configuration
        conf?.attributedTitle = getAttributedTitle(for: interval)
        self.configuration = conf
    }
    
    private func getAttributedTitle(for interval: DateInterval) -> AttributedString {
        let text = getIntervalString(interval)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.setAttributes([
            .font:  DC.Font.semibold(size: 14),
            .foregroundColor: self.isHighlighted ? UIColor.label.withAlphaComponent(0.4) : UIColor.label.withAlphaComponent(1),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: NSRange(location: 0, length: attributedText.length))
        return AttributedString(attributedText)
    }
    
    private func getIntervalString(_ interval: DateInterval) -> String {
        let start = interval.start.formatted(.dateTime.day(.defaultDigits).month(.abbreviated).year(.defaultDigits))
        let end = interval.end.formatted(.dateTime.day(.defaultDigits).month(.abbreviated).year(.defaultDigits))
        if isIntervalDay() { return start }
        return "\(start) - \(end)"
    }
    
    private func isIntervalDay() -> Bool {
        return self.interval.duration == 86400
    }
    
}

