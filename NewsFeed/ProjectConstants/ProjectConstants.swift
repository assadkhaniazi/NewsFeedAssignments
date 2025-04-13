import Foundation

class ProjectConstants {
    
    static let current = ProjectConstants()
    
    let ACCEPTANCE_URL = "https://api.nytimes.com/svc/mostpopular/v2"
    let STAGING_URL = "https://api.nytimes.com/svc/mostpopular/v2"
    let DEVELOPMENT_URL = "https://api.nytimes.com/svc/mostpopular/v2"
    let PRODUCTION_URL = "https://api.nytimes.com/svc/mostpopular/v2"
    let TESTING_URL = "https://api.nytimes.com/svc/mostpopular/v2"
    
    
    let GOOGLE_KEY = "Some Google Key"
    let GOOGLE_CLIENT_ID = "Google Client Id."
    
    //Privacy and policy URL
    let PRIVACY_AND_POLICY_URL = "Privacy And Policy Url"
    // Defaul Message String when Failed in Error
    let DEFAULT_ERROR_MESSAGE = "Sorry! Data couldn't be retrieved from Server."
    let DEFAULT_DELETE_ERROR_MESSAGE = "Sorry! Data couldn't be deleted from Server."
    let DEFAULT_POST_ERROR_MESSAGE = "Sorry! Data couldn't be posted to Server."
    
    
    func getBaseURL() -> String! {
        
        if ConfigurationManager.currentEnvironment == Environment.Acceptance {
            return self.ACCEPTANCE_URL
        }
        else if ConfigurationManager.currentEnvironment == Environment.Staging {
            return self.STAGING_URL
        }
        else if ConfigurationManager.currentEnvironment == Environment.Development {
            return self.DEVELOPMENT_URL
        }
        else if ConfigurationManager.currentEnvironment == Environment.Production {
            return self.PRODUCTION_URL
        }
        
        return TESTING_URL
    }
  
    
}
