//
//  ContentView.swift
//  zzallang
//
//  Created by 박정민 on 01/01/2020.
//  Copyright © 2020 박정민. All rights reserved.
//

import Combine
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        NavigationView{
            List{
                ForEach(userData.trips) {trip in
                    NavigationLink(destination: TripPage(tripData: trip)) {
                            Text(trip.name)
                            .font(.headline)
                            .padding(.leading, 10.0)
                                .frame(height: 100.0)
                        }
                }
                NavigationLink(destination: NewTripView()) {
                    VStack {
                        Image(systemName: "plus.circle")
                        Text("새 여행 만들기")
                        .font(.headline)
                    }
                    .padding(.leading, 10.0)
                    .frame(height: 100.0)
                }
            }
            .navigationBarTitle("내 여행 목록", displayMode: .inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserData())
    }
}
