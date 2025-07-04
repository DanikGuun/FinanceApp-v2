
import Foundation
import UIKit

protocol IconPickerModel {
    func getSections() -> [IconPickerSection]
}

class BaseIconPickerModel: IconPickerModel {
    
    let iconProvider: IconProvider
    var color: UIColor = .systemBlue
    
    init(iconProvider: IconProvider, startColor: UIColor) {
        self.iconProvider = iconProvider
        self.color = startColor
    }
    
    func getSections() -> [IconPickerSection] {
        let sections = iconProvider.getIconsWithKind().map { (section, icons) in
            let icons = icons.map { IconPickerItem(iconId: $0.id, color: color, image: $0.image) }
            return IconPickerSection(title: section.rawValue, icons: icons)
        }
        return sections
    }
    
}

public struct IconPickerSection: Identifiable {
    public let id = UUID()
    public var title = ""
    public var icons: [IconPickerItem] = []
}

public struct IconPickerItem: Identifiable {
    public let id = UUID()
    public var iconId = ""
    public var color = UIColor.systemBlue
    public var image = UIImage()
}

