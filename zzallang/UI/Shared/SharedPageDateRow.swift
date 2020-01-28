//
//  SharedPageDateRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/09.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedPageDateRow: View {
    var tripData: TripData
    var item: SharedDailyItem
    
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
                Text("\(item.date) / \(item.dailyTitle)")
                Spacer()
                Text("KRW \(item.dailyCardExpenditure() + item.dailyCashExpenditure())")
            }) {
                ForEach(sortedList, id: \.self) {
                    SharedPageExpenditureRow(item: $0)
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
