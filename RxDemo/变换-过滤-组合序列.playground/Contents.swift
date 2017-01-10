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


//Mark: - 组合序列

//startWith 在一个序前插入一个值
_ = sequenceInt
    .startWith(-1)
    .startWith(-2)
    .subscribe { print("startWith", $0)}

//combineLatest
//当两个序列中的任何一个发射了数据时，combineLatest 会结合并整理每个序列发射的最近数据项。
let intOb1 = PublishSubject<String>()
let intOb2 = PublishSubject<Int>()
let intOb3 = PublishSubject<Int>()
_ = Observable.combineLatest(intOb1, intOb2) {
    "(\($0) \($1))"
    }
    .subscribe { print("combineLatest", $0) }

intOb1.onNext("A")
intOb2.onNext(1)
intOb1.onNext("B")
intOb2.onNext(2)

let intOb4 = Observable.just(2)
let intOb5 = Observable.of(0, 1, 2, 3)
let intOb6 = Observable.of(0, 1, 2, 3, 4)

_ = Observable.combineLatest(intOb4, intOb5, intOb6) {
    "\($0) \($1) \($2)"
    }
    .subscribe {
        print("combineLatest2", $0)
}

let intOb7 = Observable.just(2)
let intOb8 = ReplaySubject<Int>.create(bufferSize: 1)
intOb8.onNext(0)
let intOb9 = Observable.of(0, 1, 2, 3)
intOb8.onNext(1)

_ = Observable.combineLatest(intOb7, intOb8, intOb9,resultSelector: {
    "\($0) \($1) \($2)"
    }).subscribe{ print("combineLatest3", $0) }
intOb8.onNext(2)
intOb8.onNext(3)

Observable.combineLatest([intOb4, intOb5, intOb6]) {
        "\($0[0]) \($0[1]) \($0[2])"
    }.subscribe { (event) -> Void in
        print(event)
}

//??????
let stringObservable = Observable.just("❤️")
let fruitObservable = Observable.from(["🍎", "🍐", "🍊"])
let animalObservable = Observable.of("🐶", "🐱", "🐭", "🐹")

Observable.combineLatest([stringObservable, fruitObservable, animalObservable]) {
    "\($0[0]) \($0[1]) \($0[2])"
    }
    .subscribe(onNext: { print($0) })
    .addDisposableTo(disposeBag)

//zip
//zip 和 combineLatest 相似，不同的是每当所有序列都发射一个值时， zip 才会发送一个值。它会等待每一个序列发射值，发射次数由最短序列决定。结合的值都是一一对应的。
let intOb11 = PublishSubject<String>()
let intOb12 = PublishSubject<Int>()
_ = Observable.zip(intOb11, intOb12) {
    "(\($0) \($1))"
    }
    .subscribe {
        print("zip1", $0)
}

intOb11.onNext("A")
intOb12.onNext(1)
intOb11.onNext("B")
intOb11.onNext("C")
intOb12.onNext(2)

let intOb10 = Observable.of(0, 1)

_ = Observable.zip(intOb10, intOb5, intOb6) {
    ($0 + $1) * $2
    }
    .subscribe {
        print("zip2", $0)
}

//merge
//merge 会将多个序列合并成一个序列，序列发射的值按先后顺序合并。要注意的是 merge 操作的是序列，也就是说序列发射序列才可以使用 merge
let subject1 = PublishSubject<Int>()
let subject2 = PublishSubject<Int>()

_ = Observable.of(subject1, subject2)
    .merge()
    .subscribe {
        print("merge1", $0)
}

//merge 可以传递一个 maxConcurrent 的参数，你可以通过传入指定的值说明你想 merge 的最大序列。直接调用 merge() 会 merge 所有序列。你可以试试将这个 merge 2 的例子中的 maxConcurrent 改为 1 ，可以看到 subject2 发射的值都没有被合并进来。
_ = Observable.of(subject1, subject2)
    .merge(maxConcurrent: 1)
    .subscribe {
        print("merge2", $0)
}
subject1.onNext(20)
subject1.onNext(40)
subject1.onNext(60)
subject2.onNext(1)
subject1.onNext(80)
subject1.onNext(100)
subject2.onNext(1)


//switchLatest
//switchLatest 和 merge 有一点相似，都是用来合并序列的。然而这个合并并非真的是合并序列。事实是每当发射一个新的序列时，丢弃上一个发射的序列。
let var1 = Variable(0)

let var2 = Variable(200)

// var3 是一个 Observable<Observable<Int>>
let var3 = Variable(var1.asObservable())

let d = var3
    .asObservable()
    .switchLatest()
    .subscribe {
        print("switchLatest", $0)
}

var1.value = 1
var1.value = 2
var1.value = 3
var1.value = 4

var3.value = var2.asObservable() // 我们在这里新发射了一个序列

var2.value = 201

var1.value = 5 // var1 发射的值都会被忽略
var1.value = 6
var1.value = 7

