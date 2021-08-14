function* map<T,U>(iter: Iterable<T>, fn: (value: T) => U): Generator<U> {
  for(const v of iter) {
    yield fn(v);
  }
}

function* filter<T, S extends T>(iter: Iterable<T>, predicate: (value: T) => value is S): Generator<S> {
  for(const v of iter) {
    if(predicate(v)) {
      yield v;
    }
  }
}

export class Iter<T> {
  iter: Iterable<T>
  constructor(iter: Iterable<T>) {
    this.iter = iter;
  }

  collect(): T[] {
    return Array.from(this.iter);
  }

  collectSorted(sorter?: (a: T, b: T) => number) {
    return Array.from(this.iter).sort(sorter);
  }

  filter<S extends T>(predicate: (value: T) => value is S) {
    return new Iter(filter(this.iter, predicate));
  }

  map<U>(fn: (value: T) => U): Iter<U> {
    return new Iter(map(this.iter, fn));
  }
}
