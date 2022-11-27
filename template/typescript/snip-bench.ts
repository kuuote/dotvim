const bench = (fn: () => unknown) => {
  const t = Date.now();
  let c = 0;
  while (Date.now() - t < 100) {
    fn();
    c += 1;
  }
  console.log(c);
}
