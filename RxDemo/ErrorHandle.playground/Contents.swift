//: Playground - noun: a place where people can play

import RxSwift

playgroundShouldContinueIndefinitely()

var str = "Hello, playground"


//Mark: - 错误处理

//retry
//retry 就是失败了再尝试，重新订阅一次序列
var count = 1
let funnyLookingSequence = Observable<Int>.create { observer in
    let error = NSError(domain: "Test", code: 0, userInfo: nil)
    observer.onNext(0)
    observer.onNext(1)
    observer.onNext(2)
    if count < 2 {
        observer.onError(error)
        count += 1
    }
    observer.onNext(3)
    observer.onNext(4)
    observer.onNext(5)
    observer.onCompleted()
    return Disposables.create()
}

_ = funnyLookingSequence
    .retry()
    .subscribe {
        print("retry", $0)
    }

//不难发现这里的 retry 会出现数据重复的情况，我推荐 retry 只用在会发射一个值的序列（可能发射 Error 的序列）中。
//Note:需要注意的是不加参数的 retry 会无限尝试下去。我们还可以传递一个 Int 值，来说明最多尝试几次。像这样 retry(2) ，最多尝试两次。


//catchError
//当出现 Error 时，用一个新的序列替换。

let sequenceThatFails = PublishSubject<Int>()
let recoverySquence = Observable.of(100, 200, 300, 400)
_ = sequenceThatFails
    .catchError { error in
        return recoverySquence
    }
    .subscribe { print("catchError", $0) }

sequenceThatFails.onNext(1)
sequenceThatFails.onNext(2)
sequenceThatFails.onNext(3)
sequenceThatFails.onError(NSError(domain: "Test", code: 0, userInfo: nil))
sequenceThatFails.onNext(4)

//CATCHERRORJUSTRETURN
//这个就很好理解了，就是遇到错误，返回一个值替换这个错误。
let sequenceFail2 = PublishSubject<Int>()
_ = sequenceFail2
    .catchErrorJustReturn(100)
    .subscribe { print("catchErrorJustReturn", $0) }
sequenceFail2.onNext(1)
sequenceFail2.onNext(2)
sequenceFail2.onNext(3)
sequenceFail2.onError(NSError(domain: "Test", code: 0, userInfo: nil))
sequenceFail2.onNext(4)

//error 之后的值不会再被发射


typealias VoidClosure = (Int) -> Void
var int = VoidClosure?() { _ = $0 }
var a: VoidClosure?


//Mark: - 其他操作符
//subscribe  操作序列的发射物和通知
let sequenceOfInts = PublishSubject<Int>()
_ = sequenceOfInts
    .subscribe {
        print("subscribe", $0)
    }
sequenceOfInts.onNext(1)
sequenceOfInts.onCompleted()

//SUBSCRIBENEXT
//subscribeNext 只订阅 Next 事件。
let sequenceOfInts2 = PublishSubject<Int>()
_ = sequenceOfInts2
    .subscribe(onNext: { (i) in
        print("subscribeNext", i)
    })
sequenceOfInts2.onNext(1)
sequenceOfInts2.onCompleted()

//SUBSCRIBECOMPLETED
//subscribeCompleted 只订阅 Completed 事件。
let sequenceOfInts3 = PublishSubject<Int>()
_ = sequenceOfInts3
    .subscribe(onCompleted: { 
        print("subscribeCompleted")
    })
sequenceOfInts3.onNext(1)
sequenceOfInts3.onCompleted()

//SUBSCRIBEERROR
//subscribeError 只订阅 Error 事件。
let sequenceOfInts4 = PublishSubject<Int>()
_ = sequenceOfInts4
    .subscribe(onError: { (error) in
        print("subscribeError", error)
    })
sequenceOfInts4.onNext(1)
sequenceOfInts4.onError(NSError(domain: "Examples", code: -1, userInfo: nil))


//DOON -> do
//注册一个动作作为原始序列生命周期事件的占位符。
let sequence1 = PublishSubject<Int>()
_ = sequence1
    .do {
        print("Intercepted event \($0)")
    }
    .subscribe {
        print("Doon", $0)
    }
sequence1.onNext(1)
sequence1.onCompleted()
//sequence1.onError(NSError(domain: "Examples", code: -1, userInfo: nil))



//条件和布尔操作
//TAKEUNTIL
//takeUntil 当另一个序列开始发射值时，忽略原序列发射的值。
let originalSequence = PublishSubject<Int>()
let whenThisSendsNextWorldStops = PublishSubject<Int>()
_ = originalSequence
    .takeUntil(whenThisSendsNextWorldStops)
    .subscribe {
        print("takeUntil", $0)
    }

originalSequence.onNext(1)
originalSequence.onNext(2)
originalSequence.onNext(3)

whenThisSendsNextWorldStops.onNext(1)
originalSequence.onNext(4)

//TAKEWHILE
//根据一个状态判断是否继续向下发射值。这其实类似于 filter 。需要注意的就是 filter 和 takeWhile 什么时候更能清晰表达你的意思，就用哪个。
let sequence = PublishSubject<Int>()

_ = sequence
    .takeWhile { $0 < 4 }
    .subscribe {
        print("takeWhile", $0)
}

sequence.onNext(1)
sequence.onNext(2)
sequence.onNext(4)
sequence.onNext(2)

//AMB
//amb 用来处理发射序列的操作，不同的是， amb 选择先发射值的序列，自此以后都只关注这个先发射序列，抛弃其他所有序列。
let intSequence1 = PublishSubject<Int>()
let intSequence2 = PublishSubject<Int>()
let intSequence3 = PublishSubject<Int>()
_ = Observable.amb([intSequence1, intSequence2, intSequence3]
    .map { $0.asObservable() })
    .subscribe {
        print("amb1", $0)
    }
