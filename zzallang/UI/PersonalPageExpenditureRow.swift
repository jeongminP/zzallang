//
//  PersonalPageExpenditureRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/21.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct PersonalPageExpenditureRow: View {
    var item: PersonalExpenditureItem
    
    var body: some View {
        HStack {
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

struct PersonalPageExpenditureRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let exampleItem = userData.trips[0].personalList[0].dateList[0].expenditureList[0]
        return PersonalPageExpenditureRow(item: exampleItem)
    }
}
