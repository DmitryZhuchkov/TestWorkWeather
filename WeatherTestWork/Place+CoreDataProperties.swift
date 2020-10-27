//
//  Place+CoreDataProperties.swift
//  WeatherTestWork
//
//  Created by Дмитрий Жучков on 27.10.2020.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var fullDescription: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var sightsName: String?
    @NSManaged public var smallDescription: String?

}

extension Place : Identifiable {

}
