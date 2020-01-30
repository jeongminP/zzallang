//
//  SharedPageRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/09.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedPageExpenditureRow: View {
    var tripData: TripData
    var dateItem: SharedDailyItem
    var item: SharedExpenditureItem
    
    var body: some View {
        NavigationLink(destination: SharedEditExpenditureView(tripData: self.tripData, dateItem: self.dateItem, expenditureIndex: sharedExpenditureIndex(of: item), expenditureItem: item, priceString: String(item.price), time: Date.invertToTime(with: item.time))
        ) {
            HStack {
                Text(item.time)
                    .font(.caption)
                item.category.image()
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(item.title).font(.title)
                    Text(item.payer)
                }
                Spacer()
                Text("\(item.currency.toString()) \(item.price)").font(.body)
            }.frame(height: 50)
        }
    }
    
    func sharedExpenditureIndex(of item: SharedExpenditureItem) -> Int {
        if let index = dateItem.expenditureList.firstIndex(of: item) {
            return index
        }
        return -1
    }
}

struct SharedPageExpenditureRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return SharedPageExpenditureRow(tripData: userData.trips[0], dateItem: userData.trips[0].sharedDateList[0], item: userData.trips[0].sharedDateList[0].expenditureList[0])
    }
}
