import SwiftUI

struct HomeView: View {
    @ObservedObject var picsViewModel: PicsViewModel
    @State private var navigateToLogin = false
    @State private var navigateToCalendar = false
    
    // Define grid columns — 2 columns side by side
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()) // add more if you want
    ]
   
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Gallery")
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Menu {
                                Button("Login", action: { print("Edit tapped")
                                    navigateToLogin = true
                                })
                                Button("Calendar", action: {
                                    print("Share tapped")
                                    navigateToCalendar = true
                                    
                                })
                            } label: {
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90)) // vertical ellipsis look
                                    .font(.title2)
                            }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    // 🔽 Hidden NavigationLink
                    NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {EmptyView()}
                                 .hidden()
                    
                    // 🔽 Hidden NavigationLink
                    NavigationLink(destination: CalendarView(), isActive: $navigateToCalendar) {EmptyView()}
                                 .hidden()


                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(picsViewModel.picsModel, id: \.id) { model in
                            NavigationLink(destination: AsyncPicsImageView(url: model.downloadUrl ?? "", isDetailView: true)
                                .ignoresSafeArea()) {
                                    GalleryItemView(model: model)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
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
    @StateObject private var imageLoader = ImageLoader()
    var url: String
    var isDetailView: Bool = false
    
    var body: some View {
        
        VStack{
            if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(20)
                        .shadow(radius: 4)
                } else {
                    ProgressView()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
                        .cornerRadius(20)
                        .shadow(radius: 4)
                }
        }
        .onAppear {
                    imageLoader.loadImage(from: url)
                }
        

    }
}

#Preview {
    HomeView(picsViewModel: PicsViewModel())
}
