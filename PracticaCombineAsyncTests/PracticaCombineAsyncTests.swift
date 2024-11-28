
import XCTest
import Combine
import KCLibrarySwift
import CombineCocoa
import UIKit
@testable import PracticaCombineAsync


final class PracticaCombineAsyncTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testKeyChainLibrary() throws {
        let KC = KeyChainKC()
        XCTAssertNotNil(KC)
        
        let save = KC.saveKC(_: "Test", value: "123")
        XCTAssertEqual(save, true)
        
        let value = KC.loadKC(_: "Test")
        XCTAssertEqual(value, "123")
        
        XCTAssertNoThrow(KC.deleteKC(_: "Test"))
    }
    
    func testLoginFake() async throws {
        let KC = KeyChainKC() //que al crear una instancia de KeyChainKC
        XCTAssertNotNil(KC) //no sea nula
        
        let obj = LoginUseCaseFake() //que al crear una instancia del LoginUseCaseFake
        XCTAssertNotNil(obj) //no sea nula
        
        let resp = await obj.validateToken() //que si llamamos al metodo del UseCaseFake
        XCTAssertEqual(resp, true) //responda true (el token sea valido)
        
        //Login
        let loginDo = await obj.loginApp(user: "", password: "") //que al llamar a loginApp con usuario vacio
        XCTAssertEqual(loginDo, true) // me de true
        var jwt = KC.loadKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN) //y al llamar a cargar token
        XCTAssertNotEqual(jwt, "") //sea distinto de vacio
        
        //Close Session
        await obj.logout() //que al llamar a logout
        jwt = KC.loadKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN) //y al llamar a cargar token
        XCTAssertEqual(jwt, "") //el token sea igual a vacio
    }
    
    func testLoginReal() async throws {
        let KC = KeyChainKC()
        XCTAssertNotNil(KC)
        //reset token
        KC.saveKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: "")
        
        //caso de uso con el fake repository
        let useCase = LoginUseCase(repo: LoginRepositoryFake())
        XCTAssertNotNil(useCase)
        
        //Validacion
        let resp = await useCase.validateToken()
        XCTAssertEqual(resp, false)
        
        //login
        let loginDo = await useCase.loginApp(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        var jwt = KC.loadKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")
        
        //Close Session
        await useCase.logout()
        jwt = KC.loadKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }
    
    func testLoginAutoLoginAsincrono()  throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Login Auto ")
        
        let vm = AppState(loginUseCase: LoginUseCaseFake())
        XCTAssertNotNil(vm)
        
        vm.$loginStatus
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { estado in
                print("Recibo estado \(estado)")
                if estado == .success {
                    exp.fulfill() //la expectacion se ha cumplido
                }
            }
            .store(in: &suscriptor)

         vm.validateControlLogin()
        
        self.waitForExpectations(timeout: 10)
    }
    
    
    func testUIErrorView() async throws  {

        let appStateVM = AppState(loginUseCase: LoginUseCaseFake())
        XCTAssertNotNil(appStateVM)

        appStateVM.loginStatus = .error
        
        let vc = await ErrorViewController(appState: appStateVM, error: "Error Testing")
        XCTAssertNotNil(vc)
    }
    
    
    func testUILoginView()  throws  {
        XCTAssertNoThrow(LoginView())
        let view = LoginView()
        XCTAssertNotNil(view)
        
        let logo =   view.getLogoImageView()
        XCTAssertNotNil(logo)
        let txtUser = view.getEmailView()
        XCTAssertNotNil(txtUser)
        let txtPass = view.getPasswordView()
        XCTAssertNotNil(txtPass)
        let button = view.getLoginButtonView()
        XCTAssertNotNil(button)
        
        XCTAssertEqual(txtUser.placeholder, "E-mail")
        XCTAssertEqual(txtPass.placeholder, "Password")
        XCTAssertEqual(button.titleLabel?.text, "Login")
        
        
        //la vista esta generada
       let View2 =  LoginViewController(appState: AppState(loginUseCase: LoginUseCaseFake()))
       XCTAssertNotNil(View2)
        XCTAssertNoThrow(View2.loadView()) //generamos la vista
        XCTAssertNotNil(View2.loginButton)
        XCTAssertNotNil(View2.emailTextField)
        XCTAssertNotNil(View2.logo)
        XCTAssertNotNil(View2.passwordTextField)
        
        //el binding
        XCTAssertNoThrow(View2.bindingUI())
        
        View2.emailTextField?.text = "Hola"
        
        //el boton debe estar desactivado
        XCTAssertEqual(View2.emailTextField?.text, "Hola")
    }
    
    
    func testHeroiewViewModel() async throws  {
        let vm = HerosViewModel(useCase: HeroUseCaseFake())
        XCTAssertNotNil(vm)
        XCTAssertEqual(vm.herosData.count, 2) //debe haber 2 heroes Fake mokeados
    }
    
    
    func testHerosUseCase() async throws  {
       let caseUser = HeroUseCase(repo: HerosRepositoryFake())
        XCTAssertNotNil(caseUser)
        
        let data = await caseUser.getHeros(filter: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
    }
    
    
    func testHeros_Combine() async throws  {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Heros get")
        
        let vm = HerosViewModel(useCase: HeroUseCaseFake())
        XCTAssertNotNil(vm)
        
        vm.$herosData
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("finalizado")
                }
            } receiveValue: { data in
      
                if data.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)
      
        
        await self.waitForExpectations(timeout: 10)
    }
    
    func testHeros_Data() async throws  {
        let network = NetworkHerosFake()
        XCTAssertNotNil(network)
        let repo = HerosRepository(network: network)
        XCTAssertNotNil(repo)
        
        let repo2 = HerosRepositoryFake()
        XCTAssertNotNil(repo2)
        
        let data = await repo.getHeros(filter: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 2)
        
        
        let data2 = await repo2.getHeros(filter: "")
        XCTAssertNotNil(data2)
        XCTAssertEqual(data2.count, 2)
    }
    
    func testHeros_Domain() async throws  {
       //Models
        let model = HerosModel(id: UUID(), favorite: true, description: "des", photo: "url", name: "goku")
        XCTAssertNotNil(model)
        XCTAssertEqual(model.name, "goku")
        XCTAssertEqual(model.favorite, true)
        
        let requestModel = HeroModelRequest(name: "goku")
        XCTAssertNotNil(requestModel)
        XCTAssertEqual(requestModel.name, "goku")
    }
    
    func testHeros_Presentation() async throws  {
        let viewModel = HerosViewModel(useCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel)
        
        let view =  await HerosTableViewController(appState: AppState(loginUseCase: LoginUseCaseFake()), viewModel: viewModel)
        XCTAssertNotNil(view)
        
    }
    
}
