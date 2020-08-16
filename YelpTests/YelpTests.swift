import XCTest
import Hippolyte
@testable import Yelp

class YelpTests: XCTestCase {
    private var presenter: BusinessListPresenter!
    private let mockView = MockBusinessView()
    
    /// To initialize the presenter
    override func setUp() {
        presenter = BusinessListPresenter(view: mockView)
    }
    
    /// To stop the mock server
    override func tearDown() {
        if Hippolyte.shared.isStarted {
            Hippolyte.shared.stop()
        }
        mockView.resetStates()
    }
    
    /// To setup mock server
    func setUpMockServer(url: String) {
        guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        var stub = StubRequest(method: .GET, url: url)
        var response = StubResponse()
        let path = Bundle(for: type(of: self)).path(forResource: "Sample", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let body = data
        response.body = body as Data
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
    }
    
    /// To setup mock server for failure cases
    func setUpMockServerFailure() {
        let response = StubResponse.Builder()
            .stubResponse(withError: NSError(domain: "", code: -1009, userInfo: nil))
            .build()
        let request = StubRequest.Builder()
            .stubRequest(withMethod: .GET, url: URL(string: String(format:RequestService.API_URL, ""))!)
            .addResponse(response)
            .build()
        Hippolyte.shared.add(stubbedRequest: request)
        Hippolyte.shared.start()
    }
    
    /// To test the businesslist success scenerio
    func testgetBusinessDetails_success(){
        setUpMockServer(url: String(format:RequestService.API_URL, ""))
        let expectation = self.expectation(description: "load businessdata")
        mockView.expectation = expectation
        presenter.loadBusinessDetails(location: "")
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(presenter.businessdata.count , 20, "The count of businessdata should be 20")
        XCTAssertEqual(presenter.businessdata[0].name , "Levain Bakery", "The name should be Levain Bakery")
        XCTAssertEqual(presenter.businessdata[0].price , "$$", "The price should be $$")
        XCTAssertEqual(presenter.businessdata[0].rating , 4.5, "The rating should be 4.5")
        XCTAssertEqual(presenter.businessdata[0].reviewCount , 8104, "The count of businessdata should be 20")
        XCTAssertFalse(presenter.businessdata[0].isClosed , "The count of businessdata should be 20")
        XCTAssertEqual(presenter.businessdata[0].distance , 8082.367282240455, "The distance should be 8082.367282240455")
        XCTAssertEqual(presenter.businessdata[0].location.city , "New York", "The city should be New York")
        XCTAssertEqual(presenter.businessdata[0].location.displayAddress[0] , "1484 3rd Ave", "The displayaddress should be 1484 3rd Ave")
        XCTAssertEqual(presenter.businessdata[0].categories[0].title , "Bakeries", "The title should be Bakeries")
        XCTAssertTrue(mockView.isShowLoadingPerformed, "The showLoading should be performed")
        XCTAssertTrue(mockView.isHideLoadingPerformed, "The hideLoading should be performed")
        XCTAssertTrue(mockView.isReloadDataPerformed, "The reloaddata should be performed")
    }
    
    /// To test the businesslist failure scenerio
    func testgetBusinessDetails_failure() {
        setUpMockServerFailure()
        let expectation = self.expectation(description: "load businessdata")
        mockView.expectation = expectation
        presenter.loadBusinessDetails(location: "")
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(mockView.isShowLoadingPerformed, "The showLoading should be performed")
        XCTAssertTrue(mockView.isShowErrorPerformed, "The showError should be performed")
        XCTAssertFalse(mockView.isReloadDataPerformed, "The reloaddata should not be performed")
        XCTAssertEqual(presenter.businessdata.count, 0, "The count of businessdata should be 0")
    }
    
    /// To test the businesslist sorting
    func testSortBusinessDetails() {
        setUpMockServer(url: String(format:RequestService.API_URL, ""))
        let expectation = self.expectation(description: "load businessdata")
        mockView.expectation = expectation
        presenter.loadBusinessDetails(location: "")
        wait(for: [expectation], timeout: 1)
        let sortReview = SortBusinessList(isRatingSelected: false, isReviewSelected: true, isDistanceSelected: false)
        let presenterReview = presenter.applySorting(sortBusinessList: sortReview, businessListData: presenter.businessdata)
        let sortRating = SortBusinessList(isRatingSelected: true, isReviewSelected: false, isDistanceSelected: false)
        let presenterRating = presenter.applySorting(sortBusinessList: sortRating, businessListData: presenter.businessdata)
        let sortDistance = SortBusinessList(isRatingSelected: false, isReviewSelected: false, isDistanceSelected: true)
        let presenterDistance = presenter.applySorting(sortBusinessList: sortDistance, businessListData: presenter.businessdata)
        XCTAssertEqual(presenterReview[0].reviewCount , 9967, "The review count should be 9967")
        XCTAssertEqual(presenterRating[0].rating , 5.0, "The rating should be 5.0")
        XCTAssertEqual(presenterDistance[0].distance , 1671.270457850173, "The distance should be 1671.270457850173")
    }
    
    /// To test the businesslist filter
    func testFilterBusinessDetails() {
        setUpMockServer(url: String(format:RequestService.API_URL, ""))
        let expectation = self.expectation(description: "load businessdata")
        mockView.expectation = expectation
        presenter.loadBusinessDetails(location: "")
        wait(for: [expectation], timeout: 1)
        let filter = FilterBusinessList(priceSelected: "$", isOpenNowSelected: true)
        let presenterFilter = presenter.applyFilter(filterBusinessList: filter, businessListData: presenter.businessdata)
        XCTAssertEqual(presenterFilter[0].price , "$", "The price should be $")
    }
}

class MockBusinessView: businessView {
    var expectation: XCTestExpectation?
    var isShowLoadingPerformed = false
    var isHideLoadingPerformed = false
    var isShowErrorPerformed = false
    var isReloadDataPerformed = false
    
    func resetStates() {
        isShowLoadingPerformed = false
        isHideLoadingPerformed = false
        isShowErrorPerformed = false
        isReloadDataPerformed = false
        expectation = nil
    }
    
    func reloadData(business: [Business]) {
        isReloadDataPerformed = true
        expectation?.fulfill()
    }
    
    func showError(error: Error) {
        isShowErrorPerformed = true
        expectation?.fulfill()
    }
    
    func showLoading() {
        isShowLoadingPerformed = true
    }
    
    func hideLoading() {
        isHideLoadingPerformed = true
    }
}