intSequence2.onNext(10)
intSequence1.onNext(1)
intSequence3.onNext(100)
intSequence1.onNext(2)
intSequence3.onNext(200)
intSequence2.onNext(20)

//let intSequence3 = PublishSubject<Int>()
//let intSequence24 = PublishSubject<Int>()

let _ = intSequence1.amb(intSequence3).subscribe { // 只用于比较两个序列
    print("amb2", $0)
}

intSequence1.onNext(1) // intSequence1 最先发射
intSequence3.onNext(10)
intSequence1.onNext(2)
intSequence3.onNext(20)



//计算和聚合操作
//CONCAT
//串行的合并多个序列
let var1 = BehaviorSubject(value: 0)
let var2 = BehaviorSubject(value: 200)

// var3 is like an Observable<Observable<Int>>
let var3 = Variable(var1)

_ = var3.asObservable()
    .concat()
    .subscribe {
        print("concat", $0)
}

var1.onNext(1)
var1.onNext(2)
var1.onNext(3)
var1.onNext(4)

var3.value = var2

var2.onNext(201)

var1.onNext(5)
var1.onNext(6)
var1.onNext(7)
var1.onCompleted()

var2.onNext(202)
var2.onNext(203)
var2.onNext(204)
var2.onCompleted()

//var3.onCompleted()

//let disposeBag = DisposeBag()
//
//let subject1 = BehaviorSubject(value: "🍎")
//let subject2 = BehaviorSubject(value: "🐶")
//
//let variable = Variable(subject1)
//
//variable.asObservable()
//    .concat()
//    .subscribe { print($0) }
//    .addDisposableTo(disposeBag)
//
//subject1.onNext("🍐")
//subject1.onNext("🍊")
//
//variable.value = subject2
////subject1.onCompleted()
//subject2.onNext("I would be ignored")
//subject2.onNext("🐱")
//
//subject1.onCompleted()
//
//subject2.onNext("🐭")


//REDUCE
//和 Swift 的 reduce 差不多。只是要记得它和 scan 一样不仅仅只是用来求和什么的。注意和 scan 不同 reduce 只发射一次，真的就和 Swift 的 reduce 相似。还有一个 toArray 的便捷操作
_ = Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
    .reduce(0, accumulator: +)
    .subscribe {
        print("reduce", $0)
}


//Mark: - 连接操作
//可连接的序列和一般的序列基本是一样的，不同的就是你可以用可连接序列调整序列发射的实际。只有当你调用 connect 方法时，序列才会发射。
func sampleWithoutConnectableOperators() {
    print("--- sampleWithoutConnectableOperators sample ---")
    let int1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    _ = int1.subscribe {
        print("subscription: 1 \($0)")
    }
    
    delay(5) {
        _ = int1.subscribe {
             print("subscription: 2 \($0)")
        }
    }
}

//sampleWithoutConnectableOperators()

//MULTICAST
// multcast 使用起来有些麻烦，不过也更强大，传入一个 Subject ，每当序列发射值时都会传入这个 Subject
func sampleWithMulticast() {
    print("--- sampleWithMulticast sample ---")
    let subject1 = PublishSubject<Int64>()
    _ = subject1.subscribe {
        print("multcat subject \($0)")
    }
    
    let interval1 = Observable<Int64>.interval(1, scheduler: MainScheduler.instance)
        .multicast(subject1)
    
    _ = interval1.subscribe {
        print("multcat subscription: 1 \($0)")
    }
    
    delay(2) {
       _ = interval1.connect()
    }
    
    
    delay(4) {
    _ = interval1
            .subscribe {
                print("multcat subscription: 2 \($0)")
        }
    }
    
    delay(6) {
        _ = interval1
            .subscribe {
                print("multcat subscription: 3 \($0)")
        }
    }
    
}

//sampleWithMulticast()

//REPLAY
//replay 这个操作可以让所有订阅者同一时间收到相同的值。
//就相当于 multicast 中传入了一个 ReplaySubject .
//publish = multicast + replay subject
func sampleWithReplayBuffer0() {
    print("--- sampleWithReplayBuffer0 sample ---")
    let interval1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .replay(2)
    
    _ = interval1
        .subscribe {
            print("replay subscription: 1 \($0)")
        }
    delay(2) {
        _ = interval1.connect()
    }
    
    
    delay(4) {
        _ = interval1
            .subscribe {
                print("replay subscription: 2 \($0)")
        }
    }
    
    delay(6) {
        _ = interval1
            .subscribe {
                print("replay subscription: 3 \($0)")
        }
    }
}

//sampleWithReplayBuffer0()

//PUBLISH
//其实这个和开始的 sampleWithMulticast 是一样的效果。
//publish = multicast + publish subject
func sampleWithPublish() {
    print("--- sampleWithPublish ---")
    let interval1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .publish()
    
    _ = interval1
        .subscribe {
            print("publish subscription: 1 \($0)")
    }
    delay(2) {
        _ = interval1.connect()
    }
    
    
    delay(4) {
        _ = interval1
            .subscribe {
                print("publish subscription: 2 \($0)")
        }
    }
    
    delay(6) {
        _ = interval1
            .subscribe {
                print("publish subscription: 3 \($0)")
        }
    }
}

//sampleWithPublish()

//REFCOUNT
//这个是一个可连接序列的操作符 它可以将一个可连接序列变成普通的序列


