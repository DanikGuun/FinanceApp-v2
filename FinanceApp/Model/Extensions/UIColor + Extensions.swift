
import UIKit

extension UIColor{
    
    var data: Data {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let comps = [red, green, blue, alpha]
        return comps.withUnsafeBufferPointer { return Data(buffer: $0) }
        
    }
    
    convenience init?(data: Data){
        
        guard data.count == MemoryLayout<CGFloat>.size * 4 else { return nil }
        var components = Array(repeating: CGFloat(0), count: 4)
        
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            let pointer = bytes.baseAddress!.assumingMemoryBound(to: CGFloat.self)
            for i in 0..<4 {
                components[i] = pointer[i]
            }
        }

        self.init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
    
}
