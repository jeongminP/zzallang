//
//  PersonalPageDateRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/21.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct PersonalPageDateRow: View {
    var item: PersonalDailyItem
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("\(item.date) / \(item.dailyTitle)")
                Spacer()
                Text("KRW \(item.dailyCardExpenditure() + item.dailyCashExpenditure())")
            }) {
                ForEach(item.expenditureList, id: \.self) {
                    PersonalPageExpenditureRow(item: $0)
                }
                HStack{
                    Spacer()
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width:30.0, height: 30.0)
                    Spacer()
                }
            }
        }.frame(width: 400.0, height: CGFloat(item.expenditureList.count * 50 + 80))
    }
}

struct PersonalPageDateRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return Group {
            PersonalPageDateRow(item: userData.trips[0].personalList[0].dateList[0])
            PersonalPageDateRow(item: userData.trips[0].personalList[1].dateList[0])
        }.previewLayout(.sizeThatFits)
    }
}
