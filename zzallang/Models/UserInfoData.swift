//
//  UserInfoData.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/21.
//  Copyright © 2020 박정민. All rights reserved.
//

import Foundation

struct UserInfoData: Hashable, Codable {
    var userId: String
    var password: String
    var id: Int
    var nickname: String
    var labelColor: String
}
