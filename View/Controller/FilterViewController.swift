import UIKit

struct FilterBusinessList {
    var priceSelected: String = ""
    var isOpenNowSelected: Bool = true
}
final class FilterViewController: UIViewController {
    @IBOutlet weak var priceSegement: UISegmentedControl!
    @IBOutlet weak var openNowSwitch: UISwitch!
    var filterBusinessList: FilterBusinessList!
    var onCompletion: ((_ filter: FilterBusinessList) -> ())?
    private var priceSelected: String = "$"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Filter By"
        setPreviousSelection()
        setPreviousSelectionOpenNow()
    }
    
     /// To maintain the state of previous filter
    private func setPreviousSelection() {
        if let filterBusinessList = filterBusinessList {
            if filterBusinessList.priceSelected == "$" {
                priceSegement.selectedSegmentIndex = 0
                priceSelected = "$"
            } else if filterBusinessList.priceSelected == "$$" {
                priceSegement.selectedSegmentIndex = 1
                priceSelected = "$$"
            } else if filterBusinessList.priceSelected == "$$$" {
                priceSegement.selectedSegmentIndex = 2
                priceSelected = "$$$"
            }else if filterBusinessList.priceSelected == "$$$$" {
                priceSegement.selectedSegmentIndex = 3
                priceSelected = "$$$$"
            }
        } else{
            priceSegement.selectedSegmentIndex = 0
        }
    }
    
    /// To maintain the state of previous opennow
    private func setPreviousSelectionOpenNow() {
        if let filterBusinessList = filterBusinessList {
            openNowSwitch.isOn = filterBusinessList.isOpenNowSelected ?  true :  false
        }
    }
    
    /// Button action to select price
    @IBAction func priceSegmentAction() {
        switch priceSegement.selectedSegmentIndex {
        case 0:
            priceSelected = "$"
        case 1:
            priceSelected = "$$"
        case 2:
            priceSelected = "$$$"
        case 3:
            priceSelected = "$$$$"
        default:
            break
        }
    }
    
    /// Button action to apply filter
    @IBAction func applyFilterAction() {
        filterBusinessList = FilterBusinessList(priceSelected: priceSelected, isOpenNowSelected: openNowSwitch.isOn)
        onCompletion?(filterBusinessList)
        self.navigationController?.popViewController(animated: true)
    }
    
}
