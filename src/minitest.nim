# minitest
# Copyright xmonader
# minitest framework

import strformat, strutils


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






when isMainModule:
  check(3==1+2)
  check(6+5*2 == 16)