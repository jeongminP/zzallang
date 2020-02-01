//
//  SharedEditExpenditureView.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/30.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct SharedEditExpenditureView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    var tripData: TripData
    var dateItem: SharedDailyItem
    var expenditureIndex: Int
    
    @State var expenditureItem: SharedExpenditureItem
    @State var priceString: String
    @State var time: Date
    @State private var showingAlert = false
    
    var paymentPicker: some View {
        Picker("Payment", selection: $expenditureItem.payment) {
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
            TextField("내역 이름", text: $expenditureItem.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing)
        }
    }
    
    var priceField: some View {
        HStack {
            Button(action: { self.flipCurrency() }) {
                Text(expenditureItem.currency.toString())
                    .padding()
            }
            TextField(String(expenditureItem.price), text: $priceString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing)
        }
    }
    
    var payerPicker: some View {
        HStack {
            Text("지출한 사람").font(.headline)
                .padding()
            Picker("Payer", selection: $expenditureItem.payer) {
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
                HStack(alignment: .top, spacing: CGFloat(10)) {
                    ForEach(tripData.personalList, id: \.self) { person in
                        RelatedPersonCell(isSelected: self.expenditureItem.related.contains(person.userId), userId: person.userId,
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
                .padding(.trailing)
                .labelsHidden()
        }
    }
    
    var memoField: some View {
        HStack {
            Text("메모").font(.headline)
                .padding()
            TextField("메모", text: $expenditureItem.memo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.trailing)
        }
    }
    
    var editingExpenditureButton: some View {
        Button(action: { self.verifyToEditExpenditure() }) {
            Text("확인")
                .padding()
            }.disabled(!canEdit())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("알림"), message: Text("정보를 올바르게 입력해주세요"), dismissButton: .default(Text("확인")))
        }
    }
    
    var body: some View {
        return VStack(alignment: HorizontalAlignment.leading) {  paymentPicker
            titleField
            priceField
            payerPicker
            relatedMultiPicker
            categoryPicker
            timePicker
            memoField
            
            editingExpenditureButton
        }
        .navigationBarTitle("개인지출 추가")
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
    
    func relatedOnSelected(userId: String) {
        expenditureItem.related.append(userId)
    }
    
    func relatedOnDeselected(userId: String) {
        if expenditureItem.related.contains(userId),
            let index = expenditureItem.related.firstIndex(of: userId) {
            expenditureItem.related.remove(at: index)
        }
    }
    
    func canEdit() -> Bool {
        if expenditureItem.title.isEmpty || priceString.isEmpty || expenditureItem.related.isEmpty {
            return false
        }
        return true
    }

    
    func verifyToEditExpenditure() {
        guard let price = Int(priceString) else {
            self.showingAlert = true
            return
        }
        
        expenditureItem.price = price
        expenditureItem.time = Date.invertTimeToString(with: time)
        
        if let tripIndex = userData.trips.firstIndex(of: tripData),
            let dateIndex = userData.trips[tripIndex].sharedDateList.firstIndex(of: dateItem) {
            userData.trips[tripIndex].sharedDateList[dateIndex].expenditureList[expenditureIndex] = expenditureItem
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct SharedEditExpenditureView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let exampleItem = userData.trips[0].sharedDateList[0].expenditureList[0]
        return SharedEditExpenditureView(tripData: userData.trips[0], dateItem: userData.trips[0].sharedDateList[0], expenditureIndex: 0, expenditureItem: exampleItem, priceString: String(exampleItem.price), time: Date.invertToTime(with: exampleItem.time))
    }
}
