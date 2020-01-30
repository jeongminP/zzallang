//
//  SharedPage.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/07.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedPage: View {
    var tripData: TripData
    var sharedList: [SharedDailyItem] {
        tripData.sharedDateList
    }
    var totalExpenditure: Int {
        tripData.totalCashExpenditure() + tripData.totalCardExpenditure()
    }
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            VStack(alignment: HorizontalAlignment.leading) {
                Text("여행기간 : \(tripData.startingDate) ~ \(tripData.finishingDate)").font(.headline) //추후 여행정보 수정을 위한 버튼으로 변경
                HStack {
                    Text("총 지출: ₩\(totalExpenditure)").font(.headline)
                    Text("현금 ₩\(tripData.totalCashExpenditure())")
                    Text("카드 ₩\(tripData.totalCardExpenditure())")
                }
            }
            .frame(width: CGFloat(400.0))
            .offset(x: 10.0)
            
            List {
                ForEach(sharedList, id: \.self) { dateItem in
                    SharedPageDateRow(tripData: self.tripData, item: dateItem)
                }
            }
        }
        .offset(x: -10.0, y: 10.0)
    }
    
}

struct SharedPage_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return SharedPage(tripData: userData.trips[0]).environmentObject(userData)
    }
}
