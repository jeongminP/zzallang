//
//  SharedPage.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/07.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedPage: View {
    @EnvironmentObject private var userData: UserData
    
    var tripData: TripData
    var sharedList: [SharedDailyItem] {
        tripData.sharedDateList
    }
    var totalExpenditure: Int {
        tripData.totalCashExpenditure() + tripData.totalCardExpenditure()
    }
    
    @State private var showingModal: Bool = false
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            VStack(alignment: HorizontalAlignment.leading) {
                Button(action: {
                    self.showingModal.toggle()
                }) {
                    Text("여행기간 : \(tripData.startingDate) ~ \(tripData.finishingDate)").font(.headline)
                        .foregroundColor(Color.black)
                }.sheet(isPresented: self.$showingModal) {
                    EditTripView(tripIndex: self.userData.tripIndex(of: self.tripData),
                        tripData: self.tripData,
                        startingDateObject: Date.invertToDate(with: self.tripData.startingDate),
                        finishingDateObject: Date.invertToDate(with: self.tripData.finishingDate))
                            .environmentObject(self.userData)
                }
                Text("총 지출: ₩\(totalExpenditure)").font(.headline)
                HStack {
                    Text("현금 ₩\(tripData.totalCashExpenditure())")
                    Text("카드 ₩\(tripData.totalCardExpenditure())")
                }
            }
            .padding(.top)
            .padding(.leading)
            
            List {
                ForEach(sharedList, id: \.self) { dateItem in
                    SharedPageDateRow(tripData: self.tripData, item: dateItem)
                }
            }
        }
    }
}

struct SharedPage_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return SharedPage(tripData: userData.trips[0]).environmentObject(userData)
    }
}
