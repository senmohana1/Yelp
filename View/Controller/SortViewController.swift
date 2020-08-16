import UIKit

struct SortBusinessList {
    var isRatingSelected: Bool = false
    var isReviewSelected: Bool = false
    var isDistanceSelected: Bool = false
}

final class SortViewController: UIViewController {
    @IBOutlet weak var ratingSwitch: UISwitch!
    @IBOutlet weak var reviewSwitch: UISwitch!
    @IBOutlet weak var distanceSwitch: UISwitch!
    var sortBusinessList: SortBusinessList!
    var onCompletion: ((_ sort: SortBusinessList) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sort By"
        setPreviousSelection()
    }
    
    /// To maintain the state of previous sorting
    private func setPreviousSelection() {
        if let sortBusinessList = sortBusinessList {
            if sortBusinessList.isDistanceSelected == true {
                distanceSwitch.isOn = true
            }
            if sortBusinessList.isRatingSelected == true {
                ratingSwitch.isOn = true
            }
            if sortBusinessList.isReviewSelected == true {
                reviewSwitch.isOn = true
            }
        }
    }
    
    /// Button action to apply sorting
    @IBAction func applyAction() {
        sortBusinessList = SortBusinessList(isRatingSelected: ratingSwitch.isOn, isReviewSelected: reviewSwitch.isOn, isDistanceSelected: distanceSwitch.isOn)
        onCompletion?(sortBusinessList)
        self.navigationController?.popViewController(animated: true)
    }
}
