//
//  ContentView.swift
//  MVVMSwiftUIGalleryApp
//
//  Created by admin on 16/06/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var picsViewModel: PicsViewModel
    
    // Define grid columns — 2 columns side by side
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()), // add more if you want
        GridItem(.flexible()) // add more if you want
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(picsViewModel.picsModel, id: \.id) { model in
                        NavigationLink(destination: AsyncPicsImageView(url: model.downloadUrl ?? "", isDetailView: true)
                            .ignoresSafeArea()) {
                                
                                GalleryItemView(model: model)
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Gallery")
            .onAppear {
                print("onAppear")
                picsViewModel.lodData()
            }
        }
    }
}

struct GalleryItemView: View {
    var model: PicsModel
    
    var body: some View {
        VStack {
            AsyncPicsImageView(url: model.downloadUrl ?? "")
            Text(model.author ?? "")
                .padding(.top, 10)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.secondary.opacity(0.1)))
    }
}

struct AsyncPicsImageView: View {
    var url: String
    var isDetailView: Bool = false
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .cornerRadius(20)
                    .shadow(radius: 4)

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(radius: 4)

            case .failure:
                ProgressView()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                    .cornerRadius(20)
                    .shadow(radius: 4)

            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView(picsViewModel: PicsViewModel())
}
