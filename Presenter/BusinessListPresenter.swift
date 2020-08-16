import Foundation

/// Protocol for Businesslist
protocol businessView: class {
    func reloadData(business : [Business])
    func showError(error: Error)
    func showLoading()
    func hideLoading()
}

/// Presenter for Businesslist
final class BusinessListPresenter {
    private unowned let view: businessView
    private(set) var businessdata = [Business]()
    init(view: businessView) {
        self.view = view
    }
    
    /// The load business details method to be called from view
    func loadBusinessDetails(location: String) {
        getBusinessDetails(location: location)
    }
    
    /// The get business details  method to get data from service layer
    private func getBusinessDetails(location: String) {
        self.view.showLoading()
        RequestService.shared.getBusinessDetails(location: location) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success((let response, let data)):
                strongSelf.view.hideLoading()
                guard  let response = response as? HTTPURLResponse else {
                    return
                }
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        strongSelf.businessdata = try decoder.decode(Businesses.self, from: data).businesses
                        strongSelf.view.reloadData(business: strongSelf.businessdata)
                    }catch let error{
                        strongSelf.view.hideLoading()
                        strongSelf.view.showError(error: error)
                    }
                } else {
                    strongSelf.view.hideLoading()
                    strongSelf.view.showError(error: NSError(domain: "", code: response.statusCode, userInfo: nil))
                }
            case .failure(let error):
                strongSelf.view.hideLoading()
                strongSelf.view.showError(error: error)
            }
        }
    }
    
    /// To apply sorting
    func applySorting(sortBusinessList: SortBusinessList? , businessListData: [Business]) -> [Business]  {
        var businessListData = businessListData
        if let sortBusinessList = sortBusinessList {
            if sortBusinessList.isDistanceSelected && sortBusinessList.isReviewSelected && sortBusinessList.isRatingSelected {
                businessListData = businessListData.sorted {
                    ($0.rating , $0.reviewCount, $0.distance) > ($1.rating , $1.reviewCount, $1.distance)
                }
            } else if !sortBusinessList.isDistanceSelected && sortBusinessList.isReviewSelected && sortBusinessList.isRatingSelected {
                businessListData = businessListData.sorted {
                    ($0.rating , $0.reviewCount) > ($1.rating , $1.reviewCount)
                }
            }else if sortBusinessList.isDistanceSelected && !sortBusinessList.isReviewSelected && sortBusinessList.isRatingSelected {
                businessListData = businessListData.sorted {
                    ($0.rating , $0.distance) > ($1.rating , $1.distance)
                }
            } else if sortBusinessList.isDistanceSelected && sortBusinessList.isReviewSelected && !sortBusinessList.isRatingSelected {
                businessListData = businessListData.sorted{
                    ($0.reviewCount, $0.distance) > ($1.reviewCount, $1.distance)
                }
            } else if !sortBusinessList.isDistanceSelected && !sortBusinessList.isReviewSelected && sortBusinessList.isRatingSelected {
                businessListData = businessListData.sorted {
                    ($0.rating) > ($1.rating)
                }
            }else if sortBusinessList.isDistanceSelected && !sortBusinessList.isReviewSelected && !sortBusinessList.isRatingSelected {
                businessListData = businessListData.sorted {
                    ($0.distance) < ($1.distance)
                }
            } else if !sortBusinessList.isDistanceSelected && sortBusinessList.isReviewSelected && !sortBusinessList.isRatingSelected {
                businessListData = businessListData.sorted {
                    ($0.reviewCount) > ($1.reviewCount)
                }
            }
        }
        return businessListData
    }
    
    /// To apply filter
    func applyFilter(filterBusinessList: FilterBusinessList? , businessListData: [Business]) -> [Business] {
        var businessListData = businessListData
        if let filterBusinessList = filterBusinessList {
            if (filterBusinessList.isOpenNowSelected && !filterBusinessList.priceSelected.isEmpty)   {
                businessListData = businessListData.filter({$0.price == filterBusinessList.priceSelected && $0.isClosed == !filterBusinessList.isOpenNowSelected })
            } else if (!filterBusinessList.isOpenNowSelected && !filterBusinessList.priceSelected.isEmpty)   {
                businessListData = businessListData.filter({$0.price == filterBusinessList.priceSelected})
            }
        }
        return businessListData
    }
}
