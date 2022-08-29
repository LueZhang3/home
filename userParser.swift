//
//  userParser.swift
//  UserInfoConverter
//
//  Created by Luyang Zhang on 8/22/22.
//

import Foundation

struct UserInfo : Decodable {
    let name : String
    let birthday : String
    let year : Int
    let month : Int
    let day : Int
    let timeZone : String
    let hour : Int
    let minute : Int
    let latitude : Double
    let longtitude : Double
}

struct PairCombo : Decodable {
    let BaseUser : UserInfo
    let Married : UserInfo
    let Dated : UserInfo
    let Stranger : UserInfo
}

struct UserData : Decodable {
    let results : [PairCombo]
}

func formatUserData(userData : UserInfo) -> Array<Any>{
    let calendar = Calendar(identifier: .gregorian)
    var userDateCOmponent = DateComponents()
    userDateCOmponent.year = userData.year
    userDateCOmponent.month = userData.month
    userDateCOmponent.day = userData.day
    userDateCOmponent.timeZone = TimeZone(abbreviation: userData.timeZone)
    userDateCOmponent.hour = userData.hour
    userDateCOmponent.minute = userData.minute
    let birthDay = calendar.date(from: userDateCOmponent)
    return [birthDay,userData.latitude,userData.longtitude]
}

func getUserData() -> Array<Any>{
    let path = "/Users/luyang_zhang/Desktop/UserInfoConverter/UserInfoConverter/users.json"
    var testingResults : [Any] = []
    do {
        let contents = try String(contentsOfFile: path, encoding: .utf8)
        let jsonData = contents.data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let userData: UserData = try! decoder.decode(UserData.self, from: jsonData)
        let results = userData.results
        
        for result in results {
            let baseUser = formatUserData(userData: result.BaseUser)
            let married = formatUserData(userData: result.Married)
            let dated = formatUserData(userData: result.Dated)
            let stranger = formatUserData(userData: result.Stranger)
            
            testingResults.append([baseUser,married])
            testingResults.append([baseUser,dated])
            testingResults.append([baseUser,stranger])
        }
        
    }
    catch let error as NSError {
        print("Ooops! Something went wrong: \(error)")
    }
    
    print(testingResults)
    return testingResults
}

