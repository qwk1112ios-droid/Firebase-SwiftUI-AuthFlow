//
//  BookViewModel.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/21/26.
//

import Foundation

@MainActor
@Observable class BookViewModel {
    var books: [Book] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    let bookService : BookServiceProtocol
    var isEmpty: Bool {
        !isLoading && errorMessage == nil && books.isEmpty
    }
    
    init(bookService: BookServiceProtocol ) {
        self.bookService = bookService
    }
    
    func fetchBooks() async {

            isLoading = true

            errorMessage = nil

            do {

                books = try await bookService.fetchBooks()

            } catch {

                errorMessage = error.localizedDescription

            }

            isLoading = false

        }
}
