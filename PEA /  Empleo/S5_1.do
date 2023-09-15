
cls
clear all

cd "D:\BASES\ENAHO\2022"
use "enaho01a-2022-500.dta",clear

*comentario
* Filtración MTPE
* Un filtro que realiza la busqueda de personas que viven en el hogar
*se trabaja con las sigueintes variables
d p204 p205 p206 ocu500
d fac500a

drop if  fac500a==. 
drop if p501==.a | p501==. 
g corr=1 if  (p204==1 & p205==2) | (p204==2 & p206==1) 
keep if  corr==1

*Tasa de participacion 
*help tab 
tab ocu500 [iw=fac500a]

* Situacion de PEA
tab ocu500 [iw=fac500a] if ocu500<3

cd "C:\Users\edinsontolentino\Dropbox\Docencia\UPN\Analisis_Coyuntura_Economica\S5\Data"
tabout ocu500  if ocu500<3 using "T1.xls" if ocu500<3, c(freq col) clab(Frq Part) format(2) replace

*Tasa de participacion segun genero
tab ocu500 p207 [iw=fac500a] if ocu500<3
tab ocu500 p207 [iw=fac500a] if ocu500<3, col nofreq

tabout ocu500 p207 using "T2.xls" if ocu500<3, c(freq ) clab(Frq Part) format(2) replace


