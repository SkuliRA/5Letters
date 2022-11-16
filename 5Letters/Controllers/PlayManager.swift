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
        dataStore.excludePos = [:]
    }
    
    func fillDictionaries(_ array: [(letter: String?, type: LetterType)]) {
        
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
                // слово должно содержать эту букву
                if let value = dataStore.content[char] {
                    dataStore.content[char] = value + 1
                } else {
                    dataStore.content[char] = 1
                }
                // слово исключает эту букву в этой позиции
                if var arrEx = dataStore.excludePos[number] {
                    arrEx.append(char)
                    dataStore.excludePos[number] = arrEx
                } else {
                    dataStore.excludePos[number] = [char]
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
        let hints = coreDataManager.searchHints(content: dataStore.content, position: dataStore.position, banned: dataStore.bannedLetters, excludePos: dataStore.excludePos)
        
        return hints
    }
    
    func getBannedLeters() -> String {
        
        var bannedLettersString = ""
        
        for element in dataStore.bannedLetters {
            bannedLettersString = bannedLettersString + " " + String(element.key)
        }
        
        return bannedLettersString
    }
    
}
