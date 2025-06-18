import SwiftUI

extension View {
    func styledButtonView() -> some View {
        self
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .contentShape(Rectangle())
    }
    
    func styledSuccessToastView(
        showToast:Bool = false
    ) -> some View {
        self
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            .transition(.opacity)
            .animation(.easeInOut, value: showToast)
            .padding(.bottom, 40)
    }
}
