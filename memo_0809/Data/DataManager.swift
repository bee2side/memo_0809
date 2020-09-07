//
//  DataManager.swift
//  memo_0809
//
//  Created by dylan.k on 2020/08/24.
//  Copyright © 2020 kakao. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    // Singleton
    static let shared = DataManager()
    private init() {
    }
    
    // Use Context
    var mainContenxt: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // memoList init
    var memoList = [Memo]()
    
    func fetchMemo() {
        // make fetch request
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        // sort by recent
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        // throw class so do & catch
        do {
            memoList = try mainContenxt.fetch(request)
        } catch {
            print(error)
        }
    }
    
    // add newMemo
    func addNewMemo (_ memo: String) {
        let newMemo = Memo(context: mainContenxt)
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        memoList.insert(newMemo, at: 0)
        saveContext()
    }
    
    // MARK: - App Delegate Code
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "memo_0809")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
