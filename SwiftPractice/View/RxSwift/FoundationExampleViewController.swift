//
//  FoundationExampleViewController.swift
//  SwiftPractice
//
//  Created by ukseung.dev on 2023/05/31.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


final class FoundationExampleViewController: UIViewController, UIViewControllerAttribute {
    let disposeBag = DisposeBag()
    
    var navTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
        setAttributes()
        bindRx()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = navTitle ?? ""
    }
    
    func setUI() {
        self.view.backgroundColor = .white
    }
    
    func setAttributes() {
        
    }
    
    func bindRx() {
        
//        // just
//        Observable.just("1")
//            .subscribe(onNext: {
//                tLog($0)
//            })
//            .disposed(by: disposeBag)

//        --------------------------------------------------------
        
//        // from, filter
//        Observable.from([1, 2, 3])
//            .filter {
//                $0 > 1
//            }
//            .subscribe(onNext: {
//                tLog($0)
//            })
//            .disposed(by: disposeBag)

//        --------------------------------------------------------
        
//        // of
//        Observable.of(1, 2, 3).subscribe(onNext: { value in
//            print(value)
//        }, onCompleted: {
//            print("Completed")
//        })
//        .disposed(by: disposeBag)
        
//        --------------------------------------------------------

//        // interval(1초 주기로 값 방출)
//        Observable.interval(.seconds(1), scheduler: MainScheduler.instance)
//            .take(5)
//            .subscribe(onNext: { (value: Int) in
//                print("Value: \(value)")
//            })
//            .disposed(by: disposeBag)
        
//        --------------------------------------------------------
        
//        // timer(구독후 0초후에 1초 주기로 값 방출), map, filter 활용
//        Observable.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
//            .map { $0 + 5 }
//            .filter { $0 <= 10 }
//            .subscribe(onNext: { (value: Int) in
//                tLog("Timer fired with value: \((value))")
//            })
//            .disposed(by: disposeBag)

//        --------------------------------------------------------
        
//        // skip
//        Observable.from([1, 2, 3, 4, 5, 6])
//            .skip(2)
//            .subscribe(onNext: {
//                tLog($0)
//            })
//            .disposed(by: disposeBag)
        
//        --------------------------------------------------------
        
//        // empty
//        Observable.empty()
//            .subscribe(onNext: {
//                tLog($0)
//            })
//            .disposed(by: disposeBag)
        
//        --------------------------------------------------------
        
//        // range, toArray
//        Observable.range(start:3, count:6)
//            .toArray()
//            .subscribe(onSuccess: {
//                print($0)
//            })
//            .disposed(by: disposeBag)

//        --------------------------------------------------------
        
        // throttle, 특정시간 동안 이벤트 방출 제한
//        let button = UIButton(type: .system).then {
//            $0.setTitle("throttle", for: .normal)
//        }
//        self.view.addSubview(button)
//        button.snp.makeConstraints {
//            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(200)
//            $0.height.equalTo(40)
//        }
//
//        button.rx.tap
//            .throttle(.seconds(3), scheduler: MainScheduler.instance)
//            .subscribe(onNext: {
//                tLog("")
//            })
//            .disposed(by: disposeBag)
        
//        --------------------------------------------------------
        
        // debounce 특정시간 이후에 방출
        let tf = UITextField().then {
            $0.borderStyle = .roundedRect
        }
        self.view.addSubview(tf)
        tf.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
        
        tf.rx.text
            .filter{ $0 != nil && $0 != ""}
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                guard let a = $0 else {return}
                tLog(a)
            })
            .disposed(by: disposeBag)

//        --------------------------------------------------------
    }
}
