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
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let scopes = "user-read-private"
        static let redirectURI = "http://www.afrikaizen.co.zw/"
        
    }
    
     private init() {}
    
     public var signInURL: URL? {
        
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
         let currentDate = Date()
         let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
        
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ){
        
    //Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var componets = URLComponents()
        componets.queryItems = [
            URLQueryItem(name: "grant_type",
                         value: "authorization_code"),
            URLQueryItem(name: "code",
                         value: code),
            URLQueryItem(name: "redirect_uri",
                        value: "http://www.afrikaizen.co.zw/"),
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = componets.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
      let task =  URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data,
                error == nil else {
                completion(false)
                return
            }
        do {
            let result = try JSONDecoder().decode(AuthResponse.self, from: data)
            self?.cacheToken(result: result)
            
            
            print("SUCCESS: \(result)")
            completion(true)
        }
        
        catch {
            print(error.localizedDescription)
            completion(false)
        }
        
        }
        task.resume()
        
    }
    
    public func refreshIfNeeded(completion: @escaping(Bool) -> Void){
//        guard shouldRefreshToken else {
//            completion(true)
//            return
//        }
        
        guard let refreshToken = self.refreshToken else {
            return
            
        }
        //Refresh the token
        
        //Get Token
            guard let url = URL(string: Constants.tokenAPIURL) else {
                return
            }
            
            var componets = URLComponents()
            componets.queryItems = [
                URLQueryItem(name: "grant_type",
                             value: "refresh_code"),
                URLQueryItem(name: "refresh_token",
                            value: refreshToken),
            ]
            
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = componets.query?.data(using: .utf8)
            
            let basicToken = Constants.clientID+":"+Constants.clientSecret
            let data = basicToken.data(using: .utf8)
            guard let basic64String = data?.base64EncodedString() else {
                print("Failure to get base64")
                completion(false)
                return
            }
            
            request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
          let task =  URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
                guard let data = data,
                    error == nil else {
                    completion(false)
                    return
                }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("Successfully refreshed")
                self?.cacheToken(result: result)
                
                
                print("SUCCESS: \(result)")
                completion(true)
            }
            
            catch {
                print(error.localizedDescription)
                completion(false)
            }
            
            }
            task.resume()
        
        
    }
    
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
            
        }
       
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        
    }
    
}
