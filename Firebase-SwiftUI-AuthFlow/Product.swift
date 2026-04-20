//
//  Product.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/19/26.
//

import Foundation
import FirebaseFirestore

struct Product: Identifiable, Codable {
    @DocumentID  var id: String?
    let title: String
    let description : String
    let price : Double
}
