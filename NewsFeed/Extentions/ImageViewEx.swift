import UIKit

private let imageCache = NSCache<NSString, UIImage>() // Shared cache

extension UIImageView {

    func loadImage(imageUrl: String, activityIndicator: UIActivityIndicatorView? = nil) {
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()

        loadImageFromCache(from: imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                activityIndicator?.stopAnimating()
                activityIndicator?.isHidden = true
                if let image = image {
                    self?.image = image
                } else {
                    dump("Image failed to load")
                }
            }
        }
    }

    private func loadImageFromCache(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check if image is already cached
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }

        // Download the image
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            // Save to cache and return
            imageCache.setObject(image, forKey: urlString as NSString)
            completion(image)
        }.resume()
    }
}
