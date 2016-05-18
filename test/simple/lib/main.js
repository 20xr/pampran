function main() {
  function loop() {
    setTimeout(() => {
      process.stdout.write('.')
      loop()
    },1000)
  }
  loop()
  process.stdout.write('started')
}

main()
