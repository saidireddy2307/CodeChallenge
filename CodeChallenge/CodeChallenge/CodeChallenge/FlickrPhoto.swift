
import Foundation

struct FlickrPhoto: Codable, Identifiable {
    let id = UUID() 
    let title: String
    let link: String
    let media: [String: String]
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let tags: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, media, dateTaken = "date_taken", description, published, author, tags
    }
}

struct FlickrResponse: Codable {
    let items: [FlickrPhoto]
}
