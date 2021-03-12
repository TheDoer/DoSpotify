//
//  AuthResponse.swift
//  DoSpotify
//
//  Created by Adonis Rumbwere on 9/3/2021.
//  Copyright © 2021 akdigital. All rights reserved.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
