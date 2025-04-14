//
//  FakeApi.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/14/25.
//

import Foundation
@testable import SLAPUI
import Testing

class FakeApi: Api {
    
    var overrideWrapper: AnimalWrapper?
    var overrideAnimal: Animal?
    
    let defaultWrapper: AnimalWrapper = {
        let listJson = try! Data.jsonData(forFilePrefix: "animals.publishable")
        let wrapper = try! JSONDecoder().decode(AnimalWrapper.self, from: listJson)
        return wrapper
    }()
    
    let defaultAnimal: Animal = {
        let singleJson = try! Data.jsonData(forFilePrefix: "animal")
        let animal = try! JSONDecoder().decode(Animal.self, from: singleJson)
        return animal
    }()
    
    override func refreshPublishableAnimals() async throws -> AnimalWrapper {
        overrideWrapper ?? defaultWrapper
    }
    
    override func refreshAnimal(withInternalId internalId: String) async throws -> Animal {
        overrideAnimal ?? defaultAnimal
    }
}

extension Api {
    
    static func fake(config: Config = FakeConfig()) -> FakeApi {
        FakeApi(config: config)
    }
    
}
