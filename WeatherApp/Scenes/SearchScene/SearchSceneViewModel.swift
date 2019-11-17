//
//  SearchSceneViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol SearchSceneViewModel: SceneViewModel {
    var itemsIsLoaded: (() -> Void)? { get set }
    var items: [SearchTableCellViewModel] { get }
    
    func search(with cityName: String)
    func getDetailsModel(for index: Int) -> CityWeatherViewModel
}

class SearchViewModel: SearchSceneViewModel {
    private var networkManager: NetworkManager?
    private var currentResponseList: [WeatherDetailedList] = []
    
    var itemsIsLoaded: (() -> Void)?
    var networkProblemClosure: ((Error) -> Void)?
    
    var items: [SearchTableCellViewModel] = [] {
        didSet {
            itemsIsLoaded?()
        }
    }
    
    init(networkManager: NetworkManager = AlamofireNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getDetailsModel(for index: Int) -> CityWeatherViewModel {
        return CityWeatherViewModel(from: currentResponseList[index])
    }
    
    func search(with cityName: String) {
        let target = WeatherTarget.search(name: cityName)
        networkManager?.request(target, of: SearchResponseModel.self) { [weak self] result in
            switch result {
            case .success(let searchResultModel):
                self?.updateItems(with: searchResultModel.list)
            case .failure(let error):
                self?.networkProblemClosure?(error)
            }
        }
    }
    
    private func updateItems(with list: [WeatherDetailedList]?) {
        guard let list = list else {
            items = []
            return
        }
        
        currentResponseList = list
        items = list.map { SearchTableCellViewModel(from: $0) }
    }
    
}
