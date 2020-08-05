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
    
    func update(hype: Hype, completion: @escaping (Result<Hype, HypeError>) -> Void) {
        
        //2.1 : Create a record from our hype to pass into our operation
        let record =  CKRecord(hype: hype)
        //2 : Create the operation
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        //3 : Adjust the properties for the operation
        operation.savePolicy = .changedKeys  //only update changed body instead of creating whole things
        operation.qualityOfService = .userInteractive //Highest level of importnt, want to update right away
        operation.modifyRecordsCompletionBlock = {(records, _, error) in
            //4 : Handle any error
            if let error = error {
                print("There was an error modifying your the Hype -- \(error) -- \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            //5: Unwrap the record that was updated and create a hype from it
            guard let record = records?.first,
                let updatedHype = Hype(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            
            //6 : Complete success, passing in the updata hype
            completion(.success(updatedHype))
        }
        //1 : Add an operation to the database
        publicDB.add(operation)
    }

    
    //Delete
    
    func delete(hype: Hype, completion: @escaping (Result<Bool, HypeError>) -> Void) {
        
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [hype.recordID])
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {(_, recordIDs, error) in
            if let error = error {
                print("There was an error deletig a Hype record \(error) -- \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let recordIDs = recordIDs else {return completion(.failure(.couldNotUnwrap))}
            if recordIDs.count > 0 {
                print("Deleted Record(s) from CloudKit \(recordIDs)")
                completion(.success(true))
            } else {
                return completion(.failure(.unableToDeleteRecord))
            }
        }
        publicDB.add(operation)
    }
    
}
