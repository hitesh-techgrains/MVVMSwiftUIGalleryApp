import SwiftUI

struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var isSecure: Bool = false
    var errorMessage: String = ""
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if isSecure {
                SecureField(title, text: $text)
                    .padding()
                    .keyboardType(keyboardType)
                    .autocapitalization(.none) // <-- fix here
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage.isEmpty ? Color.gray : Color.red, lineWidth: 1))
            } else {
                TextField(title, text: $text)
                    .padding()
                    .keyboardType(keyboardType)
                    .autocapitalization(.none) // <-- fix here
                    .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage.isEmpty ? Color.gray : Color.red, lineWidth: 1))
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
