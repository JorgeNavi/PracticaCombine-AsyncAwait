

import Foundation
import UIKit

class LoginView: UIView {
    
    public let logoImage = {
        let image = UIImageView(image: UIImage(named: "title"))
        image.translatesAutoresizingMaskIntoConstraints = false //esto es una forma de decirle al compilador que vamos a establecer las constrainst por código (siempre tiene que estar a falso). Sirve para que nuestras constraints no entren en conflicto con las que el programa crea por defecto.
        return image
    }()
    
    public let emailTextField = {
        let textField = UITextField()
        textField.backgroundColor = .blue.withAlphaComponent(0.9)
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 18)
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect //estilo de borde redondeado
        textField.layer.cornerRadius = 10 //redondear las esquinas y su radio
        textField.layer.masksToBounds = true //Para que se vea el redondeado
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]) //le añadimos el color del texto en el placeholder
        return textField
    }()
    
    public let passwordTextField = {
        let textField = UITextField()
        textField.backgroundColor = .blue.withAlphaComponent(0.9)
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 18)
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect //estilo de borde redondeado
        textField.layer.cornerRadius = 10 //redondear las esquinas y su radio
        textField.layer.masksToBounds = true //Para que se vea el redondeado
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]) //le añadimos el color del texto en el placeholder
        return textField
    }()
    
    public let loginButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.9)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.cornerRadius = 29
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let backgroundImage = UIImage(named: "fondo3")!
        backgroundColor = UIColor(patternImage: backgroundImage)
        addSubview(logoImage)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        
        //constrainst:
        NSLayoutConstraint.activate([ //Todo lo que se meta aquí serán constraints activas a la vez
            
            //Logo:
            logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 120), //Constraint superior de la imagen del logo
            logoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20), //Constraint del borde izq
            logoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20), //al trailing es negativo porque se descuenta desde el borde derecho, es decir, la coordenada decrece
            logoImage.heightAnchor.constraint(equalToConstant: 70),
            
            //Usuario (las referencias de las constrainst cambian, por ejemplo, queremos colocar el campo de usuario en función del logo):
            emailTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100), //Constraint superior (en este caso con respecto a la parte de abajo del logo)
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50), //Constraint del borde izq
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50), //al trailing es negativo porque se descuenta desde el borde derecho, es decir, la coordenada decrece
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            //password:
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40), //Constraint superior (en este caso con respecto a la parte de abajo del logo)
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50), //Constraint del borde izq
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50), //al trailing es negativo porque se descuenta desde el borde derecho, es decir, la coordenada decrece
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            //loginButton:
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 75), //Constraint superior (en este caso con respecto a la parte de abajo del logo)
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80), //Constraint del borde izq
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80), //al trailing es negativo porque se descuenta desde el borde derecho, es decir, la coordenada decrece
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func getEmailView() -> UITextField {
        emailTextField
    }
    
    func getPasswordView() -> UITextField {
        passwordTextField
    }
    
    func getLogoImageView() -> UIImageView {
        logoImage
    }
    
    func getLoginButtonView() -> UIButton {
        loginButton
    }
}
