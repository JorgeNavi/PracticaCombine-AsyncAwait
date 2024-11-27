
import UIKit
import Foundation
import CombineCocoa
import Combine

class LoginViewController: UIViewController {
    
    private var appState: AppState?
    var logo: UIImageView?
    var loginButton: UIButton?
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    private var user: String = ""
    private var password: String = ""
    private var subscriptions = Set<AnyCancellable>()
    
    init(appState: AppState) {
        self.appState = appState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingUI()
    }
    
    override func loadView() {
        let LoginView = LoginView()
        logo = LoginView.getLogoImageView()
        loginButton = LoginView.getLoginButtonView()
        emailTextField = LoginView.getEmailView()
        passwordTextField = LoginView.getPasswordView()
        view = LoginView
    }
    
    private func bindingUI() {
        if let emailTextField = self.emailTextField {
            emailTextField.textPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] data in
                    if let user = data {
                        print("Text user: \(user)")
                        self?.user = user
                        
                        if let button = self?.loginButton {
                            if (self?.user.count)! > 5 {
                                button.isEnabled = true
                            } else {
                                button.isEnabled = false
                            }
                        }
                    }
                })
                .store(in: &subscriptions)
        }
        
        if let button = self.loginButton {
            button.tapPublisher
                .sink(receiveValue: { [weak self] _ in
                    if let user = self?.user,
                       let pass = self?.password {
                        self?.appState?.loginApp(user: user, password: pass)
                    }
                }).store(in: &subscriptions)
        }
    }
}
