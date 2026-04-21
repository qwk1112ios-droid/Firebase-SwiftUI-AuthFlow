//
//  Book.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/21/26.
//

import Foundation
import FirebaseFirestore

struct Book : Codable , Identifiable {
    @DocumentID var id: String?
    let title : String
    let author : String
    let price: Double
    let rating: Double
    let description: String
    let imageUrl: String
    var inStock : Bool 
}
