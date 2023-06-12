//
//  MapView.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/24.
//

import SwiftUI
import PhotosUI

struct MapView: View {
    
    @StateObject var viewModel = GoogleMapViewModel()
    @State var showSheet = false
    @State var selectedImages: [ImageData] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    GoogleMapView(currentRegionCenterLocation: $viewModel.currentLocation, markers: $viewModel.markers, isMyLocationEnabled: viewModel.isShowCurrentLocation, mapType: viewModel.mapType) { location in
                        viewModel.getMarkerTap(location)
                    }
                    
                    currentLocationButton
//                    zoomButtons
                    
                    if !viewModel.selectedMarkerAddress.isEmpty {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text(viewModel.selectedMarkerAddress)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .frame(height: 50)
                            .background(.blue)
                            .cornerRadius(12)
                        }
                        .animation(.easeIn(duration: 0.5), value: !viewModel.selectedMarkerAddress.isEmpty)
                        .transition(.scale.combined(with: .move(edge: .bottom)))
                        .padding(.bottom, 70)
                        .padding(.horizontal, 16)
                    }
                }
                .onAppear(perform: {
                    viewModel.getCurrentLocation()
                    if !selectedImages.isEmpty {
                        for imageData in selectedImages {
                            print("imageData - location: \(imageData.location?.latitude), \(imageData.location?.longitude)")
                            if let image = imageData.image,
                               let location = imageData.location {
                                viewModel.markers.append(ImageMarker(location: location, image: image))
                            }
                        }
                    }
                })
            }
            .navigationTitle("Google Map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing:
                    VStack {
                        Button {
                            showSheet.toggle()
                        } label: {
                            Image(systemName: "photo")
                        }
                    }.sheet(isPresented: $showSheet) {
                        CustomPhotoPickerView(selectedImages: $selectedImages)
                    }
            )
        }
        
    }
    
    private var currentLocationButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    print ("currentLocationButton clicked")
                    viewModel.getCurrentLocation()
                } label: {
                    Image(systemName: "location.viewfinder")
                        .font(.system(size: 25))
                }
                .frame(width: 48, height: 48)
                .background(.white)
                .cornerRadius(8)
                
                .padding()
                
            }
        }
    }
    
    
}

struct GoogleMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
