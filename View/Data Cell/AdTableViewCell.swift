import UIKit
import SDWebImage

final class AdTableViewCell: UITableViewCell {
    @IBOutlet weak var adImageView: UIImageView!
    
    /// To configure the Ad image
   func configure(url: String) {
    self.adImageView.sd_setImage(with: URL(string: url), completed: nil)
    }
}
