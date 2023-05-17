//
//  MovieListViewModel.swift
//  MovieRankng
//
//  Created by Heeoh Son on 2023/05/18.
//

import Foundation
import Alamofire
import Combine

class MovieListViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    @Published var popularMovieList = [Movie]()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let baseUrl = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&sort_by=popularity.desc"
    private let apiKey = "9b02b1c2555be89455d4c4a6207aa37f"
    private var apiUrl: String

    // MARK: FUNCTIONS
    
    init() {
        print("Movie card view model init")
        apiUrl = baseUrl + "&page=1" + "&api_key=\(apiKey)"
        print("fetch movie list from \(apiUrl)")
        fetchPopularMovieList()
    }

    /// apiUrl 로부터 데이터를 가져와 popularMovieList에 저장
    func fetchPopularMovieList() {
        print("start to fetch....")
        AF.request(apiUrl)
            .publishDecodable(type: PopularMovieListResponse.self)
            .compactMap{ $0.value }
            .map{ $0.results }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("fetch success")
                case .failure(let error):
                    print("fetch faild: \(error)")
                }
            }, receiveValue: { receivedValue in
                print("received")
                self.popularMovieList = receivedValue
            }).store(in: &cancellables)
    }
}
