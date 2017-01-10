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
let sequenceInt = Observable.of(6, 2, 4)
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

//scan
//应用一个 accumulator (累加) 的方法遍历一个序列，然后返回累加的结果。此外我们还需要一个初始的累加值。实时上这个操作就类似于 Swift 中的 reduce
let sequenceToSum = Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8)
sequenceToSum
    .scan(0) { $0 + $1 }
    .subscribe {
        print("scan", $0)
    }.addDisposableTo(disposeBag)

//reduce
//和 scan 非常相似，唯一的不同是， reduce 会在序列结束时才发射最终的累加值。就是说，最终只发射一个最终累加值。
sequenceToSum
    .reduce(0) { $0 + $1 }
    .subscribe {
        print("reduce", $0)
    }.addDisposableTo(disposeBag)

//buffer
//在特定的线程，定期定量收集序列发射的值，然后发射这些的值的集合。
sequenceToSum
    .buffer(timeSpan: 5, count: 3, scheduler: MainScheduler.instance)
    .subscribe { print("buffer", $0) }
    .addDisposableTo(disposeBag)

//window
//window 和 buffer 非常类似。唯一的不同就是 window 发射的是序列， buffer 发射一系列值。
sequenceToSum
    .window(timeSpan: 5, count: 3, scheduler: MainScheduler.instance)
    .subscribe {
        print("window", $0)
    }.addDisposableTo(disposeBag)


//Mark:- 过滤序列

//FILTER
//filter 应该是最常用的一种过滤操作了。传入一个返回 bool 的闭包决定是否去掉这个值。
sequenceToSum
    .filter { $0 % 2 == 0 }
    .subscribe{ print("filter", $0) }
    .addDisposableTo(disposeBag)

//DISTINCTUNTILCHANGED
//distinctUntilChanged 阻止发射与上一个重复的值。
Observable.of(1, 2, 2, 1, 1, 4)
    .distinctUntilChanged()
    .subscribe { print("distinctUntilChanged", $0) }
    .addDisposableTo(disposeBag)

//TAKE
//take 只发射指定数量的值。
Observable.of(1, 2, 4, 4, 5, 6)
    .take(3)
    .subscribe {
        print("take", $0)
    }
    .addDisposableTo(disposeBag)

//TAKELAST
//takeLast 只发射序列结尾指定数量的值。
//这里要注意，使用 takeLast 时，序列一定是有序序列，takeLast 需要序列结束时才能知道最后几个是哪几个值。所以 takeLast 会等序列结束才向后发射值。如果你需要舍弃前面的某些值，你需要的是 skip
    Observable.of(1, 2, 9, 5, 6)
        .takeLast(3)
        .subscribe {
            print("takeLast", $0)
        }
        .addDisposableTo(disposeBag)

//SKIP
//skip 忽略指定数量的值。

Observable.of(1, 2, 4, 4, 5, 6)
    .skip(3)
    .subscribe {
        print("skip", $0)
    }
    .addDisposableTo(disposeBag)

//DEBOUNCE / THROTTLE
//debounce 仅在过了一段指定的时间还没发射数据时才发射一个数据，换句话说就是 debounce 会抑制发射过快的值。注意这一操作需要指定一个线程。来看下面这个例子。
Observable.of(1, 2, 3, 4, 5, 6)
    .debounce(1, scheduler: MainScheduler.instance)
    .subscribe {
        print("debounce", $0)
    }
    .addDisposableTo(disposeBag)

//ELEMENTAT
//使用 elementAt 就只会发射一个值了，也就是指发射序列指定位置的值，比如 elementAt(2) 就是只发射第二个值。
sequenceToSum
    .elementAt(2)
    .subscribe {
        print("elementAt", $0)
    }

//SINGLE
//single 就类似于 take(1) 操作，不同的是 single 可以抛出两种异常： RxError.MoreThanOneElement 和 RxError.NoElements 。当序列发射多于一个值时，就会抛出 RxError.MoreThanOneElement ；当序列没有值发射就结束时， single 会抛出 RxError.NoElements 。
sequenceToSum
    .single()
    .subscribe {
        print("singe", $0)
    }


//SAMPLE
//sample 就是抽样操作，按照 sample 中传入的序列发射情况进行抽样
//如果源数据没有再发射值，抽样序列就不发射，也就是说不会重复抽样。
Observable<Int>.interval(0.1, scheduler: SerialDispatchQueueScheduler(qos: .background))
    .take(100)
    .sample(Observable<Int>.interval(1, scheduler:         SerialDispatchQueueScheduler(qos: .background)))
        .subscribe {
            print("sample", $0)
    }.addDisposableTo(disposeBag)


