//: Playground - noun: a place where people can play

import RxSwift

var str = "Hello, playground"

let disposeBag = DisposeBag()

/*
我们可以把 Subject 当作一个桥梁（或者说是代理）， Subject 既是 Observable 也是 Observer 。
    
作为一个 Observer ，它可以订阅序列。
同时作为一个 Observable ，它可以转发或者发射数据。
在这里， Subject 还有一个特别的功能，就是将冷序列变成热序列，订阅后重新发送嘛。
 */

//PublishSubject 只发射给观察者订阅后的数据
let publishSubject = PublishSubject<String>()
publishSubject.subscribe { e in
    print("PublishSubject Subscription: 1, event:\(e)")
}.addDisposableTo(disposeBag)

publishSubject.onNext("a")
publishSubject.onNext("b")

publishSubject.subscribe { e in
    print("PublishSubject Subscription: 2, event:\(e)")
}.addDisposableTo(disposeBag)

publishSubject.onNext("c")
publishSubject.onNext("d")

//ReplaySubject 不论观察者什么时候订阅 ReplaySubject都会发射完整的数据给观察者
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
replaySubject.subscribe { e in
    print("ReplaySubject Subscription: 1, event:\(e)")
}.addDisposableTo(disposeBag)

replaySubject.onNext("a")
replaySubject.onNext("b")

replaySubject.subscribe { e in
    print("ReplaySubject Subscription: 2, event:\(e)")
}
replaySubject.onNext("c")
replaySubject.onNext("d")

//BehaviorSubject 当一个观察者订阅一个 BehaviorSubject ，它会发送原序列最近的那个值（如果原序列还有没发射值那就用一个默认值代替），之后继续发射原序列的值。
let behaviorSubject = BehaviorSubject(value: "z")
behaviorSubject.subscribe { e in
    print("BehaviorSubject Subscription:1, event: \(e)")
}.addDisposableTo(disposeBag)
behaviorSubject.onNext("a")
behaviorSubject.onNext("b")

behaviorSubject.subscribe { e in
    print("BehaviorSubject Subscription:2, event: \(e)")
}.addDisposableTo(disposeBag)
behaviorSubject.onNext("c")
behaviorSubject.onNext("d")
behaviorSubject.onCompleted()

//Variable  是 BehaviorSubject 的一个封装。相比 BehaviorSubject ，它不会因为错误终止也不会正常终止，是一个无限序列。
let variable = Variable("z")
variable.asObservable().subscribe { e in
    print("Variable Subscription:1, event: \(e)")
}.addDisposableTo(disposeBag)

variable.value = "a"
variable.value = "b"

variable.asObservable().subscribe { e in
    print("Variable Subscription:1, event: \(e)")
}.addDisposableTo(disposeBag)

variable.value = "c"
variable.value = "d"

let elements = Variable<[String]>([])
elements.value = ["a", "b"]
print(elements.value)



