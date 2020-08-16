import UIKit

private var spinnerView : UIView?
private let activityIndicatorView = UIActivityIndicatorView.init(style:.large)

extension UIViewController {
    
    /// To show ActivityIndicatorView
    func showSpinner(onView : UIView) {
        let view = UIView.init(frame: onView.bounds)
        view.backgroundColor = .clear
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = view.center
        DispatchQueue.main.async {
            view.addSubview(activityIndicatorView)
            onView.addSubview(view)
        }
        spinnerView = view
    }
    
    /// To hide ActivityIndicatorView
    func removeSpinner() {
        DispatchQueue.main.async {
            activityIndicatorView.stopAnimating()
            spinnerView?.removeFromSuperview()
            spinnerView = nil
        }
    }
}
