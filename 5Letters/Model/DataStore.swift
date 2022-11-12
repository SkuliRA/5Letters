//
//  DataStore.swift
//  5Letters
//
//  Created by Skuli on 12.11.2022.
//

import Foundation

class DataStore {
    
    // двумерный массив всех слов из 5 букв
    var arrBase: [[Character]] = []
    // словарь - ключ буква и количество ее вхождений в слове
    var content: [Character : Int] = [:]
    // словарь - ключ позиция, значение буква
    var position: [Int: Character] = [:]
    // буквы которых нет в слове
    var bannedLetters: [Character : Int] = [:]
    
}
