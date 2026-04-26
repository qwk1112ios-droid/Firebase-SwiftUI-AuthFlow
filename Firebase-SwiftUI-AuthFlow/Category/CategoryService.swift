//
//  CategoryService.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/26/26.
//

import Foundation
import FirebaseFirestore

protocol CategoryServiceProtocol {
    func fetchCategory() async throws -> [CategoryItem]
}

final class CategoryService : CategoryServiceProtocol {
    let db = Firestore.firestore()
    func fetchCategory() async throws -> [CategoryItem] {
       
        let snapshot = try await db.collection("categories").getDocuments()

               return snapshot.documents.compactMap { document in

                   try? document.data(as: CategoryItem.self)

               }
        
        
    }
}
