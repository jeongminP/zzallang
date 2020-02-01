//
//  PersonalPageDateRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/21.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct PersonalPageDateRow: View {
    @EnvironmentObject private var userData: UserData
    
    var tripData: TripData
    var myUserId: String
    var item: PersonalDailyItem
    var sortedList: [PersonalExpenditureItem] {
        item.expenditureList.sorted(by: { first, second in
            if first.time.compare(second.time) == .orderedDescending {
                return false
            }
            return true
        })
    }
    
    @State private var dailyTitle: String = ""
    @State private var showingModal = false
    
    var body: some View {
        List {
            Section(header: HStack {
                Button(action: {
                    self.dailyTitle = self.item.dailyTitle
                    self.showingModal.toggle()
                }) {
                    Text("\(item.date) / \(item.dailyTitle)")
                        .foregroundColor(Color.black)
                }
                .sheet(isPresented: $showingModal) {
                    TextFieldAlert(title: "제목", text: self.$dailyTitle, onDone: { self.onChangeDailyTitle()
                    })
                }
                
                Spacer()
                Text("KRW \(item.dailyCardExpenditure() + item.dailyCashExpenditure())")
            }) {
                ForEach(sortedList, id: \.self) {
                    PersonalPageExpenditureRow(tripData: self.tripData, myUserId: self.myUserId, dateItem: self.item, item: $0)
                }
                NavigationLink(destination: PersonalNewExpenditureView(tripData: self.tripData, myUserId: self.myUserId, dateItem: item)) {
                    HStack{
                        Spacer()
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width:30.0, height: 30.0)
                        Spacer()
                    }
                }
            }
        }.frame(width: 400.0, height: CGFloat(item.expenditureList.count * 65 + 65))
    }
    
    func onChangeDailyTitle() {
        if let tripIndex = userData.trips.firstIndex(of: tripData),
            let personalIndex = userData.trips[tripIndex].personalList.firstIndex(where: {
                $0.userId == myUserId
            }),
            let dateIndex = userData.trips[tripIndex].personalList[personalIndex].dateList.firstIndex(of: item) {
            userData.trips[tripIndex].personalList[personalIndex].dateList[dateIndex].dailyTitle = self.dailyTitle
        }
        return
    }

}

struct PersonalPageDateRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return Group {
            PersonalPageDateRow(tripData: userData.trips[0], myUserId: userData.infos[0].userId, item: userData.trips[0].personalList[0].dateList[0])
            PersonalPageDateRow(tripData: userData.trips[0], myUserId: userData.infos[0].userId, item: userData.trips[0].personalList[1].dateList[0])
        }.previewLayout(.sizeThatFits)
    }
}
