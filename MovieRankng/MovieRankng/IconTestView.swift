//
//  IconTestView.swift
//  MovieRankng
//
//  Created by Heeoh Son on 2023/06/23.
//

import SwiftUI

struct IconContentView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 9, height: 20)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 3.12)
                        .stroke(Color.white, lineWidth: 2.25)
                )
                .padding(EdgeInsets(top: 22, leading: 17, bottom: 0, trailing: 0))
        }.background(.yellow)
    }
}

struct IconContentView_Previews : PreviewProvider {
    static var previews: some View {
        IconContentView()
    }
}
