import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                TextField("Name", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Confirm the password", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                if networkManager.isLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        if validateForm() {
                            networkManager.register(username: username, password: password) { success, message in
                                alertMessage = message
                                if success {
                                    appViewModel.isLogin = true
                                    UserDefaults.standard.set(true, forKey: "isLogin")
                                } else {
                                    print(success, message)
                                }
                                showAlert = true
                            }
                        }
                    }) {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationBarTitle("Registration")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
//            .background(NavigationLink(destination: TodoListView(), isActive: $appViewModel.isLogin) {
//                
//            })
        }
    }

    private func validateForm() -> Bool {
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Please fill in all the fields."
            showAlert = true
            return false
        }

        if password != confirmPassword {
            alertMessage = "The passwords don't match."
            showAlert = true
            return false
        }

        return true
    }
}

#Preview {
    RegistrationView()
}


