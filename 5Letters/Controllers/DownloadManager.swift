//
//  DownloadManager.swift
//  5Letters
//
//  Created by Skuli on 12.11.2022.
//

import Foundation


class DownloadManager {
    
    func downloadDictionary(dataStore: DataStore) {
        
        let fileName = "russian_nouns" //name file
        
        let path = Bundle.main.url(forResource: fileName, withExtension: "txt")
        
        guard let path = path else { return }
        
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
                dataStore.arrBase.append(wordArr)
            }
        }
        catch { print(error.localizedDescription) }
        
    }
    

}
