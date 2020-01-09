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
    var tripData: TripData
    
    var body: some View {
            TabView {
                SharedPage(tripData: tripData)
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("공유")
                }.tag(0)
                PersonalPage()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("개인")
                }.tag(1)
            }
            .navigationBarTitle(tripData.name)
    }
}

struct TripPage_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return TripPage(tripData: userData.trips[0])
            .environmentObject(userData)
    }
}
