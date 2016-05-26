const redis = require("redis")
const mysql = require("mysql")
const AWS = require("aws-sdk")

function main() {
  console.log("About to create redis client")
  const client = redis.createClient()

  client.on("error", function (err) {
      console.log("Redis Error " + err)
  })

  client.set("string key", "string val", redis.print)
  client.hset("hash key", "hashtest 1", "some value", redis.print)
  client.hset(["hash key", "hashtest 2", "some other value"], redis.print)
  client.hkeys("hash key", function (err, replies) {
    console.log(replies.length + " replies:")
    replies.forEach(function (reply, i) {
        console.log("    " + i + ": " + reply)
    })
    client.quit()
  })
  console.log("Redis worked, maybe")

  console.log("About to test DynamoDB")

  const ddb = new AWS.DynamoDB()

  var params = {
      TableName: "sb2-users",
      Key: {
          "userId":  {S: "UCX7qjhMCbPU"}
      }
  }

  ddb.getItem(params, (err, result) => {
    if (err) console.log(err)

    console.log(result)
  })

  console.log("DynamoDB worked, maybe")

  let n = 0
  function loop() {
    setTimeout(() => {
      console.log('main',n++)
      loop()
    },5000)
  }
  loop()
  console.log('started')
}

main()
