//
//  MovieData.swift
//  MovieRankng
//
//  Created by Heeoh Son on 2023/05/18.
//

import Foundation

// MARK: MOVIE STRUCT
struct Movie: Codable, Identifiable {
    var id = UUID()
    let title: String
    let voteAvg : Double
    let popularity : Double
    let posterPath : String
    
    var posterImgUrl: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!
    }
    var popularityAsInt : Int {
        return Int(popularity)
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case voteAvg = "vote_average"
        case popularity
        case posterPath = "poster_path"
    }
    
    /// Movie Struct에 대한 예제 케이스를 만들어줌
    static func getDummy() -> Self {
        return Movie(title: "Guardians of the Galaxy Vol. 3", voteAvg: 8.2, popularity: 2137.214, posterPath: "/r2J02Z2OpNTctfOSN1Ydgii51I3.jpg")
    }
}

// MARK: POPULAR MOVIE LIST RESPONSE
struct PopularMovieListResponse: Codable {
    var results: [Movie]
}
