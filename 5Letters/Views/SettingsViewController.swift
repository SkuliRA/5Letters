//
//  SettingsViewController.swift
//  5Letters
//
//  Created by Skuli on 07.11.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var strartWordTField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
       
        if let text = strartWordTField.text, text.count == 5 {
            let settingManager = SettingsManager()
            settingManager.saveSettings(key: .firstWorld, value: text)
        }
        
    }
    
    
}
