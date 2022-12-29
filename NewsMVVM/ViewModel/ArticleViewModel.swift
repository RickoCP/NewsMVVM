//
//  ArticleViewModel.swift
//  NewsMVVM
//
//  Created by ricko caesar putra on 23/12/22.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticleListViewModel {
    let articlesViewModel: [ArticleViewModel]
}

extension ArticleListViewModel {
    init(_ articles: [Article]) {
        self.articlesViewModel = articles.compactMap(ArticleViewModel.init)
    }
}

extension ArticleListViewModel {
    func articleAt(_ index: Int) -> ArticleViewModel {
        return self.articlesViewModel[index]
    }
}

struct ArticleViewModel {
    let article: Article
    
    init(_ article: Article){
        self.article = article
    }
}

extension ArticleViewModel {
    var title: Observable<String> {
        return Observable<String>.just(article.title)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(article.description ?? "")
    }
}
