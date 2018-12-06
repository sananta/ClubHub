//
//  ProfileApi.swift
//  ClubHub
//
//  Created by Cindy Hoang on 12/5/18.
//  Copyright © 2018 Lindsey Gray. All rights reserved.
//

import Firebase
import Foundation
import GoogleSignIn

struct ProfileApi {
    
    typealias ApiCompletion = ((_ data: Any?, _ error: String?) -> Void)
    
    static func initProfileData(completion: @escaping ApiCompletion) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil, "Error initializing profile data: could not identify user")
            return
        }
        
        // Add user profile credentials
        let name = Auth.auth().currentUser?.displayName
        let email = Auth.auth().currentUser?.email
        let values = ["name": name, "email": email]
        Database.database().reference().child("users").child(userID).child("credentials").updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (err, _) in
            if err == nil {
                let profile = Profile(name: name, email: email, id: userID)
                completion(profile, nil)
            } else {
                completion(nil, "Error adding profile credentials")
            }
        })
    }
    
    static func info(forUserID: String, completion: @escaping ApiCompletion) {
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let profile = Profile.init(name: name, email: email, id: forUserID)
                completion(profile, nil)
            }
        })
    }
}