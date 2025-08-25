import Foundation;
import SwiftUI;

struct CardView: View {
    let article: Article

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "photo").resizable().scaledToFit()
            }
            .frame(height: 200)
            .clipped()

            VStack(alignment: .leading) {
                Text(article.title).font(.headline)
                Text(article.author ?? article.source.name)
                    .font(.subheadline).foregroundStyle(.secondary)
                Text(article.description ?? "").font(.caption)
            }
            .padding()
        }
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.white).shadow(radius: 5))
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
