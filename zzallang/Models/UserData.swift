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
    @Published var trips = tripDatas
    @Published var infos = userInfoDatas
    
    func tripIndex(of tripData: TripData) -> Int {
        if let index = trips.firstIndex(of: tripData) {
            return index
        }
        return -1
    }
    
    func tripData(at index: Int) -> TripData? {
        if index != -1,
            index < trips.count {
            return trips[index]
        }
        return nil
    }
}
