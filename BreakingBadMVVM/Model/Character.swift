//
//  Character.swift
//  BreakingBadMVVM
//
//  Created by Abilio Gambim Parada on 20/01/2020.
//  Copyright © 2020 Abilio Gambim Parada. All rights reserved.
//

import Foundation

struct Character: Codable {

    var charId: Int
    var name: String
    var birthday: String
    var occupation: [String]
    var img: String
    var status: String
    var nickname: String
    var appearance: [Int]
    var portrayed: String
    var category: String
    var betterCallSaulAppearance: [Int]

    enum CodingKeys: String, CodingKey {
        case charId = "char_id",
        name,
        birthday,
        occupation,
        img,
        status,
        nickname,
        appearance,
        portrayed,
        category,
        betterCallSaulAppearance = "better_call_saul_appearance"
    }
}
