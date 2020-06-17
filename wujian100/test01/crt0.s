.text

.global __start
__start:
  li  x11,0x2001fff0
  li  x10,0x38  #打印8
  sw  x10,0(x11)
  li  x10,0x0a  #换行
  sw  x10,0(x11)
  li  x10,0x0d  #回车
  sw  x10,0(x11)
__simEnd:
  li  x11, 0x20007c50 
  li  x10, 0x2002 #sim结束
  sw  x10, 0(x11)
  jal __simEnd
  
