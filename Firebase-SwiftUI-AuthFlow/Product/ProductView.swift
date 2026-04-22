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
        ZStack {
            FluidModernBackground()
                .ignoresSafeArea()

            TabView {
                NavigationStack {
                    ZStack {
                        FluidModernBackground()
                            .ignoresSafeArea()

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
                                ScrollView{
                                    LazyVStack(spacing: 16) {
                                        ForEach(vm.products) { product  in
                                            ProductDetailsView(product: product)
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
                    }
                    .navigationTitle("Our Coffee Selection")
                    .navigationBarTitleDisplayMode(.inline)
                    .task {
                        await vm.fetchProducts()
                    }
                    .background(Color.clear)
                }
                .background(Color.clear)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbarBackground(.hidden, for: .tabBar)
                .tabItem {
                    Label("Coffee", systemImage: "cup.and.saucer.fill")
                }
                NavigationStack {
                    ZStack {
                        FluidModernBackground()
                            .ignoresSafeArea()

                        BookView()
                    }
                }
                .background(Color.clear)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbarBackground(.hidden, for: .tabBar)
                .tabItem {
                    Label("Books", systemImage: "book.fill")
                }

                NavigationStack {
                    ZStack {
                        FluidModernBackground()
                            .ignoresSafeArea()

                        InfoSetting()
                    }
                }
                .background(Color.clear)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbarBackground(.hidden, for: .tabBar)
                .tabItem {
                    Label("Settings", systemImage: "person.crop.circle")
                }
                
               
            }
            .background(Color.clear)
        }
    }
}

#Preview {
    ProductView()
}
