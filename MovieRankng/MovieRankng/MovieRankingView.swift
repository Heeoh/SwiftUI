//
//  MovieRankingView.swift
//  MovieRankng
//
//  Created by Heeoh Son on 2023/05/18.
//

import Foundation
import SwiftUI

struct BoxOfficeRankingView: View {
    
    // MARK: PROPERTIES
    @ObservedObject var movieListViewModel = MovieListViewModel()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            // movie list, 3 columns grid format
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(Array(movieListViewModel.popularMovieList.enumerated()), id: \.offset) { index, aMovie in
                            MovieCardView(aMovie, index + 1, (geometry.size.width - 20) / 3 - 6)
                                .padding(.horizontal, 3)
                        }
                    }.padding(10)
                }
            }
            // navigation bar
            .navigationBarTitle(Text("Movie Ranking"))
            .navigationBarItems(
                trailing: NavigationLink ( destination: LoginView() ) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            )
        }
    }
}

// MARK: PREVIEW
struct BoxOfficeRankingView_Preview: PreviewProvider {
    static var previews: some View {
        BoxOfficeRankingView()
    }
}
