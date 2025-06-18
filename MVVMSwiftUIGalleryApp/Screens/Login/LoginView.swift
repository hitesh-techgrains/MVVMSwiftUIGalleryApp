import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) var dismiss


    var body: some View {
        VStack(spacing: 16) {
            Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
            
            CustomTextField(
                title: "Email",
                text: $viewModel.email,
                errorMessage: viewModel.emailError,
                keyboardType: .emailAddress
            )
            .onChange(of: viewModel.email) { _ in if viewModel.shouldValidate { viewModel.validateEmail() } }

            CustomTextField(
                title: "Password",
                text: $viewModel.password,
                isSecure: true,
                errorMessage: viewModel.passwordError
            )
            .onChange(of: viewModel.password) { _ in if viewModel.shouldValidate { viewModel.validatePassword() } }

            Button(action: {
                viewModel.performLogin {
                      dismiss()
                  }
            }) {
                Text("Login")
                    .styledButtonView()
            }

        }
        .padding()
        .overlay(
            Group {
                if viewModel.showToast {
                    Text(viewModel.toastMessage)
                        .styledSuccessToastView(showToast: viewModel.showToast)
                }
            },
            alignment: .bottom
        )
    }
}
