//
//  SettingsViewController.swift
//  5Letters
//
//  Created by Skuli on 07.11.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var strartWordTField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
       
        if let text = strartWordTField.text, text.count == 5 {
            let settingManager = SettingsManager()
            settingManager.saveSettings(key: .firstWord, value: text)
        }
        
    }
    
    @IBAction func clearDBButton(_ sender: UIButton) {
        let coreDataManager = CoreDataManager()
        
        coreDataManager.clearDataBase()
        
        let settingManager = SettingsManager()
        settingManager.saveSettings(key: .firstRun, value: "yes")
    }
    
    @IBAction func CheckWordAction(_ sender: Any) {
        
        let coreDataManager = CoreDataManager()
        
        guard let text = strartWordTField.text else { return }
        
        if coreDataManager.checkWord(text) {
            resultLabel.text = "есть"
        } else {
            resultLabel.text = "нет"
        }
    }
}
