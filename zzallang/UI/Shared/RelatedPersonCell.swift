//
//  RelatedPersonCell.swift
//  zzallang
//
//  Created by 박정민 on 2020/01/30.
//  Copyright © 2020 박정민. All rights reserved.
//

import SwiftUI

struct RelatedPersonCell: View {
    @State var isSelected = false
    
    var userId: String
    var onSelected: () -> Void
    var onDeselected: () -> Void
    
    var body: some View {
        Button(action: {
            self.onClicked()
        }) {
            Text(userId)
                .padding(.horizontal)
                .frame(maxHeight: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(Color.orange, lineWidth: 7)
                )
                .background(isSelected ? Color.orange : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .circular))
                .foregroundColor(isSelected ? Color.white : Color.black)
        }
    }
    
    func onClicked() {
        self.isSelected = !self.isSelected
        if isSelected == true {
            onSelected()
        } else {
            onDeselected()
        }
    }
}

struct RelatedPersonCell_Previews: PreviewProvider {
    static var previews: some View {
        RelatedPersonCell(userId: "chunbae", onSelected: {}, onDeselected: {})
    }
}
