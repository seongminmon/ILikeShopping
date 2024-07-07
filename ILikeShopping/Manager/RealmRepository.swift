//
//  RealmRepository.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/7/24.
//

import Foundation
import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    var fileURL: URL? {
        return realm.configuration.fileURL
    }
    
    var schemaVersion: UInt64? {
        do {
            let version = try schemaVersionAtURL(fileURL!)
            return version
        } catch {
            return nil
        }
    }
    
    // MARK: - Create
    func addItem(_ item: Basket) {
        try! realm.write {
            realm.add(item)
            print("Realm Create!")
        }
    }
    
    // MARK: - Read
    func fetchAll() -> [Basket] {
        let value = realm.objects(Basket.self)
            .sorted(byKeyPath: "date", ascending: true)
        return Array(value)
    }
    
    // MARK: - Update
    func updateItem(_ item: Basket) {
        //
    }
    
    // MARK: - Delete
    // TODO: - 필터링 말고, productId를 기본키로 바꿔보기
    func deleteItem(_ productId: String) {
        let item = realm.objects(Basket.self).where {
            $0.productId == productId
        }
        try! realm.write {
            realm.delete(item)
            print("Realm Delete!")
        }
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
            print("Realm Delete All!")
        }
    }
}
