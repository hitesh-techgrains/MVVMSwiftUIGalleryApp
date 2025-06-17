import SwiftUI

class ImageLoader: ObservableObject{
    @Published var image: UIImage?
    private let cache = ImageCache.shared
    
    
    func loadImage(from url: String) {
        if let cachedImage = cache.getImage(forKey: url) {
            image = cachedImage
            return
        }

        guard let imageURL = URL(string: url) else {
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, let loadImage = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async{
                self.cache.setImage(loadImage, forKey: url)
                self.image = loadImage
            }
        }.resume()
    }

    
}
