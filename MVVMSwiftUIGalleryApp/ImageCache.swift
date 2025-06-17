import Foundation
import SwiftUI

class ImageCache{
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init(){
        cache.totalCostLimit = 100
    }
    
    func getImage(forKey Key: String) -> UIImage?{
        return cache.object(forKey: NSString(string: Key))
    }
    
    func setImage(_ image: UIImage, forKey Key: String){
         cache.setObject(image, forKey: NSString(string: Key))
    }
    
    
}
