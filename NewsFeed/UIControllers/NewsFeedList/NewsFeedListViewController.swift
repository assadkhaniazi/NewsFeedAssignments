
import UIKit

class NewsFeedListViewController: BaseViewController {
    
    
    @IBOutlet weak var newsFeedTableView: UITableView!{
        didSet{
            newsFeedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            newsFeedTableView.register(NewsFeedCell.nib, forCellReuseIdentifier: NewsFeedCell.identifier)
        }
    }
    
    private var hasRegisteredForActiveNotification = false
    internal var viewModel = NewsFeedListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewController()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !hasRegisteredForActiveNotification {
            hasRegisteredForActiveNotification = true
            NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    //MARK: - OBJC MEthods
    @objc func appDidBecomeActive() {
        // Check network status when app becomes active
        self.viewModel.errorStatusCode.value = 500//Re-using 500 code as to handle the condition where user goes to wifi screen but doesn't conect to wifi and returns to application
    }
    
    //MARK: - Methods
    private func setUpViewController(){
        setUpBindings()
        setUpData()
        
    }
    
    
    private func setUpBindings(){
        self.bindingGetNewsFeed()
        self.bindingServerErrorResponseForNewsFeed()
        self.bindingServerCompletionResponseForNewsFeed()
        self.failureErrorCodeBinding()
    }
    
    private func setUpData(){
        defer{
            self.newsFeedTableView.reloadData()
        }
        
        self.getNewsFeedFromApi()
    }
    
    private func showNointernetAlert() {
        Utils.showNoInternetAlert(viewController: self) {
            // Retry action: Code to retry the internet-dependent task
            self.retryInternetTask()
        }
    }
    
    
    
    private func retryInternetTask() {
        // Your code to retry the internet-dependent task
        self.showActivityIndicator()
        self.getNewsFeedFromApi()
    }
    
    internal func getNewsFeedFromApi(){
        let obj = BuilderForGetNewsFeed()
        obj.section = KeyConstants.SectionKey//Can be 7 or 30
        obj.apiKey = KeyConstants.NewsFeedApiKey
        viewModel.getNewsFeedApi(getNewsFeed: obj.build())
    }
    
    func navigateToNewsFeedDetail(with newsFeed: Result) {
        let detailVC = UIStoryboard.NewsFeedDetailVC
        detailVC.setData(data: newsFeed)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
//MARK: - NewsFeed TableView Delegate And DataSource
extension NewsFeedListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.resutlsArray?.count ?? 0
        if count == 0 {
            showActivityIndicator()
        } else {
            removeActivityIndicator()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.identifier, for: indexPath) as! NewsFeedCell
        cell.setUpCellForNewsFeed(result: self.viewModel.resutlsArray?[indexPath.row], indexRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedNewsFeed = self.viewModel.resutlsArray?[indexPath.row]{
            navigateToNewsFeedDetail(with: selectedNewsFeed)
        }
        
    }
}

//MARK: - API Bindings
extension NewsFeedListViewController{
    //MARK: - Binding CardDetails Response
    private func bindingGetNewsFeed() {
        self.viewModel.responseNewsFeed.bind {
            if ($0 != nil && ($0?.results?.count ?? 0) > 0 ){
                defer{
                    self.dismissPresentedAlertIfAny()
                    self.newsFeedTableView.reloadData()
                }
                self.viewModel.resutlsArray =  $0?.results
            }
        }
    }
    //MARK: - Binding Error Response
    private func bindingServerErrorResponseForNewsFeed(){
        self.viewModel.responseNewsFeedError.bind {
            if ($0 != nil) {
                Utils.showAlert(vc: self, message: $0?.fault?.faultstring ?? "something went wrong")
            }
        }
    }
    
    
    //MARK: - Binding Complete Response
    private func bindingServerCompletionResponseForNewsFeed(){
        self.viewModel.completeResponse.bind {
            if ($0 != nil) {
                //Api call completed handle code
                self.removeActivityIndicator()
            }
        }
        
        
        
    }
    
    private func failureErrorCodeBinding(){
        self.viewModel.errorStatusCode.bind {
            if ($0 != nil) {
                if $0 == 500 && self.viewModel.resutlsArray?.isEmpty == true  || $0 == 404{
                    //Its mean wifi was connected api was called but betweeen call wifi disconnected now screen is empty
                    //you can handle specific codes here for api
                    self.showNointernetAlert()
                }
            }
            
        }
    }
}
