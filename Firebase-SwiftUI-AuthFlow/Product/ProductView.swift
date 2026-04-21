//
//  ProductView.swift
//  Firebase-SwiftUI-AuthFlow
//
//  Created by Amel Sbaihi on 4/20/26.
//

import SwiftUI

struct ProductView: View {
    @State var vm = ProductViewModel(service: ProductService())

    var body: some View {
        TabView {
            NavigationStack {
                Group {
                    if vm.isLoading {
                        ProgressView("Loading products...")
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
                            Image(systemName: "cart")
                                .font(.largeTitle)

                            Text("No products yet")
                                .font(.headline)

                            Text("Please check back later.")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        List(vm.products) { product in
                            ProductDetailsView(product: product)
                        }
                    }
                }
                .navigationTitle("Our Coffee Selection")
                .navigationBarTitleDisplayMode(.inline)
                .task {
                    await vm.fetchProducts()
                }
            }
            .tabItem {
                Label("Coffee", systemImage: "cup.and.saucer.fill")
            }
            NavigationStack {
                BookView()
            }
            .tabItem {
                Label("Books", systemImage: "book.fill")
            }

            NavigationStack {
                InfoSetting()
            }
            .tabItem {
                Label("Settings", systemImage: "person.crop.circle")
            }
            
           
        }
    }
}

#Preview {
    ProductView()
}
