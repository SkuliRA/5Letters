//
//  ViewController.swift
//  5Letters
//
//  Created by Skuli on 02.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstTextFild: UITextField!
    
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var thirdTextField: UITextField!
    
    @IBOutlet weak var fourthTextField: UITextField!
    
    @IBOutlet weak var fifthTextField: UITextField!
    
    @IBOutlet weak var grayButton: UIButton!
    
    @IBOutlet weak var whiteButton: UIButton!
    
    @IBOutlet weak var orangeButton: UIButton!
    
    @IBOutlet weak var bannedLabel: UILabel!
    
    // менеджер загрузки словаря в хранилище
    let downloadManager = DownloadManager()
   
    // менеджер игры, содержит в себе класс - хранилище слов
    let playManager = PlayManager()
    
    // менеджер настроек
    let settingManager = SettingsManager()
    
    // менеджер работы с кор датой
    let coreDataManager = CoreDataManager()
    
    var activeTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // установим первое слово из настроек
        setFirstWord()
        
        bannedLabel.isHidden = true
        
        // загрузим словарь в наш класс хранилище данных
        downloadManager.downloadDictionary(dataStore: playManager.dataStore)
        
        //checkFirstRunning()
    
        firstTextFild.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
    }
    
    func setFirstWord() {
        
        if let text = settingManager.getSettings(key: .firstWord), text != "" {
            var index = text.index(text.startIndex, offsetBy: 0)
            firstTextFild.text = String(text[index])
            index = text.index(text.startIndex, offsetBy: 1)
            secondTextField.text = String(text[index])
            index = text.index(text.startIndex, offsetBy: 2)
            thirdTextField.text = String(text[index])
            index = text.index(text.startIndex, offsetBy: 3)
            fourthTextField.text = String(text[index])
            index = text.index(text.startIndex, offsetBy: 4)
            fifthTextField.text = String(text[index])
        }
    }
    
    fileprivate func checkFirstRunning() {
        // загрузим массив слов в кор дату если это первый запуск
        if checkFirstRun() {
            do {
                let done = try coreDataManager.fromArrayToCoreData(playManager.dataStore.arrBase)
                // если загрузка в кор дату прошла успешно, тогда установим в настройках
                // что это не первый запуск
                if done {
                    settingManager.saveSettings(key: .firstRun, value: "no")
                }
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }
    }
    
    func checkFirstRun() -> Bool {
        
        if let text = settingManager.getSettings(key: .firstRun), text == "no" {
            return false
        }
    
        return true
    }
    
    @IBAction func grayColorButton(_ sender: UIButton) {
        activeTextField.backgroundColor = sender.backgroundColor
    }
    
    @IBAction func whiteColorButton(_ sender: UIButton) {
        activeTextField.backgroundColor = sender.backgroundColor
    }
    
    @IBAction func orangeColorButton(_ sender: UIButton) {
        activeTextField.backgroundColor = sender.backgroundColor
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        // обновим данные в нашем хранилище
        playManager.refreshStore()
        
        bannedLabel.isHidden = true
        bannedLabel.text = "Исключенные буквы:"
        
        firstTextFild.text = ""
        firstTextFild.backgroundColor = whiteButton.backgroundColor
        secondTextField.text = ""
        secondTextField.backgroundColor = whiteButton.backgroundColor
        thirdTextField.text = ""
        thirdTextField.backgroundColor = whiteButton.backgroundColor
        fourthTextField.text = ""
        fourthTextField.backgroundColor = whiteButton.backgroundColor
        fifthTextField.text = ""
        fifthTextField.backgroundColor = whiteButton.backgroundColor
        
    }
    
    @IBAction func showHints(_ sender: UIButton) {
        
        // все текстфилды должны быть заполнены
        guard let text = firstTextFild.text, text != "" else { return }
        guard let text = secondTextField.text, text != "" else { return }
        guard let text = thirdTextField.text, text != "" else { return }
        guard let text = fourthTextField.text, text != "" else { return }
        guard let text = fifthTextField.text, text != "" else { return }
        
        fillFromTextFields()
        
        // получим строку подсказок
        let hintString = playManager.getHints()
        
        // включим видимость лейбла с исключенными буквами
        bannedLabel.isHidden = false
        
        // заполним лейбл с исключенными буквами
        var bannedLettersString = ""
        bannedLettersString = playManager.getBannedLeters()
        bannedLabel.text = bannedLabel.text! + bannedLettersString.capitalized
        
        // выведем в алер контроллере подсказки
        let alert = UIAlertController(title: "Подходящие слова", message: hintString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // заполним массивы и словари из текст филдов
    func fillFromTextFields() {
        
        var array: [(letter: String?, type: LetterType)] = []
        
        guard let type0 = checkLetterType(firstTextFild) else { return }
        array.append((firstTextFild.text, type0))
        
        guard let type1 = checkLetterType(secondTextField) else { return }
        array.append((secondTextField.text, type1))
        
        guard let type2 = checkLetterType(thirdTextField) else { return }
        array.append((thirdTextField.text, type2))
        
        guard let type3 = checkLetterType(fourthTextField) else { return }
        array.append((fourthTextField.text, type3))
        
        guard let type4 = checkLetterType(fifthTextField) else { return }
        array.append((fifthTextField.text, type4))
        
        playManager.fillDictionaries(array)
        
    }
    
    func checkLetterType(_ textField: UITextField) -> LetterType? {
        switch textField.backgroundColor {
        case grayButton.backgroundColor:
            return .except
        case whiteButton.backgroundColor:
            return .contained
        case orangeButton.backgroundColor:
            return .position
        default:
            return nil
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = string.capitalized
        
        guard string != "" else {
           // backspace(tag: textField.tag)
            return false
        }
        
        switch textField.tag {
        case 1:
            secondTextField.becomeFirstResponder()
        case 2:
            thirdTextField.becomeFirstResponder()
        case 3:
            fourthTextField.becomeFirstResponder()
        case 4:
            fifthTextField.becomeFirstResponder()
        default:
            break
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // отключим текущую клавиатуру
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func backspace(tag: Int) {
        switch tag {
        case 2:
            firstTextFild.becomeFirstResponder()
            firstTextFild.text = ""
        case 3:
            secondTextField.becomeFirstResponder()
            secondTextField.text = ""
        case 4:
            thirdTextField.becomeFirstResponder()
            thirdTextField.text = ""
        case 5:
            fourthTextField.becomeFirstResponder()
            fourthTextField.text = ""
        default:
            break
        }
    }
    
}

