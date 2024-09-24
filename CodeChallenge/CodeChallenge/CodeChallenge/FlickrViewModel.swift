
import Foundation
import Combine

class FlickrViewModel: ObservableObject {
    @Published var photos: [FlickrPhoto] = []
    @Published var isLoading = false
    private var cancellable: AnyCancellable?

    func fetchPhotos(searchText: String, completion: @escaping () -> Void) {
        let searchUrl = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(searchText)"
        
        guard let url = URL(string: searchUrl) else {
            print("Invalid URL")
            return
        }
        
        isLoading = true
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .replaceError(with: FlickrResponse(items: []))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.photos = response.items
                self?.isLoading = false
            }
        completion()

    }
    
}
