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

        for i in 0...100 {
            
            wordString = String(arr[i])
            
            let word = Word(context: viewContext)
            word.fullWord = wordString
            
            do {
                try  viewContext.save()
            } catch let error {
                print("Error \(error)")
            }
        }
        
        return false
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
}
