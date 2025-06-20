//
//  AppVersionModel.swift
//  Wholeseller
//
//  Created by CHANDAN on 20/06/25.
//

import Foundation
struct AppVersionModel: Identifiable {
    let id = UUID()
    let version: String
    let date: String
}
