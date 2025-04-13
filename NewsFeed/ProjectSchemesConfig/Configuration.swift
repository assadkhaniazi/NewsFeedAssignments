import Foundation

enum Environment : String {
    case Acceptance = "Acceptance"
    case Staging = "Staging"
    case Development = "Development"
    case Production = "Production"
}

class ConfigurationManager {
    
    static var isProduction  : Bool {
        get {
            
            if self.currentEnvironment == Environment.Production {
                return true
            }
            else {
                return false
            }
        }
    }
    
    static let currentEnvironment = Environment(rawValue: Bundle.main.object(forInfoDictionaryKey: "Config") as! String )
    
}
