const fs = require('fs');
const readline = require('readline-sync');
var sleep = require('sleep'); 

function getOpCodes(){
	var text = fs.readFileSync('input.txt','utf8');
	return text
}

function getOpcode(value) {
	var v = value.toString().split("").reverse()
	if (v[0] == 9) {return 99}
	return v[0];
}

function runSimulation(programme) {
	var program = programme.split(",");
	for (var i=0; i<program.length; i++) {
		program[i] = Number(program[i])
	}

	var i = 0;  //instruction pointer
	var e = true;

	while(e) {
		var r = 0;

		var x = program[i+1]; //address
		var y = program[i+2]; //address
		var z = program[i+3]; //output

		var a = program[x];		//parameter
		var b = program[y];		//parameter

		//0 = position mode
		//1 = immediate mode
		if (program[i].toString().length > 1) {
			m = program[i].toString().split("").reverse()
			if (m[2] == 1) { a = x }
			if (m[3] == 1) { b = y }
			if (m[4] == 1) { z = i+3 }
		}

		var step = null;

		var opcodes = []
		opcodes[1] = function() {//add
			r = Number(a) + Number(b);
			program[z] = r;
		}
		opcodes[2] = function() {//multiply
			r = Number(a) * Number(b);
			program[z] = r;
		}
		opcodes[3] = function() {//save value
			var v = Number(readline.question("Enter input: "));
			program[x] = v;
			step = 2;
		}
		opcodes[4] = function() {//output input
			console.log("-->", a);
			step = 2;
		}
		opcodes[5] = function() {//jump if true
			if(a != 0) {
				i = b;
				step = 0;
			} else {
				step = 3;
			}
		}
		opcodes[6] = function() {//jump if false
			if(a == 0) {
				i = b;
				step = 0;
			} else {
				step = 3;
			}
		}
		opcodes[7] = function() {//less than
			if(a < b) {
				program[z] = 1;
			} else {
				program[z] = 0; 
			}
		}
		opcodes[8] = function() {//equals
			if(a == b) {
				program[z] = 1;
			} else {
				program[z] = 0; 
			}
		}
		opcodes[99] = function() {
			e = false;
		}
		// sleep.msleep(100)
		// console.log(i, program, program[i])
		opcodes[getOpcode(program[i])]();
		
		if (step == null) {
			i += 4
		} else {
			i += step;
		}
	};
	return program[0];
}
// runSimulation("3,9,8,9,10,9,4,9,99,-1,8")
// runSimulation("3,9,7,9,10,9,4,9,99,-1,8")
// runSimulation("3,3,1108,-1,8,3,4,3,99")
// runSimulation("3,3,1107,-1,8,3,4,3,99")

// runSimulation("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9")
// runSimulation("3,3,1105,-1,9,1101,0,0,12,4,12,99,1")

// runSimulation("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99")
runSimulation(getOpCodes())