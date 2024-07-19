import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var isLoading = false

    func register(username: String, password: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "http://localhost:5004/auth/registration") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["username": username, "password": password]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(false, "Failed to encode body")
            return
        }

        isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }

            do {
                let response = try JSONDecoder().decode([String: String].self, from: data)
                //if response["success"] == "true" {
                completion(true, response["message"] ?? "Registration successful")
               // } //else {
                //    completion(false, response["message"] ?? "Registration failed")
                //}
            } catch {
                completion(false, "Failed to decode response")
            }
        }.resume()
    }
}
