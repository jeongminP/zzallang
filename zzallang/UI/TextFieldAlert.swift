//
//  TextFieldAlert.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/30.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct TextFieldAlert: View {
    var title: String = "Enter Input"
    @Binding var text: String
    var onDone: () -> Void

    var body: some View {

        VStack(alignment: .center) {
            Spacer()
            
            Text(title).font(.headline)
                .padding()

            TextField("제목을 입력하세요", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 300)
                .padding()
//            Divider()
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: {
                        self.onDone()
                    })
                }) {
                    Text("확인")
                        .bold()
                }
                    .padding()
                Spacer()

//                Divider()
//
//                Spacer()
//                Button(action: {
//                    UIApplication.shared.windows[0].rootViewController?.dismiss(animated: true, completion: {})
//                }) {
//                    Text("Cancel")
//                }
//                Spacer()
            }.padding(0)

            Spacer()
            }//.background(Color(white: 0.9))
    }
}

struct TextFieldAlert_Previews: PreviewProvider {
    @State static var example = UserData().trips[0].sharedDateList[0].dailyTitle
    static var previews: some View {
        return TextFieldAlert(text: $example, onDone: {})
            .frame(width: 300, height: 200)
    }
}
