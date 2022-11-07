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
    
    var activeTextField = UITextField()
    // двумерный массив всех слов из 5 букв
    var arrBase: [[Character]] = []
    // массив подсказок
    var hintsArray: [String] = []
    // словарь - ключ буква и количество ее вхождений в слове
    var content: [Character : Int] = [:]
    // словарь - ключ позиция, значение буква
    var position: [Int: Character] = [:]
    // буквы которых нет в слове
    var bannedLetters: [Character : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannedLabel.isHidden = true
        
        downloadDictionary()
        
        // Do any additional setup after loading the view.
        
        firstTextFild.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
        
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
    
    func downloadDictionary() {
        
        let fileName = "russian_nouns" //name file
        
        let path = Bundle.main.url(forResource: fileName, withExtension: "txt")
        
        guard let path = path else { return }
        
        //        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].first {
        //
        //            let fileURL = dir.appendingPathComponent(file)
        
        // читаем и заполняем базовый массив
        do {
            let text = try String(contentsOf: path, encoding: .utf8)
            let wordsArr = text.components(separatedBy: "\n")
            
            var arrFiveLet: [String] = []
            
            for element in wordsArr {
                if element.count == 5 {
                    arrFiveLet.append(element)
                }
            }
            
            // заполним двумерный массив символов словами
            for element in arrFiveLet {
                var wordArr: [Character] = []
                for charact in element {
                    wordArr.append(charact)
                }
                arrBase.append(wordArr)
            }
        }
        catch { print(error.localizedDescription) }
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        hintsArray = []
        content = [:]
        position = [:]
        bannedLetters = [:]
        
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
        
        hintsArray = []
        
        for word in arrBase {
            var contentCopy = content
            var positionCopy = position
            
            var isBanned = false
            for i in 0...4 {
                // проверим на буквы которых нет в слове
                if let _ = bannedLetters[word[i]] {
                    isBanned = true
                }
                
                // если есть забанненая буква, проверять дальше нет смысла
                guard !isBanned else { continue }
                
                // проверка на позицию
                if let value = positionCopy[i], value == word[i] {
                    positionCopy.removeValue(forKey: i)
                    // если известна буква из этой позиции то вхождения не проверяем
                    continue
                }
                
                // проверка на содержание
                if let value = contentCopy[word[i]] {
                    if value == 1 {
                        contentCopy.removeValue(forKey: word[i])
                    } else {
                        contentCopy[word[i]] = value - 1
                    }
                }
            }
            // если оба словаря пустые, то можно добавить в подсказки
            // добавляем его в подсказки
            if contentCopy.count == 0 && positionCopy.count == 0 && !isBanned {
                hintsArray.append(String(word))
            }
            
        }
        
        bannedLabel.isHidden = false
        // bannedLabel.text = "Исключенные буквы: " + bannedLetters.map {String($0) + " " + String($1)}
        
        var bannedLettersString = ""
        
        for element in bannedLetters {
            bannedLettersString = bannedLettersString + " " + String(element.key)
        }
        
        bannedLabel.text = bannedLabel.text! + bannedLettersString.capitalized
        
        let hintString = hintsArray.joined(separator: " ")
        
        let alert = UIAlertController(title: "Подходящие слова", message: hintString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fillFromTextFields() {
        
        position = [:]
        content = [:]
        
        fillDictionaries(textField: firstTextFild, bannedLetters: &bannedLetters, position: &position, content: &content, number: 0)
        
        fillDictionaries(textField: secondTextField, bannedLetters: &bannedLetters, position: &position, content: &content, number: 1)
        
        fillDictionaries(textField: thirdTextField, bannedLetters: &bannedLetters, position: &position, content: &content, number: 2)
        
        fillDictionaries(textField: fourthTextField, bannedLetters: &bannedLetters, position: &position, content: &content, number: 3)
        
        fillDictionaries(textField: fifthTextField, bannedLetters: &bannedLetters, position: &position, content: &content, number: 4)
        
        print(bannedLetters, content, position)
        
    }
    
    func  fillDictionaries(textField: UITextField, bannedLetters: inout [Character : Int], position: inout [Int: Character], content: inout [Character : Int], number: Int) {
        
        guard let text = textField.text, text != "" else { return }
        
        let char = Character(text.lowercased())
        
        if textField.backgroundColor == grayButton.backgroundColor {
            bannedLetters[char] = 1
        }
        
        if textField.backgroundColor == whiteButton.backgroundColor {
            if let number = content[char] {
                content[char] = number + 1
            } else {
                content[char] = 1
            }
        }
        
        if textField.backgroundColor == orangeButton.backgroundColor {
            position[number] = char
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

