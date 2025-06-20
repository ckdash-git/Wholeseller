//
//  User.swift
//  Wholeseller
//
//  Created by CHANDAN on 18/06/25.
//

import Foundation

struct User: Codable {
    var uid: String
    var email: String
    var fullName: String
    var role: String? = nil // "employee" or "jobSeeker"
    var company: String? = nil// only for employee
    var profilePicture: String?
}
