//
//  StorageManager.swift
//  ConnectPOS
//
//  Created by Black on 11/9/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import RealmSwift

typealias ObjectType = BaseRealmObject.Type

class Storage {
    static let shared = Storage()
    
    init() {
    }
    
    private func newRealmInstance() -> Realm? {
        var realm : Realm?
        do {
            realm = try Realm()
            return realm
        }
        catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    // 15/11: Add new objects, if exist -> Update
    func addOrUpdate(_ objects: [BaseRealmObject], type: BaseRealmObject.Type) {
        guard objects.count > 0 else { return }
        guard let realm = self.newRealmInstance() else { return }
        do {
            try realm.write {
                debugPrint("+ Add/Updated \(objects.count) \(type)")
                realm.add(objects, update: true)
            }
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    // 15/11: Update exist objects only
    func update(_ objects: [BaseRealmObject], type: BaseRealmObject.Type) {
        guard objects.count > 0 else { return }
        guard let realm = self.newRealmInstance() else { return }
        do {
            try realm.write {
                let updateObjects = realm.objects(type).filter({ (obj) -> Bool in
                    return objects.first(where: {$0.isEqualId(obj)}) != nil
                })
                debugPrint("+ Updated \(updateObjects.count) \(type)")
                if updateObjects.count > 0 {
                    realm.add(updateObjects, update: true)
                }
            }
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    // 15/11: item.delete instead of realm.delete(objects) because item need to delete reference object
    //    func delete(type: BaseRealmObject.Type, objects: [BaseRealmObject]?) {
    //        self.delete(type, done: {
    //
    //        })
    //        //self.delete(type: type, ids: objects?.map({$0.getObjectId}))
    //    }
    
    // Delete base object
    //    func delete(type: ObjectType, ids: [String]? = nil) {
    //        // nil -> delete all
    //        // != nil -> count > 0 -> delete items
    //        guard ids == nil || ids!.count > 0 else {return}
    //        guard let realm = self.newRealmInstance() else { return }
    //        do {
    //            try realm.write {
    //                let deleteObjects = realm.objects(type).filter({ids == nil || (ids?.contains($0.getObjectId) ?? true)})
    //                debugPrint("- Delete \(deleteObjects.count) \(type)")
    //                for item in deleteObjects {
    //                    item.delete(realm: realm)
    //                }
    //            }
    //        }
    //        catch {
    //            debugPrint(error.localizedDescription)
    //        }
    //    }
    
    // Get objects from local DB
    func getObjects(type: ObjectType, ids: [String]?) -> [BaseRealmObject] {
        guard let realm = self.newRealmInstance() else { return []}
        let all = realm.objects(type)
        let filter = all.filter({ids == nil || ids!.contains($0.getObjectId)})
        return Array(filter)
    }
    
    func getObjects(type: ObjectType) -> [BaseRealmObject] {
        guard let realm = self.newRealmInstance() else { return []}
        return Array(realm.objects(type))
    }
    
//    func getCountries() -> [Country] {
//        let countries = objects(Country.self)?.sorted(by: { (country1, country2) -> Bool in
//            return country1.name < country2.name
//        })
//        return countries ?? []
//    }
    
    // Make statement running in a Realm transaction
    func run(closure: (() -> Void), failured: ((String) -> Void)? = nil) {
        guard let realm = self.newRealmInstance() else { return }
        do {
            try realm.write {
                closure()
            }
        }
        catch {
            debugPrint(error.localizedDescription)
            failured?(error.localizedDescription)
        }
    }
    
    func removeAll() {
        guard let realm = self.newRealmInstance() else { return }
        do {
            debugPrint("REMOVE ALL DB")
            try realm.write {
                realm.deleteAll()
            }
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
}

// MARK: - UPDATE CODE TYPE

extension Storage {
    func update<T: BaseRealmObject>(_ objects: [T]) {
        guard objects.count > 0, let realm = self.newRealmInstance() else { return }
        do {
            try realm.write {
                let updateObjects = realm.objects(T.self).filter({ (obj) -> Bool in
                    return objects.first(where: {$0.isEqualId(obj)}) != nil
                })
                debugPrint("+ Updated \(updateObjects.count) \(T.self)")
                if updateObjects.count > 0 {
                    realm.add(updateObjects, update: true)
                }
            }
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func addOrUpdate<T: BaseRealmObject>(_ objects: [T]) {
        guard objects.count > 0, let realm = self.newRealmInstance() else { return }
        do {
            try realm.write {
                debugPrint("+ Add/Updated \(objects.count) \(T.self)")
                realm.add(objects, update: true)
            }
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func delete<T: BaseRealmObject>(_ type: T.Type, ids: [String]? = nil, idPrefix: String = "") {
        guard let realm = self.newRealmInstance() else { return }
        do {
            var deleteObjects = realm.objects(type) //.filter({ids == nil || (ids?.contains($0.getObjectId) ?? true)})
            if let ids = ids {
                if ids.count == 0 {
                    return
                }
                var predicate = NSPredicate(format: "\(idPrefix) IN %@", ids)
//                if type == Order.self {
//                    predicate = NSPredicate(format: "order_id IN %@", ids)
//                }
//                else if type == Region.self {
//                    predicate = NSPredicate(format: "region_id IN %@", ids)
//                }
                debugPrint("==> DELETE", predicate, "object count: \(deleteObjects.count)")
                deleteObjects = deleteObjects.filter(predicate)  //({ids.contains($0.getObjectId) ?? true})
                debugPrint("==> DELETE", "new delete object count: \(deleteObjects.count)")
            }
            realm.beginWrite()
            debugPrint("- Delete \(deleteObjects.count) \(type)")
            realm.delete(deleteObjects)
            try realm.commitWrite()
        }
        catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}

extension Storage {
    func objects<T: BaseRealmObject>(_ type: T.Type, ids: [String]? = nil) -> [T]? {
        guard let realm = newRealmInstance() else {return nil}
        let all = realm.objects(type)
        guard let ids = ids?.sorted(by: {$0 < $1}) else {
            return all.map({$0})
        }
        let sorted = all.sorted(by: {$0.getObjectId < $1.getObjectId})
        var filter : [T] = []
        var index = 0
        for i in 0..<sorted.count {
            if index >= ids.count {
                break
            }
            let obj = sorted[i]
            let id = ids[index]
            if obj.getObjectId == id {
                filter.append(obj)
                index += 1
            }
        }
        //let filter = sorted.filter({ids.contains($0.getObjectId)})
        return filter
    }
}

