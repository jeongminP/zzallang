//
//  SharedPageDateRow.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/09.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedPageDateRow: View {
    var item: SharedDailyItem
    
    var body: some View {
        List {
            Section(header: Text("\(item.date)")) {
                ForEach(item.expenditureList, id: \.self) {
                    SharedPageExpenditureRow(item: $0)
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

struct SharedPageDateRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return Group {
            SharedPageDateRow(item: userData.trips[0].sharedDateList[0])
            SharedPageDateRow(item: userData.trips[0].sharedDateList[1])
        }.previewLayout(.sizeThatFits)
    }
}
