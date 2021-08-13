//
//  Model.swift
//  Play
//
//  Created by Rajesh Senapathi on 18/05/1400 AP.
//

import Foundation

// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}

typealias Welcome = [WelcomeElement]
