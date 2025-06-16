//
//  ContentView.swift
//  MVVMSwiftUIGalleryApp
//
//  Created by admin on 16/06/25.
//

import SwiftUI

struct ContentView: View {
    
    var arrImages = ["pic1","pic2","pic3","pic4"]
    
    var body: some View {
       
        NavigationView{
            List(arrImages, id: \.self){ image in
                VStack {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .shadow(radius: 4)
                    
                    Text("Hello, world!")
                        .padding(.top, 10)
                }
                .padding()
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Gallery")
        }
        
    }
}

#Preview {
    ContentView()
}
