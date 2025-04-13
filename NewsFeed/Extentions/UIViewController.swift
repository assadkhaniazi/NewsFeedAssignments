import Foundation
import UIKit
extension UIViewController {
    func dismissPresentedAlertIfAny(completion: (() -> Void)? = nil) {
        if let alert = presentedViewController as? UIAlertController {
            alert.dismiss(animated: true, completion: completion)
        } else {
            completion?()
        }
        
    }
}
