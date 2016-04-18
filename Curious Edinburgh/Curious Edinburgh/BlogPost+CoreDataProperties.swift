//
//  BlogPost+CoreDataProperties.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 18/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BlogPost {

    @NSManaged var content: NSData?
    @NSManaged var customFields: NSData?
    @NSManaged var excerpt: NSData?
    @NSManaged var link: String?
    @NSManaged var remoteID: NSNumber?
    @NSManaged var title: NSData?

}
