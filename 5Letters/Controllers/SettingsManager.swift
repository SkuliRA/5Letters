//
//  SettingsManager.swift
//  5Letters
//
//  Created by Skuli on 07.11.2022.
//

import Foundation

enum KeysSettings: String {
    case firstWord = "firstWord"
    case firstRun = "yes"
}

class SettingsManager {
    
    func saveSettings(key: KeysSettings, value: String) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func getSettings(key: KeysSettings) -> String? {
        if let value = UserDefaults.standard.string(forKey: key.rawValue) {
            return value
        }
        
        return nil
    }
}
