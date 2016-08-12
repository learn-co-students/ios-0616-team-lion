//
//  Friend.swift
//  TeamLionGroupProject
//
//  Created by Flatiron School on 8/11/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import Foundation
//struct Friend {
//    var friendsName: String
//    var friendsProfilePic: String
//}




class UsersFriend: NSObject {
    
    let name: String
    var profilePicture: String?
    
    init(withName name: String,
                  profilePicture: String?) {
        
        
        self.name = name
        self.profilePicture = profilePicture
        
        super.init()
    }
    
    
}