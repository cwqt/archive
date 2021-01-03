const fs = require('fs');
const readline = require('readline');
var sleep = require('sleep'); 

function getOpCodes(){
  var text = fs.readFileSync('input.txt','utf8');
  var opcodes = text.split(",");
  for (var i=0; i<opcodes.length; i++) {
    opcodes[i] = Number(opcodes[i])
  }
  return opcodes
}

function runSimulation(noun, verb) {
  var program = getOpCodes();
  var i = 0;  //instruction pointer
  program[1] = noun;
  program[2] = verb;

  do {
    var r = 0;
    var x = program[i+1]; //address
    var y = program[i+2]; //address
    var z = program[i+3]; //output
    var a = program[x];   //parameter
    var b = program[y];   //parameter

    if(program[i] == 1) {
      r = a + b;
      program[z] = r;
      i += 4;
      continue;
    }

    if(program[i] == 2) {
      r = a * b;
      program[z] = r;
      i += 4;
      continue;
    }
  } while(program[i] != 99);

  return program[0];
}

function execute() {
  for(var i=0; i<99; i++) {
    for(var j=0; j<99; j++) {
      console.log(i, j)
      result = runSimulation(i, j);
      if(result == 19690720) {
        return 100 * i + j;
      }
    }
  } 
}

console.log(execute())