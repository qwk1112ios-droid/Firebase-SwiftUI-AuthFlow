//
//  BookService.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/21/26.
//

import Foundation
import FirebaseFirestore

 protocol BookServiceProtocol {
   func fetchBooks() async throws -> [Book]
}

class BookService: BookServiceProtocol {
    let db = Firestore.firestore()
    
    public init() {}
    
    func fetchBooks() async throws -> [Book] {
        let snapshot = try await db.collection("Books").getDocuments()
        
        return snapshot.documents.compactMap { document in
            
            try? document.data(as: Book.self)
            
        }
    }
    
    
}
    
   
   
    

