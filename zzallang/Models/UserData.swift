//
//  UserData.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/07.
//  Copyright © 2020 박정민. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var trips = tripData
}
