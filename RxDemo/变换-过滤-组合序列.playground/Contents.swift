//: Playground - noun: a place where people can play

import RxSwift

var str = "Hello, playground"

let disposeBag = DisposeBag()


//Mark:- 变换序列

//map
//map 就是用你指定的方法去变换每一个值，这里非常类似 Swift 中的 map ，特别是对 SequenceType 的操作，几乎就是一个道理。一个一个的改变里面的值，并返回一个新的 functor 。
let originalSequence = Observable.of(1, 2, 3, 4)
originalSequence
    .map { $0 * 2 }
//    { number in
//        number * 2
//    }
    .subscribe { print("map", $0) }
    .addDisposableTo(disposeBag)
//Note:
//这里的 map 和 SenquenceType 的 map 不是同一个 map ，如果发射的值是一个 array ，你可能需要这样修改 map { $0.map { $0 * 2 } }

//mapWithIndex
//mapWithIndex  这是一个和 map 一起的操作，唯一的不同就是我们有了 index ，注意第一个是序列发射的值，第二个是 index
originalSequence
    .mapWithIndex { $0 * $1 }
//    { number, index in
//        number * index
//    }
    .subscribe { print("mapWithIndex", $0) }
    .addDisposableTo(disposeBag)

//flapMap
//flapMap 将一个序列发射的值转换成序列，然后将他们压平到一个序列。这也类似于 SequenceType 中的 flatMap
let sequenceInt = Observable.of(1, 2, 4)
let sequenceString = Observable.of("A", "B", "C", "D", "E", "F", "--")
sequenceInt
    .flatMap { (x: Int) -> Observable<String> in
        print("from sequenceInt \(x)")
        return sequenceString
    }
    .subscribe {
        print("flapMap", $0)
    }
    .addDisposableTo(disposeBag)




