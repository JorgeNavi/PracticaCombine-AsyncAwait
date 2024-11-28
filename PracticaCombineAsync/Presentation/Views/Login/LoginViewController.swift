
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
    private var pass: String = ""
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
        let loginView = LoginView()
        logo = loginView.getLogoImageView()
        loginButton = loginView.getLoginButtonView()
        emailTextField = loginView.getEmailView()
        passwordTextField = loginView.getPasswordView()
        view = loginView
    }
    
    func bindingUI() {
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
        
        if let passwordTextfield = self.passwordTextField {
            passwordTextfield.textPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] data in
                    if let pass = data {
                        print("Text pass: \(pass)")
                        self?.pass = pass
                    }
                })
                .store(in: &subscriptions)
        }
        if let button = self.loginButton {
            button.tapPublisher
                .sink(receiveValue: { [weak self] _ in
                    if let user = self?.user,
                       let pass = self?.pass {
                        self?.appState?.loginApp(user: user, pass: pass)
                    }
                }).store(in: &subscriptions)
        }
    }
}
