//
//  ErrorViewController.swift
//  PracticaCombineAsync
//
//  Created by Jorge Navidad Espliego on 27/11/24.
//

import UIKit
import Combine
import CombineCocoa

class ErrorViewController: UIViewController {

    
    private var appState: AppState?
    private var suscriptor = Set<AnyCancellable>()
    private var error: String?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var labelError: UILabel!
    
    internal init(appState: AppState, error: String) {
        self.appState = appState
        self.error = error
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelError.text = self.error
        self.backButton.tapPublisher
            .sink {
                self.appState?.loginStatus = .none
            }
            .store(in: &suscriptor)
        }

        // Do any additional setup after loading the view.
}

