//
//  PlayManager.swift
//  5Letters
//
//  Created by Skuli on 12.11.2022.
//

import Foundation

enum LetterType {
   
    case except
    case contained
    case position
}

class PlayManager {
    
    let dataStore = DataStore()
    
    func refreshStore() {
        dataStore.content = [:]
        dataStore.position = [:]
        dataStore.bannedLetters = [:]
    }
    
    func  fillDictionaries(_ array: [(letter: String?, type: LetterType)]) {
        
        dataStore.content = [:]
        dataStore.position = [:]
        
        var number = 0
        
        for element in array {
            
            guard let letter = element.letter, letter != "" else { return }
            
            let char = Character(letter.lowercased())
            
            switch element.type {
            case .except:
                dataStore.bannedLetters[char] = 1
            case .contained:
                if let value = dataStore.content[char] {
                    dataStore.content[char] = value + 1
                } else {
                    dataStore.content[char] = 1
                }
            case .position:
                dataStore.position[number] = char
            }
            
            number += 1
        }
    }
    
    func getHints() -> String {
        
        // получим подсказки из Core Data
        let coreDataManager = CoreDataManager()
        let hints = coreDataManager.searchHints(content: dataStore.content, position: dataStore.position, banned: dataStore.bannedLetters)
        
        return hints
        
//        for word in dataStore.arrBase {
//            var contentCopy = dataStore.content
//            var positionCopy = dataStore.position
//
//            var isBanned = false
//            for i in 0...4 {
//                // проверим на буквы которых нет в слове
//                if let _ = dataStore.bannedLetters[word[i]] {
//                    isBanned = true
//                }
//
//                // если есть забанненая буква, проверять дальше нет смысла
//                guard !isBanned else { continue }
//
//                // проверка на позицию
//                if let value = positionCopy[i], value == word[i] {
//                    positionCopy.removeValue(forKey: i)
//                    // если известна буква из этой позиции то вхождения не проверяем
//                    continue
//                }
//
//                // проверка на содержание
//                if let value = contentCopy[word[i]] {
//                    if value == 1 {
//                        contentCopy.removeValue(forKey: word[i])
//                    } else {
//                        contentCopy[word[i]] = value - 1
//                    }
//                }
//            }
//            // если оба словаря пустые, то можно добавить в подсказки
//            // добавляем его в подсказки
//            if contentCopy.count == 0 && positionCopy.count == 0 && !isBanned {
//                hintsArray.append(String(word))
//            }
//
//        }
    }
    
    func getBannedLeters() -> String {
        
        var bannedLettersString = ""
        
        for element in dataStore.bannedLetters {
            bannedLettersString = bannedLettersString + " " + String(element.key)
        }
        
        return bannedLettersString
    }
    
}
