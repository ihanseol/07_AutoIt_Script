자동화 파일을 2가지로 해봤습니다.

1. AHK_One.ahk : 1개의 화일로 통합한 파일 (함수도 본파일에 포함)
2. MyAHK.ahk    : 관련 함수는 lib/MyFunction.ahk에 정의

 ※ 만약 크롬을 사용하려면 lib폴더에 Chrome폴더 있어야.....


※ 이미지 클릭(!2)에 대하여
  - 듀얼모니터도 이미지 클릭이 가능하도록 포함하였음.
    · 그래도 듀얼모니터 안될때 : Dual_img_coordinate() 값수정 필요
  
  - 만약 그래도 안되면.... 아래와 같이 하거나(*30 값 수정)
    · 당초 : Img_Dir := A_ScriptDir "\pic\" F_name 
    · 변경 : Img_Dir := "*30 " A_ScriptDir "\pic\" F_name

  - 다른 이미지(보다 선명한) 또는 특징나타내는 최소한의 부분만 캡쳐 등

  성공하시길 바랍니다. 