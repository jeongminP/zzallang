//
//  PersonalPage.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/09.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct PersonalPage: View {
    @EnvironmentObject private var userData: UserData
    var tripData: TripData
    var myUserId : String {
        userData.infos[0].userId
    }
    
    var myItem: PersonalListItem? {
        tripData.personalList.first(where: {
            $0.userId == myUserId
        })
    }
    var myDateList: [PersonalDailyItem] {
        myItem?.dateList ?? []
    }
    var sharedExpenditure: Int {
        tripData.sharedExpenditure(of: myUserId)
    }
    var personalExpenditure: Int {
        if let myItem = myItem {
            return myItem.personalExpenditure()
        }
        return 0
    }
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("나의 총 지출: ₩\(sharedExpenditure + personalExpenditure)").font(.headline)
                    Text("공유 지출: ₩\(sharedExpenditure)")
                    Text("개인 지출: ₩\(personalExpenditure)")
                }
                Spacer()
                Text("자세히").font(.headline)
                .padding()
            }
            .padding(.top)
            .padding(.leading)
            
            List {
                ForEach(myDateList, id: \.self) { dateItem in
                    PersonalPageDateRow(tripData: self.tripData, myUserId: self.myUserId, item: dateItem)
                }
            }
        }
    }
}

struct PersonalPage_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return PersonalPage(tripData: userData.trips[0])
            .environmentObject(userData)
    }
}
