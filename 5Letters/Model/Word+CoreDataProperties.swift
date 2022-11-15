//
//  Word+CoreDataProperties.swift
//  5Letters
//
//  Created by Skuli on 13.11.2022.
//
import Foundation
import CoreData

extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var fullWord: String?

}

extension Word : Identifiable {

}

