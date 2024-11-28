
import Foundation

enum LoginStatus {
    case none
    case success
    case error
    case notValidate
}

final class AppState {
    @Published var loginStatus: LoginStatus = .none
    private var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    
    func loginApp(user: String, pass: String) {
        Task { //Task para crear un contexto asincrono. Si no lo pusieramos, al añadir el await debajo se quejaría
            if (await loginUseCase.loginApp(user: user, password: pass)) { //el await se queda esperando a que el siguiente código respinda
                self.loginStatus = .success
            } else {
                self.loginStatus = .error
            }
        }
    }
    
    func validateControlLogin() {
        Task {
            if (await loginUseCase.validateToken()) {
                self.loginStatus = .success
            } else {
                self.loginStatus = .notValidate
            }
        }
    }
    
    func closeUserSession() {
        Task {
            await loginUseCase.logout()
            self.loginStatus = .none
        }
    }
}
