#!/usr/bin/swift

import Foundation

// Debug
//print("hello!")

if let folderPath = ProcessInfo.processInfo.environment["SRCROOT"] {
    // Debug
    //print(folderPath)
    var results:[String] = [] // isLoggedIn が使われているファイル一覧
// Debug
//    let testPath:String = "\(folderPath)/SearchTestFile/ContentView.swift"
//    print(searchIsLoggedInString(testPath: testPath))
    
    // プロジェクト内のswiftファイルを探す。
    let filePaths = FileManager.default.enumerator(atPath: "\(folderPath)/SearchTestFile")?.allObjects as! [String]
    let swiftFilePaths = filePaths.filter{$0.contains(".swift")}
    for swiftFile in swiftFilePaths {
        // Debug
        //print(swiftFileName)
        var swiftFileName = (swiftFile as NSString).lastPathComponent
        // .swift を削除する。
        let result = swiftFileName.range(of: ".swift")
        if let theRange = result {
            swiftFileName.removeSubrange(theRange)
        }
        // 未ログイン確認処理が実装されているファイルを集める。
        if searchIsLoggedInString(testPath: "\(folderPath)/SearchTestFile/\(swiftFile)") {
            results.append(swiftFileName)
        }
    }

    // プロジェクト内のTestsファイルを探す。
    let testsFilePaths = FileManager.default.enumerator(atPath: "\(folderPath)/SearchTestFileTests")?.allObjects as! [String]
    let swiftTestFiles:[String] = testsFilePaths.filter{$0.contains(".swift")}
        .reduce(into: []) { partialResult, element in
            var swiftFileName = (element as NSString).lastPathComponent
            // Tests.swift を削除する場合。
            let result = swiftFileName.range(of: "Tests.swift")
            if let theRange = result {
                swiftFileName.removeSubrange(theRange)
            }
            partialResult.append(swiftFileName)
        }
// Debug
//    for swiftTestFileName in swiftTestFiles {
//        print(swiftTestFileName)
//    }
    // 未ログイン実装のあるファイル一覧とテストファイル一覧を照らし合わせる。
    for fileName in results {
        // Debug
        //print(fileName)
        if !swiftTestFiles.contains(fileName) {
            fatalError("‼️\(fileName).swift はisLoggedInの実装がありますが、テストファイルが作成されていません。確認してください。‼️")
        }
    }
    print("✅Success isLoggedInの実装のあるファイルは:\(results.count)件です。 TestFile all created!!")
} else {
    print("[Script Error] failed srcroot path")
}

func searchIsLoggedInString(testPath: String) -> Bool {
    var result: Bool = false
    do {
        let dataRaw = try NSString(contentsOfFile: testPath, encoding: String.Encoding.utf8.rawValue)
        let data = dataRaw as String
        data.enumerateLines { (line, stop) -> () in
            //print(line)
            if let _ = line.range(of: "isLoggedIn") {
                //print(range)
                result = true
                stop = true
            } else {
                result = false
            }
        }
    } catch {
        print("[Script Error] failed NSString")
    }
    return result
}
