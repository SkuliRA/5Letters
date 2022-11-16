//
//  DataManager.swift
//  5Letters
//
//  Created by Skuli on 13.11.2022.
//

import Foundation
import CoreData

class CoreDataManager: NSObject, ObservableObject {
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FiveLetters")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    
    // MARK: - CRUD
    
    func saveContext () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fromArrayToCoreData(_ arr: [[Character]]) throws -> Bool {
        
        var wordString = ""
        
        for el in arr {
            
            wordString = String(el)
            
            let word = Word(context: viewContext)
            word.fullWord = wordString
            word.letter1 = String(el[0])
            word.letter2 = String(el[1])
            word.letter3 = String(el[2])
            word.letter4 = String(el[3])
            word.letter5 = String(el[4])
            
            do {
                try  viewContext.save()
            } catch let error {
                print("Error \(error)")
            }
        }
        
        return true
    }
    
    func clearDataBase() {
        // создаем запрос
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        // вызываем запрос через контекст
        if let words = try? viewContext.fetch(fetchRequest) as? [Word], !words.isEmpty {
           
            for word in words {
                viewContext.delete(word)
            }
            
            try? viewContext.save()
        }
        
    }
    
    func checkWord(_ str: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "fullWord = '\(str.lowercased())'")
        
        if let words = try? viewContext.fetch(fetchRequest) as? [Word], !words.isEmpty {
            
            return true
            
        } else {
            return false
        }
    }
    
    func searchHints(content contentDict: [Character : Int], position positionDict: [Int: Character], banned bannedDict: [Character : Int]) -> String {
        
        var hints = ""
        
        let predicateStr = getPredicateString(content: contentDict, position: positionDict, banned: bannedDict)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: predicateStr)
        
        if let words = try? viewContext.fetch(fetchRequest) as? [Word] {
            
            for word in words {
                
                // мы исключили слова с забаннеными буквами и оставили те которые имеют нужные буквы на позициях
                // необходимо проверить содержание букв
                var contentCopy = contentDict
                
                if let value = contentCopy[Character(word.letter1!)] {
                    if value == 1 {
                        contentCopy.removeValue(forKey: Character(word.letter1!))
                    } else {
                        contentCopy[Character(word.letter1!)] = value - 1
                    }
                }
                
                if let value = contentCopy[Character(word.letter2!)] {
                    if value == 1 {
                        contentCopy.removeValue(forKey: Character(word.letter2!))
                    } else {
                        contentCopy[Character(word.letter2!)] = value - 1
                    }
                }
                
                if let value = contentCopy[Character(word.letter3!)] {
                    if value == 1 {
                        contentCopy.removeValue(forKey: Character(word.letter3!))
                    } else {
                        contentCopy[Character(word.letter3!)] = value - 1
                    }
                }
                
                if let value = contentCopy[Character(word.letter4!)] {
                    if value == 1 {
                        contentCopy.removeValue(forKey: Character(word.letter4!))
                    } else {
                        contentCopy[Character(word.letter4!)] = value - 1
                    }
                }
                
                if let value = contentCopy[Character(word.letter5!)] {
                    if value == 1 {
                        contentCopy.removeValue(forKey: Character(word.letter5!))
                    } else {
                        contentCopy[Character(word.letter4!)] = value - 1
                    }
                }
                
                // если массив пустой значит все буквы найдены в слове, добавляем в подсказки
                if contentCopy.isEmpty {
                    hints = hints + word.fullWord! + ", "
                }
                
            }
            
            return hints
        }
        
        return hints
    }
    
    func getPredicateString(content contentDict: [Character : Int], position positionDict: [Int: Character], banned bannedDict: [Character : Int]) -> String {
        
        var predicateString = ""
        
        for letter in bannedDict.keys {
            
            // если строка не пустая нужно будет добавить AND
            predicateString = (predicateString != "" ? predicateString + " AND ": predicateString)
            
            let letterToStr = String(letter)
            predicateString = predicateString + "letter1 <> '\(letterToStr)' AND letter2 <> '\(letterToStr)' AND letter3 <> '\(letterToStr)' AND letter4 <> '\(letterToStr)' AND letter5 <> '\(letterToStr)'"
        }
       
        // для наглядности поставим скобочки
        predicateString = "(" + predicateString + ")"
        
        for i in 0...4 {
            
            if let pos = positionDict[i] {
                
                predicateString = (predicateString != "" ? predicateString + " AND ": predicateString)
                predicateString = predicateString + "letter\(i + 1) = '\(pos)'"
            }
        }
        
        // нужно будет учесть содержание и доработать чтобы выкидывал слова в позициях букв которые уже были опробованы
        
        return predicateString
    }
}
