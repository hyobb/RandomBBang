//
//  AnyRepository.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/27.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation
import RealmSwift

class AnyRepository<RepositoryObject>: Repository
        where RepositoryObject: Entity,
        RepositoryObject.StoreType: Object {
    
    typealias RealmObject = RepositoryObject.StoreType
    
    private let realm: Realm

    init() {
        realm = try! Realm()
    }

    func getAll(where predicate: NSPredicate?) -> [RepositoryObject] {
        var objects = realm.objects(RealmObject.self).sorted(byKeyPath: "createdAt", ascending: false)

        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        return objects.compactMap { ($0).model as? RepositoryObject }
    }

    func insert(item: RepositoryObject) throws {
        try realm.write {
            realm.add(item.toStorable())
        }
    }

    func update(item: RepositoryObject) throws {
//        try delete(item: item)
//        try insert(item: item)
        print(item)
        try! realm.write {
            realm.add(item.toStorable(), update: .modified)
        }
    }

    func delete(item: RepositoryObject) throws {
        try realm.write {
            let predicate = NSPredicate(format: "uuid == %@", item.toStorable().uuid)
            if let productToDelete = realm.objects(RealmObject.self)
                .filter(predicate).first {
                realm.delete(productToDelete)
            }
        }
    }
}
