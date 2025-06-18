import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    @Published var shouldValidate: Bool = false
    @Published var toastMessage: String = ""
    @Published var showToast: Bool = false
    
    
    func performLogin(onSuccess: @escaping () -> Void) {
        shouldValidate = true
        if isValid() {
            toastMessage = "Login Successful"
            showToast = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showToast = false
                onSuccess()
            }
        }
    }

    

    func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required"
        } else if !isValidEmail(email) {
            emailError = "Enter a valid email"
        } else {
            emailError = ""
        }
    }

    func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required"
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        } else {
            passwordError = ""
        }
    }

    func isValid() -> Bool {
        validateEmail()
        validatePassword()
        return emailError.isEmpty && passwordError.isEmpty
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
