import Foundation
import SwiftUI

struct FlickrPhotoDetailView: View {
    let photo: FlickrPhoto
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: photo.media["m"] ?? "")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 300, height: 300)
            
            Text(photo.title)
                .font(.title)
                .padding(.top)
            
            Text(photo.author)
                .font(.subheadline)
                .padding(.top)
            
            Text(convertHTMLToPlainText(html: photo.description))
                .padding(.top)
            
            Text("Published on \(formattedDate(photo.published))")
                .padding(.top)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Photo Details")
    }
    
    func formattedDate(_ dateStr: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateStr) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        return dateStr
    }
    
    func convertHTMLToPlainText(html: String) -> String {
        guard let data = html.data(using: .utf8) else { return html }
        
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil) {
            
            return attributedString.string
        } else {
            return html
        }
    }
}
