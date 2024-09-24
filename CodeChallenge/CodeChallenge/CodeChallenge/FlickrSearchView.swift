import SwiftUI

struct FlickrSearchView: View {
    @ObservedObject var viewModel = FlickrViewModel()
    @State private var searchText = ""

    var body: some View {
        VStack {
            TextField("Search images", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) { newValue in
                    if !newValue.isEmpty {
                        viewModel.fetchPhotos(searchText: newValue) {
                            print("Search completed for: \(newValue)")
                        }
                    }
                }

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                List(viewModel.photos) { photo in
                    NavigationLink(destination: FlickrPhotoDetailView(photo: photo)) {
                        HStack {
                            AsyncImage(url: URL(string: photo.media["m"] ?? "")) { image in
                                image.resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)

                            VStack(alignment: .leading) {
                                Text(photo.title)
                                    .font(.headline)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)

                                Text(photo.author)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Flickr Image Search")
        .onAppear {
            if searchText.isEmpty {
                viewModel.fetchPhotos(searchText: "porcupine") {
                    print("porcupine")
                }
            }
        }
    }
}
