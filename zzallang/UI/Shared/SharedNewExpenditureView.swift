//
//  AddSharedExpenditureView.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/21.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedNewExpenditureView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    var tripData: TripData
    var dateItem: SharedDailyItem
    
    @State private var newItem: SharedExpenditureItem = SharedExpenditureItem.makeNewExpenditureItem()
    
    @State private var priceString: String = String()
    @State private var related: [String] = []
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
    
    var payerPicker: some View {
        HStack {
            Text("지출한 사람").font(.headline)
                .padding()
            Picker("Payer", selection: $newItem.payer) {
                ForEach(tripData.personalList, id: \.self) {
                    Text($0.userId).tag($0.userId)
                }
            }
            .padding(.trailing)
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var relatedMultiPicker: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            Text("관련된 사람").font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(tripData.personalList, id: \.self) { person in
                        RelatedPersonCell(userId: person.userId,
                            onSelected: {
                                self.relatedOnSelected(userId: person.userId)
                        }, onDeselected: {
                            self.relatedOnDeselected(userId: person.userId)
                        }
                        )
                    }
                }
            }
            .padding(.horizontal)
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
                .labelsHidden()
                .frame(width: UIScreen.main.bounds.width - 70)
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
        ScrollView {
            VStack(alignment: HorizontalAlignment.leading) {
                paymentPicker
                titleField
                priceField
                payerPicker
                relatedMultiPicker
                
                categoryPicker
                timePicker
                memoField
                
                makingNewExpenditureButton
            }
            .padding(.top)
        }
        .navigationBarTitle("공유지출 추가")
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
    
    func relatedOnSelected(userId: String) {
        related.append(userId)
    }
    
    func relatedOnDeselected(userId: String) {
        if related.contains(userId),
            let index = related.firstIndex(of: userId) {
            related.remove(at: index)
        }
    }
    
    func canMake() -> Bool {
        if newItem.title.isEmpty || newItem.payer.isEmpty || priceString.isEmpty || related.isEmpty {
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
        newItem.related = related
        newItem.time = Date.invertTimeToString(with: time)
        
        if let tripIndex = userData.trips.firstIndex(of: tripData),
            let dateIndex = userData.trips[tripIndex].sharedDateList.firstIndex(of: dateItem) {
            userData.trips[tripIndex].sharedDateList[dateIndex].expenditureList.append(newItem)
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct SharedNewExpenditureView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let tripData = userData.trips[0]
        return SharedNewExpenditureView(tripData: tripData, dateItem: tripData.sharedDateList[0])
            .environmentObject(userData)
    }
}
