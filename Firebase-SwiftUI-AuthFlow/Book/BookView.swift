//
//  BookView.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/21/26.
//

import SwiftUI

struct BookView: View {
    @State var vm = BookViewModel(bookService: BookService())

    var body: some View {
        ZStack {
            FluidModernBackground()
                .ignoresSafeArea()

            NavigationStack {
                Group {
                    if vm.isLoading {
                        ProgressView("Loading books...")
                    } else if let errorMessage = vm.errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: "wifi.exclamationmark")
                                .font(.largeTitle)

                            Text("Something went wrong")
                                .font(.headline)

                            Text(errorMessage)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } else if vm.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "books.vertical")
                                .font(.largeTitle)

                            Text("No books yet")
                                .font(.headline)

                            Text("Please check back later.")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        ScrollView{
                            LazyVStack(spacing: 16) {
                                ForEach(vm.books) { book in
                                    BookRowView(book: book)
                                        .padding(12)
                                        .background(.white.opacity(0.55))
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 20)
                                        )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            .padding(.bottom, 24)
                        }
                    }
                }
                .navigationTitle("Our Book Selection")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    await vm.fetchBooks()
                }
            }
            .background(Color.clear)
        }
    }
}

#Preview {
    BookView()
}
