const fs = require('fs');
const readline = require('readline');

async function getLinesInInput(){
  return new Promise((resolve, reject) => {
    var lines = [];
    var lineReader = readline.createInterface({
      input: fs.createReadStream("input.txt")
    });

    lineReader.on('line', function(line) {
      lines.push(line);
    });

    lineReader.on('close', function(line) {
      resolve(lines)
    });
  })
}

(async () => {
  var lines = await getLinesInInput();
  var sum = 0;

  lines.forEach(line => {
    console.log(line)
    var localSum = 0;

    recurse = (v) => {
      v = Math.floor(v / 3) - 2
      if (v > 0) {
        localSum += v;
        recurse(v)
      }
      return localSum;
    }

    sum += recurse(Number(line));
  })

  console.log("\n"+sum);
})();
