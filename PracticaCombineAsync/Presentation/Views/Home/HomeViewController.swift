//
//  HomeViewController.swift
//  PracticaCombineAsync
//
//  Created by Jorge Navidad Espliego on 27/11/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var appState: AppState?
    
    init(appState: AppState) {
        self.appState = appState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeSession(_ sender: Any?) {
        self.appState?.closeUserSession()
    }

}
