
import Foundation

enum LoginStatus {
    case none
    case success
    case error
}

final class AppState {
    @Published var loginStatus: LoginStatus = .none
    
    
}
