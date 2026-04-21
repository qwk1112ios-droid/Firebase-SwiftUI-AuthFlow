//
//  BookRowView.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/21/26.
//

import SwiftUI

struct BookRowView: View {
    let book: Book

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: book.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 70, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {
                Text(book.title)
                    .font(.headline)

                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("$\(book.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    BookRowView(book: Book(title: "hello", author: "world", price: 0.00, rating: 5.0, description: "hello world", imageUrl: "No Image", inStock: true))
}
