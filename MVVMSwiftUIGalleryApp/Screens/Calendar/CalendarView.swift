import SwiftUI

struct CalendarView: View {
    @State private var currentWeek: [Date.Day] = Date.currentWeek
    @State private var selectedDate: Date?

    // For Matched Geometry Effect
    @Namespace private var namespace

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .environment(\.colorScheme, .dark)
                .padding(.horizontal)
            
            GeometryReader {
                let size = $0.size
                
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                            ForEach(currentWeek) { day in
                                let date = day.date
                                let isLast = currentWeek.last?.id == day.id

                                Section {
                                    VStack(alignment: .leading, spacing: 15) {
                                        TaskRow()
                                        TaskRow()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.leading, 70)
                                    .padding(.top, -70)
                                    .frame(minHeight: isLast ? size.height - 110 : nil, alignment: .top)
                                } header: {
                                    VStack(spacing: 4) {
                                        Text(date.string("EEE"))
                                        Text(date.string("dd"))
                                            .font(.largeTitle.bold())
                                    }
                                    .frame(width: 55, height: 70)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .offset(y: 10)
                                }
                                .id(day.id) // <-- Required for ScrollViewReader to work
                            }
                        }
                        .padding(.all, 20)
                        .padding(.vertical, 20)
                    }
                    .onChange(of: selectedDate) { newDate in
                        print("onChange...")
                        if let id = currentWeek.first(where: { $0.date.isSame(newDate) })?.id {
                            withAnimation {
                                proxy.scrollTo(id, anchor: .top)
                            }
                        }
                    }
                }

            }
            .background(.background)
            .clipShape(CustomCornerRadiusShape(topLeft: 30, topRight: 30, bottomLeft: 0, bottomRight: 0))    
            .environment(\.colorScheme, .light)
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
        .background(Color.black)
        .onAppear{
            guard selectedDate  == nil else {return}
            selectedDate = currentWeek.first(where: {$0.date.isSame(.now)})?.date
        }
    }

    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("This Week")
                    .font(.title.bold())
                
                Spacer(minLength: 0)
                
                Button {
                } label: {
                    Image(.pic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(.circle)
                }
            }
            
            /// Week View
            HStack(spacing: 0) {
                ForEach(currentWeek) { day in
                    let date = day.date
                    let isSameDate = date.isSame(selectedDate)
                    VStack(spacing: 6) {
                        Text(date.string("EEE"))
                            .font(.caption)
                        Text(date.string("dd"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(width: 38, height: 38)
                            .foregroundStyle(isSameDate ? .black : .white)
                            .background{
                                if isSameDate {
                                    Circle().fill(.white)
                                        .matchedGeometryEffect(id: "ACTIVEDATE", in: namespace)
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)){
                            selectedDate = date
                        }
                    }
                    
                }
            }
            .animation(.snappy(duration: 0.25,extraBounce: 0), value: selectedDate)
            .frame(height: 80)
            .padding(.vertical, 5)

            HStack {
                Text(selectedDate?.string("MMM") ?? "")
                Spacer()
                Text(selectedDate?.string("YYYY") ?? "")
            }
            .font(.caption2)
            .padding([.horizontal, .top], 15)
            .padding(.bottom, 10)

        }
    }
}

struct TaskRow: View{
    var isEmpty: Bool  = false
    var body: some View{
        Group{
            if isEmpty{
                VStack(spacing: 8){
                    Text("No Task's Found on this Day")
                    Text("Try Adding some New Task's")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                .frame(height:100)
                .frame(maxWidth: .infinity)
                
            }
            else {
                VStack(alignment: .leading, spacing: 8){
                    Circle()
                        .fill(.red)
                        .frame(width: 5, height: 5)
                    
                    Text("Some Random Task")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    
                    HStack{
                        Text("16:00 - 17:00")
                        
                        Spacer(minLength: 0)
                        
                        Text("Some place, California")
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.top, 5)
                }
                .lineLimit(1)
                .padding(15)
              }
                
        }
        .background{
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .shadow(color: .black.opacity(0.35), radius: 1)
        }
    }
}


struct CustomCornerRadiusShape: Shape {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let tl = min(min(topLeft, rect.width / 2), rect.height / 2)
        let tr = min(min(topRight, rect.width / 2), rect.height / 2)
        let bl = min(min(bottomLeft, rect.width / 2), rect.height / 2)
        let br = min(min(bottomRight, rect.width / 2), rect.height / 2)

        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))

        // Top line
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr), radius: tr,
                    startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)

        // Right line
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        path.addArc(center: CGPoint(x: rect.maxX - br, y: rect.maxY - br), radius: br,
                    startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)

        // Bottom line
        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + bl, y: rect.maxY - bl), radius: bl,
                    startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)

        // Left line
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        path.addArc(center: CGPoint(x: rect.minX + tl, y: rect.minY + tl), radius: tl,
                    startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        return path
    }
}
