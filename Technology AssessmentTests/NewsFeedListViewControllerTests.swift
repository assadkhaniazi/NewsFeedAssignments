import XCTest
@testable import Technology_Assessment

// Mock ViewModel class to capture the parameters passed to getNewsFeedApi
class MockNewsFeedListViewModel: NewsFeedListViewModel {
    var getNewsFeedApiCalled = false
    var receivedGetNewsFeed: GetNewsFeed?

    override func getNewsFeedApi(getNewsFeed: GetNewsFeed) {
        getNewsFeedApiCalled = true
        receivedGetNewsFeed = getNewsFeed
    }
}

class NewsFeedListViewControllerTests: XCTestCase {

    var sut: NewsFeedListViewController!
    var mockViewModel: MockNewsFeedListViewModel!

    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "NewsFeedListViewController") as? NewsFeedListViewController
        mockViewModel = MockNewsFeedListViewModel()
        sut.viewModel = mockViewModel
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testTableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.newsFeedTableView)
    }

    func testViewModelIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.viewModel)
    }

    func testTableViewDataSourceIsSet() {
        XCTAssertTrue(sut.newsFeedTableView.dataSource is NewsFeedListViewController)
    }

    func testTableViewDelegateIsSet() {
        XCTAssertTrue(sut.newsFeedTableView.delegate is NewsFeedListViewController)
    }

    func testNumberOfRowsInSection() {
        sut.viewModel.resutlsArray = [makeMockResult(), makeMockResult(), makeMockResult()] // Mock data
        XCTAssertEqual(sut.tableView(sut.newsFeedTableView, numberOfRowsInSection: 0), 3)
    }

    func testGetNewsFeedFromApiIsCalledWithCorrectParameters() {
        // Arrange
        let expectedSection = "7"
        let expectedApiKey = "6ynxQYLWbjUxQp2S3uE2jSEqWvmoAWBZ"

        // Act
        sut.getNewsFeedFromApi()

        // Assert
        XCTAssertTrue(mockViewModel.getNewsFeedApiCalled, "getNewsFeedApi should be called")
        XCTAssertEqual(mockViewModel.receivedGetNewsFeed?.section, expectedSection, "Section parameter should match")
        XCTAssertEqual(mockViewModel.receivedGetNewsFeed?.apiKey, expectedApiKey, "API key parameter should match")
    }
    
    func makeMockResult() -> Result {
        let json: [String: Any] = [
            "uri": "nyt://article/1234567890",
            "url": "https://www.nytimes.com/2025/04/12/technology/example.html",
            "id": 123456,
            "asset_id": 654321,
            "published_date": "2025-04-12",
            "updated": "2025-04-12T10:00:00Z",
            "section": "Technology",
            "subsection": "Gadgets",
            "nytdsection": "technology",
            "adx_keywords": "Tech; Gadgets; NYTimes",
            "byline": "By Jane Doe",
            "type": "Article",
            "title": "Mocking Data for Testing",
            "abstract": "This is a mocked abstract for unit testing.",
            "media": [],
            "eta_id": 101
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(Result.self, from: jsonData)
        } catch {
            fatalError("Failed to decode mock Result: \(error)")
        }
    }
}

// Helper class to test navigation
class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
