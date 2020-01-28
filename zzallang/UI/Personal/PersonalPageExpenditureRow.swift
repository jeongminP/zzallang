//
//  PersonalPageExpenditureRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/21.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct PersonalPageExpenditureRow: View {
    var tripData: TripData
    var myUserId: String
    var dateItem: PersonalDailyItem
    var item: PersonalExpenditureItem
    
    var body: some View {
        NavigationLink(destination: PersonalEditExpenditureView(tripData: self.tripData, myUserId: self.myUserId, dateItem: self.dateItem, expenditureIndex: personalExpenditureIndex(of: item), expenditureItem: item, priceString: String(item.price), time: Date.invertToTime(with: item.time))
        ) {
            HStack {
                Text(item.time)
                    .font(.caption)
                item.category.image()
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(item.title).font(.title)
                }
                Spacer()
                Text("\(item.currency.toString()) \(item.price)").font(.body)
            }.frame(height: 50)
        }
    }
    
    func personalExpenditureIndex(of item: PersonalExpenditureItem) -> Int {
        if let index = dateItem.expenditureList.firstIndex(of: item) {
            return index
        }
        return -1
    }
}

struct PersonalPageExpenditureRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let exampleItem = userData.trips[0].personalList[0].dateList[0].expenditureList[0]
        return PersonalPageExpenditureRow(tripData: userData.trips[0], myUserId: userData.infos[0].userId, dateItem: userData.trips[0].personalList[0].dateList[0], item: exampleItem)
    }
}
