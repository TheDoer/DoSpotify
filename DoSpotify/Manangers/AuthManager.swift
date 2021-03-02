//
//  AuthManager.swift
//  DoSpotify
//
//  Created by Adonis Rumbwere on 25/2/2021.
//  Copyright © 2021 akdigital. All rights reserved.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
   
    
    struct Constants {
       static let clientID = "9b4362d09ae648e7a678907fc0c25dd8"
       static let clientSecret = "5c9660914d104c228c337520a1dccde8"
    }
    
     private init() {}
    
     public var signInURL: URL? {
        let scopes = "user-read-private"
        let redirectURI = "http://www.afrikaizen.co.zw/"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return true
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
