
import Foundation
import UIKit

class Utils {
    
    static public func showAlert(vc : UIViewController,title:String,message:String,titleYesButton:String,onYesPress yes: @escaping () -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: titleYesButton, style: .default) { (action) in
            yes()
        }
        
        alert.addAction(yesAction)
        
        vc.present(alert, animated: true)
    }
    
    static public func showAlert(vc:UIViewController,message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    }
    
    static public func showNoInternetAlert(viewController: UIViewController, retryAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        
        // Settings action
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if success  {
                        retryAction()
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showNoInternetAlert(viewController: viewController, retryAction: retryAction)
                        }
                    }
                })
            }
        }
        alert.addAction(settingsAction)
        
        // Retry action
        let retryAlertAction = UIAlertAction(title: "Retry", style: .default) { _ in
            
            retryAction()
            
        }
        alert.addAction(retryAlertAction)
        
        // Present the alert
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

