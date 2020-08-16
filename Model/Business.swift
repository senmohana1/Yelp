import Foundation

/// Model for the business list
struct Businesses: Decodable {
    let businesses: [Business]
}

struct Business: Decodable {
    let name: String
    let imageURL: String
    let reviewCount: Int
    let rating: Double
    let price: String?
    let categories: [Category]
    let distance: Double
    let location: Location
    let isClosed: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case price
        case imageURL = "image_url"
        case reviewCount = "review_count"
        case isClosed = "is_closed"
        case rating
        case distance
        case location
        case categories
    }
   
}

struct Location: Decodable {
    let displayAddress: [String]
    let city: String
    enum CodingKeys: String, CodingKey {
        case displayAddress = "display_address"
        case city = "city"
    }
}

struct Category: Codable {
    let alias, title: String
}


