import UIKit
import Cosmos
import SDWebImage

final class BusinessListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var businessNameImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    typealias imageLoadInfo = (isToReload: Bool, image: Data)
    var imageCache = NSCache<NSURL, NSData>()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.businessNameImage.layer.cornerRadius = 10
        self.businessNameImage.clipsToBounds = true
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// To  configure the business list details
    func configure(business: Business) {
        businessNameImage.sd_setImage(with: URL(string:business.imageURL), completed: nil)
        nameLabel.text = business.name
        ratingView.rating = business.rating
        reviewCountLabel.text = String(format:"%@ Reviews", String(business.reviewCount))
        priceLabel.text = business.price
        distanceLabel.text = String(format: "%.2f mi",business.distance * 0.000621371)
        locationLabel.text = business.location.displayAddress.joined(separator: ", ")
        categoriesLabel.text = business.categories.map{$0.alias}.joined(separator: ", ")
    }
 
}
