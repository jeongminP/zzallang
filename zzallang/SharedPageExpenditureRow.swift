//
//  SharedPageRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/09.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedPageExpenditureRow: View {
    var item: SharedExpenditureItem
    
    var body: some View {
        HStack {
            item.category.image()
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(item.title).font(.title)
                Text(item.payer)
            }
            Spacer()
            Text("\(item.currency.toString()) \(item.price)").font(.body)
        }.frame(height: 70)
        .padding()
    }
}

struct SharedPageExpenditureRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return SharedPageExpenditureRow(item: userData.trips[0].sharedDateList[0].expenditureList[0])
    }
}
