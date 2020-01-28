//
//  SharedPage.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/07.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct TripPage: View {
    @EnvironmentObject private var userData: UserData
    var tripIndex: Int
    
    var tripData: TripData? {
        userData.tripData(at: tripIndex)
    }
    
    var body: some View {
        guard let tripData = tripData else {
            return AnyView(Text("No Trip Data"))
        }
        return AnyView(
            TabView {
                SharedPage(tripData: tripData)
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("공유")
                }.tag(0)
                PersonalPage(tripData: tripData)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("개인")
                }.tag(1)
            }
            .navigationBarTitle(tripData.name)
        )
    }
}

struct TripPage_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return TripPage(tripIndex: 0)
            .environmentObject(userData)
    }
}
