import UIKit
import RxSwift

class NewsTableViewController: UITableViewController {
    
    private var articleListViewModel: ArticleListViewModel?
    private let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        populateNews()
    }
    
    private func populateNews(){
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=2bdaa5281f784c4fa9ef7d8b43e22f9b"
        )!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleRespones in
                let articles = articleRespones.articles
                self.articleListViewModel = ArticleListViewModel(articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            })
            .disposed(by: disposebag)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articleListViewModel = articleListViewModel else {
            return 0
        }
        
        return articleListViewModel.articlesViewModel.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as?
                ArticleTableViewCell else {
            fatalError("ArticleTableViewCell is not found")
        }
        
        let cellData = self.articleListViewModel?.articleAt(indexPath.row)
        
        cellData?.title
            .asDriver(onErrorJustReturn: "no title found")
            .drive(onNext: { titleText in
                cell.titleLabel.text = titleText
            })
            .disposed(by: disposebag)
        
        cellData?.description
            .asDriver(onErrorJustReturn: "no description found")
            .drive(onNext: { descText in
                cell.descriptionLabel.text = descText
            })
            .disposed(by: disposebag)

        return cell
    }
}
