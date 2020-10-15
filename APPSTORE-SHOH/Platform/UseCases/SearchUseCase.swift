//
//  SearchUseCase.swift
//  APPSTORE-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import RxSwift

final class SearchUseCase {
    func search(_ term: String) -> Single<SearchModel> {
        let makeParam: [String: Any] = [
            "entity": "software",
            "country": "KR",
            "term": "\(term)"
        ]
        return NetworkManager.shared.request(SearchModel.self,
                                             urlString: APIDomain.search.url,
                                             parameters: makeParam)
            .do(onSuccess: { (_) in
                
                var list = UserdefaultsManager.getStringArray(.최신검색어히스토리())
                if !list.contains(term) {
                    list.append(term)
                    UserdefaultsManager.setValue(.최신검색어히스토리(list))
                }
            })
    }
}
