//
//  Label.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class Label: UILabel {
    func setup() {
        fatalError("Override this method in your subclass")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
}

class DescriptionLabel: Label {
    override func setup() {
        font = UIFont.preferredFont(forTextStyle: .body)
        textColor = UIColor.cineDescription
        adjustsFontForContentSizeCategory = true
    }
}

class TitleLabel: Label {
    override func setup() {
        font = UIFont.preferredFont(forTextStyle: .headline)
        textColor = UIColor.cineTitle
        adjustsFontForContentSizeCategory = true
    }
}

class Title1CondensedLabel: Label {
    override func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setCondensedTitle1SymbolicTrait),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )

        setCondensedTitle1SymbolicTrait()

        textColor = UIColor.cineTitle
    }
}

class Title2CondensedLabel: Label {
    override func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setCondensedTitle2SymbolicTrait),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )

        setCondensedTitle2SymbolicTrait()

        textColor = UIColor.cineTitle
    }
}

class SubheadlineItalicLabel: Label {
    override func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setItalicSymbolicTrait),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )

        setItalicSymbolicTrait()

        textColor = UIColor.cineTitle
    }
}

class FootnoteLabel: Label {
    override func setup() {
        font = UIFont.preferredFont(forTextStyle: .caption1)
        textColor = UIColor.cineDescription
        adjustsFontForContentSizeCategory = true
    }
}

extension Label {
    @objc
    func setCondensedTitle2SymbolicTrait() {
        font = UIFont.preferredFont(forTextStyle: .title2).condensed()
    }

    @objc
    func setCondensedTitle1SymbolicTrait() {
        font = UIFont.preferredFont(forTextStyle: .title1).condensed()
    }

    @objc
    func setItalicSymbolicTrait() {
        font = UIFont.preferredFont(forTextStyle: .subheadline).italic()
    }
}
