import Foundation

class URLModifier {
    
    /// This is testing Modifier method you can replace with your requirements and add the required methods
    static func ModifiedGetNewsFeedUrl(getNewsFeed:GetNewsFeed) -> String {
        return "/mostviewed/all-sections/\(getNewsFeed.section).json"
    }
}
