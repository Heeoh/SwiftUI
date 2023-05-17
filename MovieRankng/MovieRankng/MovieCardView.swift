//
//  MovieCardView.swift
//  MovieRankng
//
//  Created by Heeoh Son on 2023/05/18.
//

import Foundation
import SwiftUI

struct MovieCardView: View {
    // MARK: PROPERTIES
    var movie: Movie
    var movieRank: Int
    var cardViewWidth: CGFloat
    
    init (_ movie: Movie, _ rank: Int, _ cardViewWidth: CGFloat) {
        self.movie = movie
        self.movieRank = rank
        self.cardViewWidth = cardViewWidth
    }

    // MARK: BODY
    var body: some View {
        VStack {
            // movie poster
            moviePosterWithRank
            
            // movie title
            Text(movie.title)
                .font(.system(size: 17, weight: .medium))
                .frame(width: cardViewWidth, height: 5)
            
            // movie popularity
            Text("\(movie.popularityAsInt) 명")
                .foregroundColor(.gray)
                .font(.system(size: 17, weight: .regular))
        }
    }
    
    /// asyncMoviePosterImg는 URL로부터 이미지를 비동기적으로 가져와 알맞은 형태로 보여줍니다
    var asyncMoviePosterImg: some View {
        AsyncImage(url: movie.posterImgUrl) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: cardViewWidth)
                .cornerRadius(15)
        } placeholder: {
            Text("loading ...")
                .frame(width: cardViewWidth, height: 150)
        }

    }
    
    /// moviePosterWithRanking은 url에서 가져온 영화 포스터 이미지를 보여줍니다.
    /// 포스터 이미지 위로 해당 영화의 랭킹을 겹쳐 함께 보여줍니다
    var moviePosterWithRank: some View {
        ZStack (alignment: .bottomLeading){
            asyncMoviePosterImg
            Rectangle()
                .fill(LinearGradient(colors: [.black.opacity(0), .black.opacity(0.3)], startPoint: .top, endPoint: .center))
                .frame(height: 50)
                .cornerRadius(15)
            Text("\(movieRank)")
                .font(.system(size: 30, weight: .bold))
                .italic()
                .foregroundColor(.white)
                .offset(x: 12, y: 6)
        }
    }
    
}

// MARK: PREVIEW
struct MovieCardView_Preview: PreviewProvider {
    static var previews: some View {
        MovieCardView(Movie.getDummy(), 1, 130)
    }
}
