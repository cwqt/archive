export enum TokenType {
    Illegal     = "",

    If          = "if",
    Then        = "?",
    Else        = ":",
    Set         = "set",
    Goto        = "goto",
    Break       = "break",
    Iterate     = "itr",
    True        = "true",
    False       = "false",

    //literals
    Number      = "number",
    String      = "string",

    //device
    States      = "states",
    Sensors     = "sensors",
    Metrics     = "metrics",
    Routines    = "routines",

    Gt = ">",
    Lt = "<" ,
    Gte = ">=",
    Lte = "<=",
    NotEq = "!=",
    Eq = "==",
    
    Get = "->",
    Variable = "var",

    And = "&&",
    Not = "!",
    Or = "||",
}

enum Context {
    States      = "states",
    Sensors     = "sensors",
    Metrics     = "metrics",
    Device      = "device",
    
}

interface Token {
    kind: TokenType,
    val:string,
    len: number
}


const lex = (source:string):string[] =>  {
    let v = source.toLocaleLowerCase()
        .split(/('.*?'|".*?"|\S+)/g)
        .map(s => s.trim())
        .filter(s => s.length);

    let hasNoGets = false;
    while(!hasNoGets) {
        for(let i=0; i<v.length; i++) {
            let s = v[i];
            if(!s.match(/"[^"\\]*(?:\\[\s\S][^"\\]*)*"/g)) {
                if(s.includes(TokenType.Get) && s !== TokenType.Get) {
                    let lhs = v.slice(0, i);
                    let rhs = v.slice(i+1, v.length - 1);
                    v = [...lhs, ...s.split(/(->)/), ...rhs];
                    break;
                }
            }
            if(i == v.length - 1) hasNoGets = true;
        }    
    }


    return v;
}

const parse = (literals:string[]):Token[] => {
    let tokens:Token[] = [];

    for(let i=0; i<literals.length; i++) {
        let literal = literals[i];
        let type = TokenType.Illegal;

        switch(literal) {
            case TokenType.If:          type = TokenType.If; break;
            case TokenType.Then:        type = TokenType.Then; break;
            case TokenType.Else:        type = TokenType.Else; break;
            case TokenType.Set:         type = TokenType.Set; break;
            case TokenType.Goto:        type = TokenType.Goto; break;
            case TokenType.Break:       type = TokenType.Break; break;
            case TokenType.Iterate:     type = TokenType.Iterate; break;
            case TokenType.True:        type = TokenType.True; break;
            case TokenType.False:       type = TokenType.False; break;
            case TokenType.States:      type = TokenType.States; break;
            case TokenType.Sensors:     type = TokenType.Sensors; break;
            case TokenType.Metrics:     type = TokenType.Metrics; break;
            case TokenType.Routines:    type = TokenType.Routines; break;
            case TokenType.Gt:          type = TokenType.Gt; break;
            case TokenType.Lt:          type = TokenType.Lt; break;
            case TokenType.Gte:         type = TokenType.Gte; break;
            case TokenType.Lte:         type = TokenType.Lte; break;
            case TokenType.NotEq:       type = TokenType.NotEq; break;
            case TokenType.Eq:          type = TokenType.Eq; break;
            case TokenType.Get:         type = TokenType.Get; break;
            case TokenType.And:         type = TokenType.And; break;
            case TokenType.Not:         type = TokenType.Not; break;
            case TokenType.Or:          type = TokenType.Or; break;
        }

        if(literal.match(/\d+/g)) type = TokenType.Number;
        if(literal.match(/"[^"\\]*(?:\\[\s\S][^"\\]*)*"/g)) type = TokenType.String;

        if(tokens[i-1]?.kind == TokenType.Get) {
            type = TokenType.Variable
        }
        
        tokens.push({
            kind: type,
            val: literal,
            len: literal.length    
        } as Token);

    }
    
    return tokens;
}


const source = `
set states->screen_value "long string here"
if metrics->voltage_level > 200 ? goto routines->a : break
itr 5 set states->light_state !states->light_state
`

console.log(parse(lex(source)))

const getData = (ctx:Context, key:string) => {


}


// // program is an array of tasks
// let program:string[] = [
//     "set states->pump_state true",
//     "itr 2 wait 30",
//     "set states->pump_state false",
//     "if measurements->light_level <= 200 ? goto routines.a5ec990fa9c5043e74f21a497 : set states->light_state false"
// ]

// const lex = (program:string):string[] => {
// }

// const Op = Symbol('op');
// const Num = Symbol('num');
// const Bool = Symbol('bool');

// const parse = (tokens:string[]) => {
//     let c = 0;
//     const peek = () => tokens[c];
//     const consume = () => tokens[c++];
  
//     const parseBool = () => ({ val: consume() == "TRUE" ? true : (consume() == "FALSE" ? false : true), type: Bool})
//     const parseNum = () => ({ val: parseInt(consume()), type: Num });
//     const parseOp = () => {
//       const node = { val: consume(), type: Op, expr: [] };
//       while (peek()) node.expr.push(parseExpr());
//       return node;
//     };
  
//     const parseExpr = () => {
//         let v = peek();
//         console.log(v)
//         if(v == "TRUE" || v == "FALSE") return parseBool();
//         if(/\d/.test(v)) return parseNum();    
//         if(["SET" = "IF" = "THEN" = "ELSE" = "TRIGGER" = "END"].includes(v)) return parseOp();
//         return 'deez nuts'
//         // throw new Error(`Unrecognised token: ${v}`);
//     }

//     return parseExpr();
// }

// const compile = (x:any):string => {
//     return x;
// }

// eval(compile(parse(lex(program[0]))));