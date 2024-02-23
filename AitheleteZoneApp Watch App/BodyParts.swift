//
//  BodyParts.swift
//  AitheleteZoneApp Watch App
//
//  Created by Andrew Ho on 2/23/24.
//

import SwiftUI

struct BodyParts: Hashable, Identifiable {
    let id = UUID()
    let bodyPart: String
}

struct MockData {
    
    static let bodyParts = [
        BodyParts(bodyPart: "Shoulders"),
        BodyParts(bodyPart: "Legs"),
        BodyParts(bodyPart: "Chest"),
        BodyParts(bodyPart: "Back"),
    ]
    
}
