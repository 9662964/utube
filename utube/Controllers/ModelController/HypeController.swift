//
//  HypeController.swift
//  utube
//
//  Created by ILJOO CHAE on 8/5/20.
//  Copyright © 2020 ILJOO CHAE. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    //MARK: shared instance
    static let shared = HypeController()
    
    //MARK: SOT
    var hypes: [Hype] = []
    
    //MARK: will access to public cloud data
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: CRUD Methods
    
    //Create
    func saveHype(body: String, completion: @escaping (Result<Hype, HypeError>) -> Void) {
        //3 : Create a hype to pass to our CKRecord initializer
        let newHype = Hype(body: body)
        //2 : Create a CKRecord to pass to our save method
        let hypeRecord = CKRecord(hype: newHype)
        //1 : Call the CKContainer's save method
        publicDB.save(hypeRecord) { (record, error) in
            if let error = error {
                //4 : handle any error
                print("There was an eror saving a Hype \(error) -- \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            //5: Guard to make sure we got a record bak and that we can turn it into a Hype
            guard let record = record,
                let savedHype = Hype(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
                print("Saved Hype Successfully")
                //6 : Complete with that saved hype
                completion(.success(savedHype))
        }
    }
    
    //Read(Fetch, Retrieve)
    func fetchAllHypes(completion: @escaping (Result<[Hype], HypeError>) -> Void) {
        
        //3: Create a predicate for our CKQuery
        let predicate = NSPredicate(value: true)
        //2 : Creating a CKQuery for our perform method
        let query = CKQuery(recordType: HypeConstants.recordTypeKey, predicate: predicate)
        //1 : Call the perform method on our database
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            //4 : handle eror
            if let error = error {
                print("There was an error fetching all Hypes - \(error) -- \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            //5 : Guard to make sure we received records from our perform method
            guard let records = records else {return completion(.failure(.couldNotUnwrap)) }
            print("Fetched Hype Records Successfully")
            //6: Turn our records (CKRecord) into Hypes
            let fetchedHypes = records.compactMap {Hype(ckRecord: $0)}
            //7 : Complete with our array of hypes
            completion(.success(fetchedHypes))
        }
        
    }
    //Update
    
    //Delete
    
}
