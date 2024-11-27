
import Foundation
import KCLibrarySwift


final class LoginUseCase: LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: NetworkLogin())) {
        self.repo = repo
    }
    
    func loginApp(user: String, password: String) async -> Bool {
        let token = await repo.loginApp(user: user, password: password)
        if token != "" {
            KeyChainKC().saveKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: token)
            return true
        } else {
            KeyChainKC().deleteKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
            return false
        }
    }
    
    func logout() async {
        KeyChainKC().deleteKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
    }
    
    func validateToken() async -> Bool {
        if KeyChainKC().loadKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN) != "" { //Si leemos el token y es distinto de vacío devolvemos true
            return true
        } else {
            return false
        }
    }
}

final class LoginUseCaseFake: LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: NetworkLogin())) {
        self.repo = repo
    }

    func loginApp(user: String, password: String) async -> Bool {
        KeyChainKC().saveKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: "LoginFakeSuccess")
    }
    
    func logout() async {
        KeyChainKC().deleteKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
    }
    
    func validateToken() async -> Bool {
        return true
    }
}
