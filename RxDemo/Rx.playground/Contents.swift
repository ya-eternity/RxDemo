//: Playground - noun: a place where people can play

import RxSwift

var str = "Hello, playground"

//create 用闭包的方式创建序列
let myJust = { (singleElement: Int) -> Observable<Int> in
    return Observable.create { observer in
        observer.onNext(singleElement)
        observer.onCompleted()
        return Disposables.create()
    }
}

_ = myJust(5)
    .subscribe { event in
        print("create", event)
    }

//deferred 只有在观察者订阅时，才去创建序列
let deferredSequence: Observable<Int> = Observable.deferred {
    print("deferred creating")
    return Observable.create { observer in
        print("deferred emmiting")
        observer.onNext(0)
        observer.onNext(1)
        observer.onNext(2)
        return Disposables.create()
    }
}

_ = deferredSequence
    .subscribe { event in
        print("deferred", event)
}

/*
 _ = deferredSequence
    .subscribe { event in
        print(event)
}
 */

//empty 只创建一个空序列 只发射一个.Completed
let emptySequence = Observable<Int>.empty()

_ = emptySequence
    .subscribe { event in
        print("empty", event)
}

//error 创建一个发射error的终止序列
let error = NSError(domain: "Test", code: -1, userInfo: nil)
let errorSequence = Observable<Int>.error(error)
_ = errorSequence
    .subscribe { event in
        print("error", event)
}

//from（由toObservable转变） 使用Sequence创建序列
let sequenceFromArray = Observable.from([1, 2, 3, 4, 5])
_ = sequenceFromArray
    .subscribe { event in
        print("from", event)
}

//interval 创建一个每隔一段时间就发射的递增序列
let intervalSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//while true {
//    sleep(1)
    _ = intervalSequence.subscribe { event in
        //没打印过？？？
        print("interval", event)
    }
    
//}
//never 不创建序列，也不发送通知
let neverSequence = Observable<Int>.never()

_ = neverSequence.subscribe { event in
    print("永远不会执行")
}

//just 只创建包含一个元素的序列，只发送一个值和 .Completed
let singleElementSequence = Observable.just(32)
_ = singleElementSequence.subscribe { event in
    print("just", event)
}

//of 通过一组元素创建一个序列
let sequenceofElements = Observable.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
_ = sequenceofElements.subscribe { event in
    print("of", event);
}

//range 创建一个有范围的序列
let rangeSequence = Observable.range(start: 0, count: 4)
_ = rangeSequence.subscribe { event in
    print("range", event)
}

//repeatElement 创建一个发射重复值得序列
//let repeatElementSequence = Observable.repeatElement(1)
//_ = repeatElementSequence.subscribe { event in
//    print("repeat", event)
//}


//#warning 
//timer 创建一个带延迟的序列
let timerSequence = Observable<Int>.timer(1, period: 1, scheduler: MainScheduler.instance)
    _ = timerSequence.subscribe { event in
        print("timer", event)
    }
    


