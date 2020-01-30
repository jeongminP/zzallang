//
//  PersonalNewExpenditureView.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/23.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct PersonalNewExpenditureView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    var tripData: TripData
    var myUserId: String
    var dateItem: PersonalDailyItem
    
    @State private var newItem: PersonalExpenditureItem = PersonalExpenditureItem.makeNewExpenditureItem()
    
    @State private var priceString: String = String()
    @State private var time = Date()
    @State private var showingAlert = false
    
    var paymentPicker: some View {
        Picker("Payment", selection: $newItem.payment) {
            ForEach(Payment.allCases, id: \.self) {
                Text($0.toKoreanString()).tag($0)
            }
        }
        .padding(.horizontal)
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var titleField: some View {
        HStack {
            Text("지출명").font(.headline)
                .padding()
            TextField("내역 이름", text: $newItem.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing)
        }
    }
    
    var priceField: some View {
        HStack {
            Button(action: { self.flipCurrency() }) {
                Text(newItem.currency.toString())
                    .padding()
            }
            TextField("0", text: $priceString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing)
        }
    }
    
    var categoryPicker: some View {
        HStack {
            Picker("Category", selection: $newItem.category) {
                ForEach(Category.allCases, id: \.self) {
                    $0.image().tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
    }
    
    var timePicker: some View {
        HStack {
            Text("시간").font(.headline)
                .padding()
            Spacer()
            DatePicker("time", selection: $time, displayedComponents: .hourAndMinute)
                .padding(.trailing)
                .labelsHidden()
        }
    }
    
    var memoField: some View {
        HStack {
            Text("메모").font(.headline)
                .padding()
            TextField("메모", text: $newItem.memo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing)
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
        VStack(alignment: HorizontalAlignment.leading) {
            paymentPicker
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
        
        if newItem.currency == .krw {
            newItem.currency = tripData.currency
        } else {
            newItem.currency = .krw
        }
    }
    
    func canMake() -> Bool {
        if newItem.title.isEmpty || priceString.isEmpty {
            return false
        }
        return true
    }

    
    func verifyToMakeNewExpenditure() {
        guard let price = Int(priceString) else {
            self.showingAlert = true
            return
        }
        
        newItem.price = price
        newItem.time = Date.invertTimeToString(with: time)
        
        if let tripIndex = userData.trips.firstIndex(of: tripData),
            let person = userData.trips[tripIndex].personalList.first(where: {
                $0.userId == myUserId
            }),
            let personalIndex = userData.trips[tripIndex].personalList.firstIndex(of: person),
            let dateIndex = person.dateList.firstIndex(of: dateItem) {
            userData.trips[tripIndex].personalList[personalIndex].dateList[dateIndex].expenditureList.append(newItem)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct PersonalNewExpenditureView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let tripData = userData.trips[0]
        return PersonalNewExpenditureView(tripData: tripData, myUserId: userData.infos[0].userId, dateItem: tripData.personalList[0].dateList[0])
            .environmentObject(userData)
    }
}
