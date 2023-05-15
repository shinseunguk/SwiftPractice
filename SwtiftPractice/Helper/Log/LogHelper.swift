//
//  LogHelper.swift
//  SwtiftPractice
//
//  Created by ukBook on 2023/05/12.
//

internal func traceLog(_ description: Any,
           fileName: String = #file,
           lineNumber: Int = #line,
           functionName: String = #function) {

    // swiftlint:disable:next line_length
    let traceString = "\(fileName.components(separatedBy: "/").last!) -> \(functionName) -> \(description) (line: \(lineNumber))"
    print(traceString)
}
