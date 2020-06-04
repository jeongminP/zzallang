//
//  EditTripView.swift
//  zzallang
//
//  Created by 박정민 on 2020/02/01.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct EditTripView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.presentationMode) private var presentationMode
    
    var tripIndex: Int
    
    @State var tripData: TripData
    @State var startingDateObject: Date
    @State var finishingDateObject: Date
    
    @State private var showingAlert = false
    
    var dateRange: ClosedRange<Date> {
        let startingDateObject = Date()
        let min = Calendar.current.date(byAdding: .year, value: -10, to: startingDateObject)!
        let max = Calendar.current.date(byAdding: .year, value: 10, to: startingDateObject)!
        return min...max
    }
    
    var editingTripButton: some View {
        Button(action: { self.verifyToEditTrip() }) {
            Text("확인")
            }.disabled(!canEdit())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("알림"), message: Text("일정을 올바르게 입력해주세요"), dismissButton: .default(Text("확인")))
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                editingTripButton
                    .padding(.horizontal)
                    .padding(.top)
            }
            
            ScrollView {
                HStack {
                    Text("여행 이름").bold()
                        .padding()
                    TextField("여행 이름", text: $tripData.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing)
                }.padding(.horizontal)
                
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
                    Picker("화폐 단위", selection: $tripData.currency) {
                        ForEach(Currency.allCases, id: \.self) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .labelsHidden()
                }
            }
//            .padding(.leading)
//            .padding(.top)
//            .offset(y: 10.0)
        }
    }
    
    func canEdit() -> Bool {
        if tripData.name.isEmpty {
            return false
        }
        return true
    }
    
    func verifyToEditTrip() {
        if startingDateObject > finishingDateObject {
            self.showingAlert = true
            return
        }
        
        tripData.startingDate = Date.invertToString(with: startingDateObject)
        tripData.finishingDate = Date.invertToString(with: finishingDateObject)
        
        userData.trips[tripIndex] = tripData
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditTripView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let exampleData = userData.trips[0]
        return EditTripView(tripIndex: 0, tripData: exampleData, startingDateObject: Date.invertToDate(with: exampleData.startingDate), finishingDateObject: Date.invertToDate(with: exampleData.finishingDate))
    }
}
