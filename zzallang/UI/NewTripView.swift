//
//  NewTripView.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/07.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct NewTripView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newTrip: TripData = TripData.makeNewTripData()
    
    @State private var startingDateObject: Date = Date()
    @State private var finishingDateObject: Date = Date()
    @State private var showingAlert = false
    
    private var newId: Int {
        if let lastId = userData.trips.last?.id {
            return lastId + 1
        }
        return 1001
    }
    
    var dateRange: ClosedRange<Date> {
        let startingDateObject = Date()
        let min = Calendar.current.date(byAdding: .year, value: -10, to: startingDateObject)!
        let max = Calendar.current.date(byAdding: .year, value: 10, to: startingDateObject)!
        return min...max
    }
    
    var makingNewTripButton: some View {
        Button(action: { self.verifyToMakeNewTrip() }) {
            Text("확인")
                .padding()
            }.disabled(!canMake())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("알림"), message: Text("일정을 올바르게 입력해주세요"), dismissButton: .default(Text("확인")))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("여행 이름").bold()
                        .padding(.trailing)
                        .padding(.vertical)
                    TextField("여행 이름", text: $newTrip.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("여행 시작일").bold()
                    DatePicker(
                        "여행 시작일",
                        selection: $startingDateObject,
                        in: dateRange,
                        displayedComponents: .date)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("여행 종료일").bold()
                    DatePicker(
                        "여행 종료일",
                        selection: $finishingDateObject,
                        in: dateRange,
                        displayedComponents: .date)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("화폐 단위").bold()
                    Picker("화폐 단위", selection: $newTrip.currency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                }
            }
            .padding(.leading)
            .navigationBarTitle("새 여행 만들기")
            .navigationBarItems(trailing: makingNewTripButton)
        }
    }
    
    func canMake() -> Bool {
        if newTrip.name.isEmpty {
            return false
        }
        return true
    }
    
    func verifyToMakeNewTrip() {
        newTrip.id = newId
        
        if startingDateObject > finishingDateObject {
            self.showingAlert = true
            return
        }
        
        newTrip.startingDate = Date.invertToString(with: startingDateObject)
        newTrip.finishingDate = Date.invertToString(with: finishingDateObject)
        
        userData.trips.append(newTrip)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewTripView_Previews: PreviewProvider {
    static var previews: some View {
        NewTripView().environmentObject(UserData())
    }
}
