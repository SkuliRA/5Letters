//
//  Word+CoreDataProperties.swift
//  5Letters
//
//  Created by Skuli on 13.11.2022.
//
import Foundation
import CoreData

extension WordL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordL> {
        return NSFetchRequest<WordL>(entityName: "WordL")
    }

    @NSManaged public var fullWord: String?

}

extension WordL : Identifiable {

}
