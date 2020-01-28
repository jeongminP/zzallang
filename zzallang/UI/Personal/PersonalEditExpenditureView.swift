//
//  PersonalEditExpenditureView.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/28.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct PersonalEditExpenditureView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    var tripData: TripData
    var myUserId: String
    var dateItem: PersonalDailyItem
    var expenditureIndex: Int
    
    @State var expenditureItem: PersonalExpenditureItem
    @State var priceString: String
    @State var time: Date
    @State private var showingAlert = false
    
    var paymentPicker: some View {
        Picker("Payment", selection: $expenditureItem.payment) {
            ForEach(Payment.allCases, id: \.self) {
                Text($0.toKoreanString()).tag($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var titleField: some View {
        HStack {
            Text("지출명").font(.headline)
                .padding()
            TextField("내역 이름", text: $expenditureItem.title)
        }
    }
    
    var priceField: some View {
        HStack {
            Button(action: { self.flipCurrency() }) {
                Text(expenditureItem.currency.toString())
                    .padding()
            }
            TextField(String(expenditureItem.price), text: $priceString)
        }
    }
    
    var categoryPicker: some View {
        HStack {
            Picker("Category", selection: $expenditureItem.category) {
                ForEach(Category.allCases, id: \.self) {
                    $0.image().tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
    
    var timePicker: some View {
        return HStack {
            Text("시간").font(.headline)
                .padding()
            Spacer()
            DatePicker("time", selection: $time, displayedComponents: .hourAndMinute)
                .labelsHidden()
        }
    }
    
    var memoField: some View {
        HStack {
            Text("메모").font(.headline)
                .padding()
            TextField("메모", text: $expenditureItem.memo)
        }
    }
    
    var makingNewExpenditureButton: some View {
        Button(action: { self.verifyToMakeNewExpenditure() }) {
            Text("확인")
                .padding()
            }.disabled(!canMake())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("알림"), message: Text("정보를 올바르게 입력해주세요"), dismissButton: .default(Text("확인")))
        }
    }
    
    var body: some View {
        return VStack(alignment: HorizontalAlignment.leading) {       paymentPicker
            titleField
            priceField
            categoryPicker
            timePicker
            memoField
            
            makingNewExpenditureButton
        }
        .navigationBarTitle("개인지출 추가")
        .navigationBarItems(trailing: makingNewExpenditureButton)
    }
    
    func flipCurrency() {
        if tripData.currency == .krw {
            return
        }
        
        if expenditureItem.currency == .krw {
            expenditureItem.currency = tripData.currency
        } else {
            expenditureItem.currency = .krw
        }
    }
    
    func canMake() -> Bool {
        if expenditureItem.title.isEmpty || priceString.isEmpty {
            return false
        }
        return true
    }

    
    func verifyToMakeNewExpenditure() {
        guard let price = Int(priceString) else {
            self.showingAlert = true
            return
        }
        
        expenditureItem.price = price
        expenditureItem.time = Date.invertTimeToString(with: time)
        
        if let tripIndex = userData.trips.firstIndex(of: tripData),
            let person = userData.trips[tripIndex].personalList.first(where: {
                $0.userId == myUserId
            }),
            let personalIndex = userData.trips[tripIndex].personalList.firstIndex(of: person),
            let dateIndex = person.dateList.firstIndex(of: dateItem) {
            userData.trips[tripIndex].personalList[personalIndex].dateList[dateIndex].expenditureList[expenditureIndex] = expenditureItem
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct PersonalEditExpenditureView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let exampleItem = userData.trips[0].personalList[0].dateList[1].expenditureList[0]
        return PersonalEditExpenditureView(tripData: userData.trips[0], myUserId: userData.infos[0].userId, dateItem: userData.trips[0].personalList[0].dateList[1], expenditureIndex: 0, expenditureItem: exampleItem, priceString: String(exampleItem.price), time: Date.invertToTime(with: exampleItem.time))
    }
}
