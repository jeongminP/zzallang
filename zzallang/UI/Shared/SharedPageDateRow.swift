//
//  SharedPageDateRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/09.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedPageDateRow: View {
    @EnvironmentObject private var userData: UserData
    
    var tripData: TripData
    var item: SharedDailyItem
    
    @State private var dailyTitle: String = ""
    @State private var showingModal = false
    
    var sortedList: [SharedExpenditureItem] {
        item.expenditureList.sorted(by: { first, second in
            if first.time.compare(second.time) == .orderedDescending {
                return false
            }
            return true
        })
    }
    
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
                    SharedPageExpenditureRow(tripData: self.tripData, dateItem: self.item, item: $0)
                }
                NavigationLink(destination: SharedNewExpenditureView(tripData: tripData, dateItem: item)) {
                    HStack{
                        Spacer()
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width:30.0, height: 30.0)
                        Spacer()
                    }
                }
            }
        }.frame(width: 400.0, height: CGFloat(item.expenditureList.count * 63 + 65))
    }
    
    func onChangeDailyTitle() {
        if let tripIndex = userData.trips.firstIndex(of: tripData),
            let dateIndex = tripData.sharedDateList.firstIndex(of: item) {
            
            userData.trips[tripIndex].sharedDateList[dateIndex].dailyTitle = self.dailyTitle
        }
        return
    }
}

struct SharedPageDateRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let tripData = userData.trips[0]
        return Group {
            SharedPageDateRow(tripData: tripData, item: tripData.sharedDateList[0])
            SharedPageDateRow(tripData: tripData, item: tripData.sharedDateList[1])
        }.previewLayout(.sizeThatFits)
    }
}
