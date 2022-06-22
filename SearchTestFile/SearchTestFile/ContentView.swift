//
//  ContentView.swift
//  SearchTestFile
//
//  Created by 武田孝騎 on 2022/06/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear(perform: {
                checkFile()
            })
    }
}

func checkFile() {
    let path = Bundle.main.path(forResource: "isLoggedIn", ofType: "swift")
    let result: Bool = (path != nil)
    print("path \(String(describing: path)) result \(result)")
    //NSString(contentsOfFile: <#T##String#>, encoding: String.Encoding.utf8.rawValue)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
