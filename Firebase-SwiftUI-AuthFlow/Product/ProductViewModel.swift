//
//  ProductViewModel.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/20/26.
//

import Foundation
@MainActor
@Observable
class ProductViewModel {
    
    var products : [Product] = []
    var isLoading : Bool = false
    var errorMessage : String? = nil
    
    private let service : ProductServiceProtocol
    
   
    var isEmpty: Bool {
        !isLoading && errorMessage == nil && products.isEmpty
    }
    
    init(service: ProductServiceProtocol) {
        self.service = service
    }
    func fetchProducts() async {

            isLoading = true

            errorMessage = nil

            do {

                products = try await service.fetchProducts()

            } catch {

                errorMessage = error.localizedDescription

            }

            isLoading = false

        }
}
