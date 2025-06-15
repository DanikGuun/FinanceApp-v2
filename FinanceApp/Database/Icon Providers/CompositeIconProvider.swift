
final class CompositeIconProvider: IconProvider {
    
    var iconProviders: [IconProvider]
    
    init(iconProviders: [IconProvider]) {
        self.iconProviders = iconProviders
    }
    
    static func getInstance() -> IconProvider {
        return CompositeIconProvider(iconProviders: [])
    }
    
    func getIcons() -> [any Icon] {
        return iconProviders.reduce([], { $0 + $1.getIcons() })
    }
    
    func getIcon(id: String) -> (any Icon)? {
        for provider in iconProviders {
            if let icon = provider.getIcon(id: id) {
                return icon
            }
        }
        return nil
    }
    
    func getIconsWithKind() -> [IconKind : [any Icon]] {
        var dict: [IconKind : [any Icon]] = [:]
        for provider in iconProviders {
            let currentDict = provider.getIconsWithKind()
            dict.merge(currentDict, uniquingKeysWith: { $0 + $1 })
        }
        return dict
    }
    
}
