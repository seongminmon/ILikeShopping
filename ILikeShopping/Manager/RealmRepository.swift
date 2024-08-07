//
//  RealmRepository.swift
//  ILikeShopping
//
//  Created by 김성민 on 7/7/24.
//

import Foundation
import RealmSwift

enum FolderOption: Int, CaseIterable {
    case total
    case row
    case medium
    case high
    
    var title: String {
        switch self {
        case .total: return " 전체 "
        case .row: return "~ 10만원"
        case .medium: return "10 ~ 100만원"
        case .high: return "100만원 ~"
        }
    }
}

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
    
    // 첫 실행 때 Folder 없으면 Folder 3개 만들어주기
    func makeInitialFolder() {
        try! realm.write {
            let folder1 = Folder(price: 100_000, name: "~ 10만원")
            realm.add(folder1)
            
            let folder2 = Folder(price: 1_000_000, name: "10 ~ 100만원")
            realm.add(folder2)
            
            let folder3 = Folder(price: -1, name: "100만원 ~")
            realm.add(folder3)
        }
    }
    
    // MARK: - Create
    func addItem(_ item: Basket) {
        // Folder에 맞게 추가하기
        try! realm.write {
            let price = Int(item.lprice)!
            if price <= 100_000 {
                let folder = realm.objects(Folder.self)
                    .where { $0.price == 100_000 }
                    .first!
                folder.baskets.append(item)
            } else if price <= 1_000_000 {
                let folder = realm.objects(Folder.self)
                    .where { $0.price == 1_000_000 }	
                    .first!
                folder.baskets.append(item)
            } else {
                let folder = realm.objects(Folder.self)
                    .where { $0.price == -1 }
                    .first!
                folder.baskets.append(item)
            }
            print("Realm Create!")
        }
    }
    
    // MARK: - Read
    func fetchAll() -> [Basket] {
        let value = realm.objects(Basket.self)
            .sorted(byKeyPath: "date", ascending: true)
        return Array(value)
    }
    
    private func fetchBasket(_ productId: String) -> Basket? {
        return realm.object(ofType: Basket.self, forPrimaryKey: productId)
    }
    
    func isBasket(_ productId: String) -> Bool {
        return fetchBasket(productId) != nil
    }
    
    func fetchSearched(_ text: String) -> [Basket] {
        let value = realm.objects(Basket.self)
            .where { $0.title.contains(text, options: .caseInsensitive) }
            .sorted(byKeyPath: "date", ascending: true)
        return Array(value)
    }
    
    func fetchFolder() -> [Folder] {
        let value = realm.objects(Folder.self)
            .sorted(byKeyPath: "date", ascending: true)
        return Array(value)
    }
    
    func fetchFilteredFolder(_ option: FolderOption) -> Folder? {
        let folders = realm.objects(Folder.self)
            .sorted(byKeyPath: "date", ascending: true)
        switch option {
        case .total:
            return nil
        case .row:
            return folders.where { $0.price == 100_000 }.first
        case .medium:
            return folders.where { $0.price == 1_000_000 }.first
        case .high:
            return folders.where { $0.price == -1 }.first
        }
    }
    
    // MARK: - Update
    func updateItem(_ item: Basket) {
        //
    }
    
    // MARK: - Delete
    func deleteItem(_ productId: String) {
        if let item = fetchBasket(productId) {
            try! realm.write {
                realm.delete(item)
                print("Realm Delete!")
            }
        }
    }
    
    func deleteAll() {
        // 탈퇴하기 시 장바구니 전체 삭제
        // Folder는 삭제 X
        try! realm.write {
            let baskets = realm.objects(Basket.self)
            realm.delete(baskets)
            print("Realm Delete All!")
        }
    }
}
