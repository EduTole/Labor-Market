rm(list=ls())
ruta   <- "D:/BASES/ENAHO"
base   <- "/2022"
codigo <- "/Codigo"
#out    <- "D:/BASES/ENAHO"

#install.packages("readstata13")
library(readstata13)
library(dplyr)
library(tidyverse)

#install.packages("survey")
library(survey)

# =====================================================================
# Part I: process information
# =====================================================================

data <- read.dta13(paste0(ruta,"/",base,"/","enaho01a-2022-500.dta"))
data %>%  names()

# Carga de funciones de codigos
source(paste0(ruta,codigo,"/","Funciones_MTPE.R"))

# Filtro de MTPE
data <- funcion_rfiltro(data)

# Filtro de MTPE
df <- data %>% 
  filter(rfiltro==1)

# transformando la variables:
# A. Variable de categoria ocupacional
enaho <- df %>% 
  mutate(catg_empleo = ifelse(ocu500==1, "Ocupado",
                              ifelse(ocu500==2,"Desempleo",
                                     ifelse(ocu500>2,"Inactivo",NA))))

# B. Variable de categoria ocupacional: PEA
enaho <- enaho %>% 
  mutate(catg_pea = ifelse(ocu500==1, "Ocupado",
                              ifelse(ocu500==2,"Desempleo",NA)))

# C. Variable de sexo 
table(df$p207)
enaho <- enaho %>%
  mutate(sexo = ifelse(p207=="hombre", "Hombre",
                       ifelse(p207=="mujer", "Mujer", NA)))
table(enaho$sexo)


# Considerando la informacion de ocu500
table(df$estrato)
encuesta = svydesign(data=enaho, id=~conglome, strata=~estrato,
                     weights=~fac500a)

# =====================================================================
# Part II: market labor
# =====================================================================
# Vaiable categoria de empleo
tabla_1 <- svymean(~catg_empleo, encuesta, deff=F, na.rm=T)
tabla_1
# exportar excel
require(openxlsx)
write.xlsx(tabla_1, file = "tab_1.xlsx")

# Variable de categoria de pea
tabla_2 <- svymean(~catg_pea, encuesta, deff=F, na.rm=T)
tabla_2

# Variable de categoria de sexo
tabla_3 <- svyby(~catg_pea, ~sexo, encuesta,svymean, deff=F, na.rm=T)
tabla_3
