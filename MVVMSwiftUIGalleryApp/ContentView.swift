//
//  ContentView.swift
//  MVVMSwiftUIGalleryApp
//
//  Created by admin on 16/06/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var picsViewModel: PicsViewModel
    
    
    var body: some View {
       
        NavigationView{
            List(picsViewModel.picsModel, id: \.self){ model in
                VStack {
                    AsyncPicsImageView(url : model.downloadUrl ?? "")
                    
                    Text(model.author ?? "")
                        .padding(.top, 10)
                }
                .padding()
                .listRowSeparator(.hidden)
            }
            .onAppear(perform:{
                picsViewModel.lodData()
            })
            .navigationTitle("Gallery")
        }
        
    }
}

#Preview {
    ContentView(picsViewModel: PicsViewModel())
}

struct AsyncPicsImageView: View {
    var url: String
    var body: some View {
        AsyncImage(url: URL(string: url)){
            phase in
            switch phase{
            case .empty :
                ProgressView()
            case .success(let image) :
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                    .shadow(radius: 4)
                
            case .failure :
                ProgressView()
                
            default: EmptyView()
            }
            
        }
    }
}
