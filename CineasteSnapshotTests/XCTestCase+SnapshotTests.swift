// swiftlint:disable:this file_name
//
//  XCTestCase+SnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 01.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import SnapshotTesting

/// Asserts that a given value matches a reference on disk.
/// This overload makes two snapshots with "Light" and "Dark" user interface style.
///
/// - Parameters:
///
///   - themes: An array of UIUserInterfaceStyle you want to test.
///   - value: A value to compare against a reference.
///   - name: An optional description of the snapshot.
///   - recording: Whether or not to record a new reference.
///   - timeout: The amount of time a snapshot must be generated in.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
func assertViewSnapshot(
    for themes: [UIUserInterfaceStyle] = [.light, .dark],
    matching value: UINavigationController,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
    ) {

    for theme in themes {
        value.overrideUserInterfaceStyle = theme

        assertSnapshot(
            matching: value,
            as: .image(precision: 0.99),
            named: theme.displayName,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
    }
}

private extension UIUserInterfaceStyle {
    var displayName: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        default:
            return ""
        }
    }
}
