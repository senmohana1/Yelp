import UIKit

/// The business list class
final class BusinessListViewController: UIViewController {
    @IBOutlet weak var businessListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let AD_URL = "https://picsum.photos/800/%@"
    private let reuseIdentifier = "businessListTableViewCellReuseIdentifier"
    private let adReuseIdentifier = "adTableViewCellReuseIdentifier"
    private var presenter: BusinessListPresenter!
    private var businessListData = [Business]()
    private var sortBusinessList: SortBusinessList!
    private var filterBusinessList: FilterBusinessList!
    private var isSearching: Bool = false
    private lazy var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    private var filteredBusinessdata: [Business] = [] {
        didSet {
            var i = 0
            var count = 1
            while (i < filteredBusinessdata.count) {
                if count == 6 {
                    filteredBusinessdata.insert( Business(name: "", imageURL: "", reviewCount: 0, rating: 0, price: "", categories: [], distance: 0, location: Location(displayAddress: [], city: ""), isClosed: false), at: i)
                    count = 0
                }
                count = count + 1
                i = i + 1
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Yelp"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7647058824, green: 0.2156862745, blue: 0.1803921569, alpha: 1)
        initilizePresenter()
    }
    
    /// Initilize presenter
    private func initilizePresenter() {
        presenter = BusinessListPresenter(view: self)
    }
    
    /// Button action to sort the business list
    @IBAction func sortBusinessListAction() {
        let sortViewController = storyBoard.instantiateViewController(withIdentifier: "sortIdentifier") as! SortViewController
        sortViewController.sortBusinessList = sortBusinessList
        sortViewController.onCompletion =  { [weak self] (sort) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.sortBusinessList = sort
            strongSelf.filteredBusinessdata = strongSelf.presenter.applySorting(sortBusinessList: strongSelf.sortBusinessList, businessListData: strongSelf.businessListData)
            strongSelf.businessListTableView.reloadData()
        }
        self.navigationController?.pushViewController(sortViewController, animated: true)
    }
    
    /// Button action to filter the business list
    @IBAction func filterBusinessListAction() {
        let filterViewController = storyBoard.instantiateViewController(withIdentifier: "filterIdentifier") as! FilterViewController
        filterViewController.filterBusinessList = filterBusinessList
        filterViewController.onCompletion = { [weak self] (filter) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.filterBusinessList = filter
            strongSelf.filteredBusinessdata = strongSelf.presenter.applyFilter(filterBusinessList: strongSelf.filterBusinessList, businessListData: strongSelf.filteredBusinessdata)
            strongSelf.businessListTableView.reloadData()
        }
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
}

extension BusinessListViewController: businessView {
    
    /// To load the business list data
    func reloadData(business: [Business]) {
        businessListData = business
        sortBusinessList = SortBusinessList(isRatingSelected: false, isReviewSelected: false, isDistanceSelected: false)
        filterBusinessList = FilterBusinessList(priceSelected: "", isOpenNowSelected: false)
        filteredBusinessdata.removeAll()
        filteredBusinessdata.append(contentsOf: businessListData)
        DispatchQueue.main.async {
            self.businessListTableView.reloadData()
        }
    }
    
    /// To show error
    func showError(error: Error) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    /// To show the spinner
    func showLoading() {
        self.showSpinner(onView: self.view)
    }
    
    /// To hide the spinner
    func hideLoading() {
        self.removeSpinner()
    }
    
}

/// Data source for business list
extension BusinessListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  !filteredBusinessdata[indexPath.row].name.isEmpty {
            guard let businessListTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? BusinessListTableViewCell else { return UITableViewCell() }
            businessListTableViewCell.configure(business: filteredBusinessdata[indexPath.row])
            return businessListTableViewCell
        } else {
            guard let adTableViewCell = tableView.dequeueReusableCell(withIdentifier: adReuseIdentifier, for: indexPath) as? AdTableViewCell else { return UITableViewCell() }
            adTableViewCell.configure(url: String(format: AD_URL, String(indexPath.row * 100)))
            return adTableViewCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinessdata.count
    }
}

/// To search by city 
extension BusinessListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let location = searchBar.text {
            presenter.loadBusinessDetails(location: location)
        }
        searchBar.resignFirstResponder()
    }

}
