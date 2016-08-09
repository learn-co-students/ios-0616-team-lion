//
//  PlaceUserDataStore.swift
//  TeamLionGroupProject
//
//  Created by Flatiron School on 8/9/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import FirebaseAuth

class PlaceUserDataStore {
    
    static let sharedDataStore = PlaceUserDataStore()
    private init(){}
    
    // user properties
    
    // function to retrieve photo
    func getImageFor(photoURL: NSURL?) -> UIImage? {
        // may need to jump on background thread
        guard let url = photoURL else {return nil}
        guard let data = NSData(contentsOfURL: url) else {return nil}
        return UIImage(data: data)
    }
    
    func updatePlaceUserFrom(FIRUser user: FIRUser)  {
        
        let displayName = user.displayName
        
        
        
    }
    
    
}