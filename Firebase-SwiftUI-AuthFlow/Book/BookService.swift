//
//  BookService.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/21/26.
//

import Foundation
import FirebaseFirestore

public protocol BookServiceProtocol {
   func fetchBooks() async throws -> Void
}

class BookService: BookServiceProtocol {
    
    public init() {}
    let db = Firestore.firestore()
    
    public func fetchBooks() async throws {
        
    }
   
    func fetchBooks() async throws -> [Book] {
       
        let snapshot = try await db.collection("products").getDocuments()

               return snapshot.documents.compactMap { document in

                   try? document.data(as: Book.self)

               }
        
        
    }
}

