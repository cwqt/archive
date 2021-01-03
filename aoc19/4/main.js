var lb = 138241;
var ub = 674034;
var possible = 0;

var prev = lb
for(var x=lb; x<=ub; x++) {
  var a = x.toString().split("");
  for(var z=0;z<a.length;z++) {a[z]=Number(a[z])};

  var repeat = false;
  var repeats = x.toString().match(/(.)\1*/g)
  repeats.forEach(r => {
    if(r.length == 2) {
      repeat = true;
    }
  })

  var match = true;
  for(var z=0; z<a.length; z++) {
    if(a[z]==0) {match = false}
    if(a[z+1]) {
      if(a[z] <= a[z+1] == false) {
        match = false;
      }
    }
  }

  if (repeat > 0 && match) {
    possible++;
  }
}

console.log(possible);