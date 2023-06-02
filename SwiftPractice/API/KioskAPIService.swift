//
//  KioskAPIService.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/30.
//

import Foundation
import RxSwift
import Alamofire

class KioskAPIService {
    
    let URL = "https://firebasestorage.googleapis.com/v0/b/rxswiftin4hours.appspot.com/o/fried_menus.json?alt=media&token=42d5cb7e-8ec4-48f9-bf39-3049e796c936"
    
    func getUsers() -> Observable<[MenuItem]> {
        struct response : Codable {
            let menus : [MenuItem]
        }
        
        return Observable.create { observer in
            AF.request(self.URL)
                .validate()
                .responseDecodable(of: response.self) { response in
                    switch response.result {
                    case .success(let menu):
//                        dump(menu.menus)
                        observer.onNext(menu.menus)
                        observer.onCompleted()
                    case .failure(let error):
                        tLog("")
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
