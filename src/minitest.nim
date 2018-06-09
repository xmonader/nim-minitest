# minitest
# Copyright xmonader
# minitest framework

import strformat, strutils, macros


template check*(exp:untyped, failureMsg:string="failed", indent:uint=0): void =
  let indentationStr = repeat(' ', indent) 
  let expStr: string = astToStr(exp)
  var msg: string
  if not exp:
    if msg.isNilOrEmpty():
      msg = indentationStr & expStr & " .. " & failureMsg
  else:
    msg = indentationStr & expStr & " .. passed"
      
  echo(msg)


# template suite*(exprs: untyped): void =
#   for i in 0..< exprs.len:
#     echo("expr: " & exprs[i])

macro suite*(exprs: untyped) : typed = 
# StmtList
#   Call
#     Ident ident"suiteName"
#     StrLit Arith
#   Call
#     Ident ident"check"
#     Infix
#       Ident ident"=="
#       Infix
#         Ident ident"+"
#         IntLit 1
#         IntLit 2
#       IntLit 3
  var result = newStmtList()
  for i in 0..<exprs.len:
    var exp = exprs[i].copy()
    let expKind = exp.kind
    case expKind
    of nnkStrLit:
      # suite name
      let equline = newCall("repeat", newStrLitNode("="), newIntLitNode(50))
      let writeEquline = newCall("echo", equline)
      add(result, writeEquline, newCall("echo", exp), writeEquline)
    of nnkCall:
      case exp[0].kind
      of nnkIdent:
        let identName = $exp[0].ident
        if identName == "check":
          var checkWithIndent = exp
          checkWithIndent.add(newStrLitNode(""))
          checkWithIndent.add(newIntLitNode(1))
          add(result, checkWithIndent)
      else:
        discard
    else:
      discard
        
  return result

when isMainModule:
  check(3==1+2)
  check(6+5*2 == 16)
  
  suite:
    "Arith"
    check(1+2==3)
    check(3+2==5)

  suite:
    "Strs"
    check("HELLO".toLowerAscii() == "hello")
    check("".isNilOrEmpty() == true)

  # dumpTree:
  #   "Arith"
  #   check(1+2==3)
  #   check(3+2==5)
  #   check(1==1, "", 1)