//
//  DatabaseConnection.swift
//  HuPOS
//
//  Created by Cody Husek on 4/24/18.
//  Copyright © 2018 HuSoft Solutions. All rights reserved.
//

import Foundation
import Firebase

final class DatabaseConnections {
    
    let testDatabase:Fire
    
    init() {
        // Configure with manual options.
        let secondaryOptions = FirebaseOptions(googleAppID: "1:27992087142:ios:2a4732a34787067a", gcmSenderID: "27992087142")
        secondaryOptions.bundleID = "com.google.firebase.devrel.FiroptionConfiguration"
        secondaryOptions.apiKey = "AIzaSyBicqfAZPvMgC7NZkjayUEsrepxuXzZDsk"
        secondaryOptions.clientID = "27992087142-ola6qe637ulk8780vl8mo5vogegkm23n.apps.googleusercontent.com"
        secondaryOptions.databaseURL = "https://myproject.firebaseio.com"
        secondaryOptions.storageBucket = "myproject.appspot.com"
    }

    
}
