//
//  UserProfile.swift
//  Ikigai
//
//  Created by SAHIL KHATRI on 16/06/25.
//

import Foundation

// --- UPDATED: Add 'Equatable' to the list of protocols ---
struct UserProfile: Codable, Equatable {
    var totalXP: Int = 0
    
    // A computed property to calculate the user's level.
    // For every 100 XP, the user gains a level.
    var level: Int {
        return (totalXP / 100) + 1
    }
    
    // Calculates progress towards the next level (e.g., 50/100 XP).
    var progressTowardsNextLevel: Int {
        return totalXP % 100
    }
}
