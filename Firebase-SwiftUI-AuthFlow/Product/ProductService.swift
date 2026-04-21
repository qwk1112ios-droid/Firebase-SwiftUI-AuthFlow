//
//  ProductService.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/20/26.
//

import Foundation
import FirebaseFirestore

protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
}

final class ProductService: ProductServiceProtocol {
    let db = Firestore.firestore()
    func fetchProducts() async throws -> [Product] {
       
        let snapshot = try await db.collection("products").getDocuments()

               return snapshot.documents.compactMap { document in

                   try? document.data(as: Product.self)

               }
        
        
    }
}
