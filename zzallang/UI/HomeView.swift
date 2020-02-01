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
    
    var userButton: some View {
        NavigationLink(destination: UserView()) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 30.0, height: 30.0)
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(userData.trips) {trip in
                    NavigationLink(destination: TripPage(tripIndex: self.userData.tripIndex(of: trip))) {
                        HStack {
                            Spacer()
                            
                            Text(trip.name)
                            .font(.headline)
                            .padding(.leading, 10.0)
                                .frame(height: 100.0)
                            
                            Spacer()
                        }
                    }
                }
                NavigationLink(destination: NewTripView()) {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(systemName: "plus.circle")
                            Text("새 여행 만들기")
                            .font(.headline)
                        }
                        .padding(.leading, 10.0)
                        .frame(height: 100.0)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("내 여행 목록", displayMode: .inline)
            .navigationBarItems(trailing: userButton)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserData())
    }
}
