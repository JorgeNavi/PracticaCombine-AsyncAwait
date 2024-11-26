
import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    var logo: UIImageView?
    var loginButton: UIButton?
    var emailTextField: UITextField?
    var passwordTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        let LoginView = LoginView()
        logo = LoginView.getLogoImageView()
        loginButton = LoginView.getLoginButtonView()
        emailTextField = LoginView.getEmailView()
        passwordTextField = LoginView.getPasswordView()
        view = LoginView
    }
}
