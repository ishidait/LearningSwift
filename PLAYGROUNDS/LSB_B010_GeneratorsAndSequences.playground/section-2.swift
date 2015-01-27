import UIKit

/*
//  Generators and Sequences
//
//  Suggested Reading:
//  http://www.objc.io/books/ (Chapter 11, Generators and Sequences)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


// First, we'll take a look at a standard Fibonacci function.
// Then, we'll use this to generate a FibonacciGenerator.


/*------------------------------------/
//  Fibonacci Number Sequence
//
//  For: n
//  0, 1, 2, 3, 4, 5,  6,  7
//
//  Fibonacci is:
//  1, 1, 2, 3, 5, 8, 13, 21
/------------------------------------*/
// Fibonacci
func fib(n: Int) -> Int {
  switch n {
  case 0, 1:
    return 1
  default:
    return fib(n-2) + fib(n-1)
  }
}

fib(0)
fib(1)
fib(2)
fib(5) // = 3 +  5
fib(7) // = 8 + 13


/*------------------------------------/
//  Generators
/------------------------------------*/
// Fibonnaci Generator:
class FibonnaciGenerator: GeneratorType {
  typealias Element = Int
  
  var currentIndex: Int
  
  init(startIndex: Int) {
    currentIndex = startIndex
  }
  
  func next() -> Element? {
    if currentIndex < 0 { return nil }
    return fib(currentIndex++)
  }
}


// Iterate over first five elements
var fibGenerator = FibonnaciGenerator(startIndex: 0)
var fibs = [Int]()
for var i=0; i<5; i++ {
  if let nextFib = fibGenerator.next() {
    fibs.append(nextFib)
  }
}
fibs


// Do this again, using `reduce`
fibGenerator = FibonnaciGenerator(startIndex: 0)
Array(1...5).reduce([Int]()) { acc, _ in
  if let nextFib = fibGenerator.next() {
    return acc + [nextFib]
  }
  return acc
}


/*------------------------------------/
//  Faster Fibonacci Generators
/------------------------------------*/
// The older generator will slow down as n gets larger.

// Faster Fibonnaci Generator:
class MemoizedFibonnaciGenerator: GeneratorType {
  typealias Element = Int
  
  var memo: (last: Element?, lastLast: Element?)
  var currentIndex: Int
  
  init(startIndex: Int) {
    currentIndex = startIndex
  }
  
  func next() -> Element? {
    if currentIndex < 0 { return nil }
    
    let calcFib = {
      (self.memo.last ?? fib(self.currentIndex-1)) + (self.memo.lastLast ?? fib(self.currentIndex-2))
    }
    let nextFib = currentIndex < 2 ? 1 : calcFib()
    
    memo = (last: nextFib, lastLast: memo.last)
    currentIndex++
    return nextFib
  }
}


// Iterate over first five elements
var memoFibGenerator = MemoizedFibonnaciGenerator(startIndex: 0)
fibs = [Int]()
for var i=0; i<5; i++ {
  if let nextFib = memoFibGenerator.next() {
    fibs.append(nextFib)
  }
}
fibs


// Do this again, using `reduce`
memoFibGenerator = MemoizedFibonnaciGenerator(startIndex: 3)
fibs = Array(1...5).reduce([]) { acc, _ in
  if let nextFib = memoFibGenerator.next() {
    return acc + [nextFib]
  }
  return acc
}


/*------------------------------------/
//  Find a Fib
/------------------------------------*/
func findFib(predicate: Int -> Bool) -> Int? {
  let g = MemoizedFibonnaciGenerator(startIndex: 0)
  while let x = g.next() {
    if predicate(x) { return x }
  }
  return nil
}

let bigFib = findFib { $0 > 20 }
bigFib!


/*------------------------------------/
//  Sequences
/------------------------------------*/


