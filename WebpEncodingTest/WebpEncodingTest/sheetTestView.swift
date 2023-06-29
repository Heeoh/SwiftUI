//
//  sheetTestView.swift
//  WebpEncodingTest
//
//  Created by Heeoh Son on 2023/06/18.
//

import Foundation
import SwiftUI

struct sheetTestView: View {
    @State private var isPresented = false
    
    var body: some View {
        Button("Show Sheet") {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            SheetView(completion: {
                isPresented = false
            })
        }
    }
}

struct SheetView: View {
    let completion: () -> Void
    
    var body: some View {
        VStack {
            Text("Sheet Content")
            Button("Complete") {
                performAsyncTask {
                    completion()
                }
            }
        }
    }
    
    func performAsyncTask(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            // 비동기 작업 수행
            // ...
            
            // 작업이 완료되면 completion 호출
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

struct sheetTestView_Previews : PreviewProvider {
    static var previews: some View {
        sheetTestView()
    }
}
