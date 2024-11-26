import Foundation

protocol LoginRepositoryProtocol {
    func loginApp(user: String, password: String) async -> String 
}
