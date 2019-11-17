//
//  Store.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

#if DEBUG
var store = Store(
    reducer: appReducer,
    state: nil
)
#else
let store = Store(
    reducer: appReducer,
    state: nil
)
#endif
