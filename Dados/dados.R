# Importando dados vetoriais de pontos com a função read_sf() e
#library(tidyverse)
#library(foreign)
#library(sf)

# salvando no objeto `ac_unidades`
ac_unidades <- read_sf('/home/pamela/Documentos/spatial-data-analysis-R/Dados/ac_unidades_saude_m.shp')

# Analisando o arquivo importado
ac_unidades

#mportamos 1008 unidades de saúde, entre postos de saúde, consultórios e hospitais. 
#Vamos agora, importar os demais dados para executar a nossa tarefa.

# Importando dados vetoriais de linhas com a função read_sf() e
# salvando no objeto `ac_vias`
ac_vias <- read_sf('/home/pamela/Documentos/spatial-data-analysis-R/Dados/ac_vias.shp')

# Analisando o arquivo importado
ac_vias
#importamos 18423 linhas entre rodovia e ruas. 


# Importando dados vetoriais de polígonos com a função read_sf() e
# salvando no objeto `ac_municipios` 
ac_municipios <- read_sf('/home/pamela/Documentos/spatial-data-analysis-R/Dados/ac_municipios.shp')

# Analisando o arquivo importado
ac_municipios

# Visualizando informações sobre o objeto ac_municipios 
# com a função st_geometry()
st_geometry(ac_municipios)


# Verificando o sistema de coordenadas de referência
st_crs(ac_municipios)

# na primeira linha já é mostrado o sistema de referência e na última linha mostra o código EPSG. 
#O arquivo, portanto, se encontra no sistema de coordenadas geográficas SIRGAS 2000, código 4674.



# Transformando o sistema de coordenadas do objeto `ac_municipios` 
# com a função st_transform()
ac_municipios_5880 <- st_transform(x = ac_municipios, crs = 5880)


# Verificando a trasnformação do
# sistema de coordenadas de referência
st_crs(ac_municipios_5880)


#Visualizando dados espaciais

# Plotando e visualizando o objeto `ac_municipios`
plot(x = st_geometry(ac_municipios))

#axes: plota as coordenadas nos eixos x e y;
#graticule: plota uma grade que acompanha as coordenadas;
#col: define a cor de preenchimento (no caso de polígonos);
#xlab e ylab: define os rótulos dos eixos;
#main: apresenta um título centralizado no topo do mapa.

# Plotando e visualizando o objeto ac_municipios
plot(
  
  # Definindo o objeto que será utilizado para a visualização do mapa
  x = st_geometry(ac_municipios),
  
  # Definindo como verdadeiro o argumento para plotagem das coordenadas 
  # nos eixos do gráfico
  axes = TRUE,
  
  # Definindo como verdadeiro o argumento para plotagem da grade com as
  # coordenadas
  graticule = TRUE,
  
  # Definindo a cor de preenchimento (código hexadecimal)
  col = "#FAFAFA",
  
  # Definindo os rótulos dos eixos x e y
  xlab = "longitude",
  ylab = "latitude"
)


#3.3.2 Usando o pacote ggplot2

#sobrepor as camadas de arquivos importados anteriormente (unidades de saúde, ruas e limites de municípios) para completar nossa tarefa. 
#Para isso, vamos utilizar a função geom_sf() que plota camadas de objetos importados pelo pacote sf. 
#Essa função tem como argumento obrigatório data, que se refere ao objeto sf importado. Vamos utilizar também argumentos estéticos como:

#fill: cor do preenchimento quando o objeto for composto por polígonos e,
#color: cor das linhas e pontos, quando o objeto for compostos por estas geometrias.

# Utilizando a função ggplot() para plotagem dos mapas
ggplot() +
  
  # Plotando o objeto de polígono com os contornos do estado
  # O argumento "fill" define a cor de preenchimento
  geom_sf(data = ac_municipios, fill = "#FAFAFA") +
  
  # Plotando o objeto de linhas para visualização de estradas
  # O argumento "color" define a cor das linhas
  geom_sf(data = ac_vias, color = "#BABABA") +
  
  # Plotando o objeto de pontos para visualização das unidades de saúde
  # O argumento "color" define a cor de preenchimento
  geom_sf(data = ac_unidades, color = "#00DD00")




# Utilizando a função ggplot() para plotagem dos mapas
ggplot()+
  
  # Adicionando camada com os limites poligonais do estado do AC com o 
  # objeto `ac_municipios` e a função geom_sf().
  # O argumento "fill" define o codinome da cor de preenchimento
  geom_sf(data = ac_municipios, aes(fill = "cor_municipios")) + 
  
  # Adicionando camada com objeto de linhas representando as vias com o 
  # objeto `ac_vias` e a função geom_sf()
  # O argumento "color" define o codinome da cor das linhas
  geom_sf(data = ac_vias, aes(color = "cor_ruas")) +
  
  # Adicionando camada com objeto de pontos  representando unidades de
  # saúde com o objeto `ac_unidades` e a função geom_sf()
  # O argumento "color" define o codinome da cor de preenchimento
  geom_sf(data = ac_unidades, aes(color = "cor_unidades")) +
  
  # Definindo a escala gráfica do mapa com a função annotation_scale()
  annotation_scale(location = "br",
                   height = unit(.1, "cm")) +
  
  # Definindo a visualização de seta apontada para o Norte  
  annotation_north_arrow(location = "tr",
                         height = unit(1, "cm"),
                         style = north_arrow_fancy_orienteering) +
  
  # Criando a legenda das linhas e pontos
  scale_color_manual(
    name = "",
    guide = guide_legend(override.aes = list(linetype = c("solid", "blank"), 
                                             shape = c(NA, 16))),
    values = c('cor_ruas' = '#BABABA', 'cor_unidades' = '#00DD00'),
    labels = c("Vias", "Unidades de saúde")
  ) +
  
  # Criando a legenda dos polígonos
  scale_fill_manual(
    name = "",
    values = c('cor_municipios' = '#FAFAFA'),
    labels = "Municípios"
  ) +
  
  # Definindo o título e rótulos dos eixos do gráfico  
  labs(title = "Unidades de saúde e arruamento do Estado do Acre, 2022.",
       x = "longitude",
       y = "latitude",
       caption = "Fonte dos dados: IBGE e Ministério da Saúde") +
  
  # Adicionando o tema
  theme_bw()




#4. União dos dados tabulares (não-gráficos) com bases geográficas (gráficas)
#armazenadas como dados não gráficos:
  
#  * dados populacionais,
#  * contagens de eventos (como as tabelas do Tabnet),
#  * taxas e razões de eventos relacionados à saúde,e
#  * dados ambientais.

# 4.1. União com códigos (geocódigos)
# O arquivo de dados geográficos de unidades de saúde contém 1008 registros e 5 colunas, incluindo a geometria. 
# Como neste arquivo cada linha representa uma unidade de saúde, vamos inspecionar a estrutura da tabela usando a função glimpse() 
# do pacote dplyr. 

#Utilize o código a seguir para fazer essa inspeção:

# Inspecionando o objeto ac_unidades com a função glimpse()
glimpse(ac_unidades)




#conectar com esta tabela, vamos importar o arquivo {ac_unidades_tabela.xlsx} usando a função read_xlsx() do pacote reaxl e 
#repetir a inspeção feita acima. 
#Execute os seguintes códigos
# Carregando base de dados com a função read_xlsx()
tabela_unidades <- read_xlsx('/home/pamela/Documentos/spatial-data-analysis-R/Dados/ac_unidades_tabela.xlsx')

# Inspecionando o objeto tabela_unidades com a função glimpse()
glimpse(tabela_unidades)





# Salvando o objeto `ac_unidades_completo` pela união da tabela
# `ac_unidades` com a tabela tabela_unidades
ac_unidades_completo <- ac_unidades |>
  
  # Atilizando a função left_join() para união.
  # A ligação é feita pela correspondência entre as
  # colunas "cnes_n" e "codigo_cnes"
  left_join(tabela_unidades, by = c("cnes_n" = "codigo_cnes"))

glimpse(ac_unidades_completo)




#5. Criação de mapas temáticos

# 5.2 Mapa de símbolos proporcionais

# A nossa base de população contém dados do estado do Acre de 2009 a 2021. 
# Ao importá-la, perceba que o comando possui um argumento chamado col_types. 
# Esse argumento é necessário para garantir que a primeira coluna do arquivo, chamada “Codigo”,
# se mantenha como o formato original “character”.

# Carregando tabela com dados de população do acre para o objeto pop_ac
# utilizando a função read_csv2()
pop_ac <- read_csv2('/home/pamela/Documentos/spatial-data-analysis-R/Dados/pop_ac_09_21.csv', col_types = list("character"))

# Padronizando o nome das colunas utilizando a função `clean_names()`
# do pacote janitor
pop_ac <- clean_names(pop_ac)

# Unindo a tabela ac_municipios_5880 com pop_ac com a função left_join()
pop_geo_ac <- ac_municipios_5880 |>
  
  # A ligação é feita pela correspondência entre as colunas "cod_mun" e "codigo"
  left_join(pop_ac, by = c('cod_mun' = 'codigo')) 

# Plotando o objeto pop_geo_ac com uso da função mf_map()
mf_map(pop_geo_ac) |>
  
  # Indicando o tamanho proporcional da população com uso da função mf_prop()
  mf_prop(var = "x2021")


# 5.2 Mapa de símbolos proporcionais

#   1. Primeiro, vamos utilizar a função mf_theme() que apresenta vários argumentos para criar um tema para o mapa. 
#   Neste caso vamos apenas alterar a cor do fundo para branco utilizando o argumento bg. 
#   Esse fundo não é o fundo do mapa, mas a área por trás do mapa.

# Definindo a cor de fundo por trás do mapa como "branco",
# com uso da função mf_theme()
mf_theme(bg = "white")

# Em seguida, vamos adicionar o mapa base com os limites dos municípios. 
# Vamos utilizar o argumento col para alterar a cor do preenchimento da área dos municípios. 
# Perceba que usamos a codificação de cores (hexadecimal) apresentada no curso. Vamos também sobrepor a camada com os círculos proporcionais, indicando os seguintes argumentos:

# var: coluna com os dados a serem plotados;
# leg_pos: posição da legenda. Este argumento aceita as seguintes instruções:
# topright : acima à direita;
# topleft: acima à esquerda;
# bottomright: abaixo à direita;
# bottomleft: abaixo à esquerda.
# leg_title: o título da legenda;
# col: este argumento dentro da função mf_prop() se refere à cor interna dos círculos.

# Plotando o objeto pop_geo_ac com uso da função mf_map()
# O argumento "col" define a cor de preenchimento utilizando o código de
# cor hexadecimal
mf_map(pop_geo_ac, col = "#FAFAFA") |>
  
  # Indicando o tamanho proporcional da população com uso da função mf_prop()
  mf_prop(
    # Definindo a variável x2021 para cálculo do tamanho proporcional dos círculos
    var = "x2021",
    
    # Definindo a posição da legenda para "abaixo e à esquerda"
    leg_pos = "bottomleft",
    
    # Definindo o título do gráfico
    leg_title = "Populacao Acre 2021",
    
    # O argumento "col" define a cor de preenchimentto dos círculos utilizando
    # o código de cor hexadecimal
    col = "#000099"
  )

# 3. Agora vamos inserir a seta de norte utilizando a função mf_arrow().
# Essa função tem como principal argumento a posição da seta, indicada por pos. 

# Definindo a posição da seta de norte para a região "superior e à direita"
# com a função mf_arrows()
mf_arrow(pos = "topright")

  # 4.  inserir a escala, utilizando a função mf_scale().
  # O tamanho da escala é padronizado, mas é possível alterá-lo utilizando o argumento size. 

# Inserindo a escala com a função mf_scale()
mf_scale()

# Definindo a cor de fundo por trás do mapa como "branco", com uso da 
# função mf_theme()
mf_theme(bg = "white")

# Plotando o objeto pop_geo_ac com uso da função mf_map()
# O argumento "col" define a cor de preenchimento utilizando o código de
#  cor hexadecimal
mf_map(pop_geo_ac, col = "#FAFAFA") |> 
  
  # Indicando o tamanho proporcional da população com uso da função mf_prop()  
  mf_prop(
    # Definindo a variável x2021 para cálculo do tamanho proporcional dos círculos
    var = "x2021",
    
    # Definindo a posição da legenda para "abaixo e à esquerda"
    leg_pos = "bottomleft",
    
    # Definindo o título do gráfico
    leg_title = "Populacao Acre 2021",
    
    # O argumento "col" define a cor de preenchimentto dos círculos utilizando
    # o código de cor hexadecimal
    col = "#000099"
  ) 

# Definindo a posição da seta de norte para a região "superior e à direita" 
# com a função mf_arrows()
mf_arrow(pos = "topright")

# Inserindo a escala com a função mf_scale()
mf_scale()


#Utilizando o pacote mapsf também é possível inserir título e notas de rodapé, utilizando as funções mf_title() e mf_credits(). 
#O uso dessas funções é muito similar às demais do pacote.
mf_theme(bg = "white")
mf_map(pop_geo_ac, col = "#FAFAFA") |> 
  mf_prop(
    var = "x2021",
    leg_pos = "bottomleft1",
    leg_title = "Populacao Acre 2021",
    col = "#FFAD48"
  ) 
mf_arrow(pos = "topright")
mf_scale(pos = "bottomright")
mf_title(txt = "Distribuicao espacial da populacao do Estado do Acre segundo 
municipio, 2021.", cex = .8)
mf_credits(txt = "Fonte: IBGE-2021.", pos = "bottomleft")


# 5.3 Mapa coroplético

# Mapas coropléticos representam dados de unidades de áreas delimitadas, que podem ser bairro, áreas administrativas, distritos ou até mesmo o município. 
# Cada área recebe uma cor de acordo com a classificação prévia dos dados, que podem ser taxas de incidências, razões de mortalidade, entre outros.
# Para elaborá-lo, basta que haja as taxas para cada área de análise e o arquivo vetorial com os limites administrativos.

#A composição deste tipo de mapa envolve, basicamente, quatro etapas essenciais:
  
# definição da área que será representada;
# cálculo das razões, frequências ou taxas da variável de interesse;
# classificação da variável;
# visualização do mapa.

#5.3.1 Prevalência de Hanseníase no Acre

# Importação da base de casos do SINAN para o R, utilizando o pacote foreign.
base_hans <- read.dbf('/home/pamela/Documentos/spatial-data-analysis-R/Dados/base_hans_ac.dbf', as.is = TRUE)

casos_hans_ac_21 <- base_hans |>
  
  # Filtrando para os casos que o Tipo de Alta está em branco (TPALTA_N), 
  # denotando os casos em acompanhamento.
  filter(is.na(TPALTA_N)) |>
  
  # Sumarização dos casos por município de atendimento (MUNIRESAT).
  count(MUNIRESAT)



prev_casos_ac <- casos_hans_ac_21 |>
  
  # Unindo a tabela de casos à tabela de população pelo geocódigo do município de 
  # atendimento.
  left_join(pop_ac, by = c("MUNIRESAT" = "codigo")) |> 
  
  # Filtrando os municípios que não foram encontrados na união.
  filter(!is.na(MUNIRESAT))

# Calculando a prevalência por município e seleção das colunas necessárias para o 
# mapa.
prevalencia_hans_ac <- prev_casos_ac |> 
  mutate(prevalencia_2021 = (n / x2021) * 10000) |> 
  select(MUNIRESAT, municipio, prevalencia_2021)

# Visualizando a tabela
prevalencia_hans_ac

# left_join - é banco de dados ( tem duas tabelas A e B, ai eu quero unir as duas, left_join eu quero unir a tabela b que é da esquerda com a direita que a tabela A
# para cada elemento da tabela b ele vai ve se tem como unir com a tabela A, 
# caso valor nao de uniao não exista, o valor da tabela b continua existe, mas os valores da tabela A que era para esta existindo fica nulos).






# Unindo a tabela `prevalencia_hans_ac` com `ac_municipios_5880` 
# com a função left_join() e salvando no objeto `prevalencia_mun`
prevalencia_mun <- left_join(
  
  x = ac_municipios_5880,
  y = prevalencia_hans_ac,
  
  # A ligação é feita pela correspondência entre as colunas
  #  "cod_mun" e "MUNIRESAT"
  by = c("cod_mun" = "MUNIRESAT")
) 

# A função mf_choro() para visualizar o mapa, definindo os seguintes argumentos:
  
# var: coluna com os dados a serem plotados;
# breaks: classificação utilizada para divisão das classes;
# pal: paleta de cores. Para visualização das paletas disponíveis excute a função hcl.pals() no console;
# leg_pos: posição da legenda;
# leg_title: o título da legenda;
# leg_no_data: texto a ser mostrado sempre que houver município sem dados.

#Próximos códigos com atenção e observe o resultado gerado:

# Plotando o objeto prevalencia_mun com uso da função mf_map()
mf_map(prevalencia_mun) |>
  
  # Adicionando camada de mapa coroplético com a função mf_choro()  
  mf_choro(
    
    # Definindo a variável que será utilizada para a cor de preenchimento
    var = "prevalencia_2021",
    
    # Definindo os intervalos de valores
    breaks = "quantile",
    
    # Definindo a paleta de cores para "viridis"
    pal = "Viridis",
    
    # Definindo a posição da legenda para a região "inferior e à esquerda"
    leg_pos = "bottomleft",
    
    # Definindo o título da legenda
    # 
    leg_title = "Prevalência \nHanseníase \n2021",
    
    # Inserindo caixa adicional para a legenda
    leg_no_data = "Sem dados"
  )


# Definindo a posição da seta de norte para a região "superior e à direita" com a 
# função mf_arrows()
mf_arrow(pos = "topright")

# Inserindo a escala com a função mf_scale()
mf_scale()

# Definindo o título do mapa e definindo o tamanho do texto
# para encaixar melhor no título
mf_title(txt = "Distribuicao espacial da prevalência de Hanseníase no Estado do 
Acre segundo municipio, 2021.",
         cex = 0.8, pos= 'center')

# Definindo informações complementares
mf_credits(txt = "Fonte: IBGE/2021 e SINAN/MS 2021.", pos = "rightbottom")



# 5.3.2 Coeficiente de Mortalidade Infantil no município de São Paulo

#importando o arquivo {cmi_sp_19_21.csv} com os dados de mortalidade infantil do município de São Paulo entre 2019 e 2021

# Importando o arquivo{`CID-cmi_sp_19_21.csv`} para o `R`
cmi_sp_19_21 <- read_csv2("/home/pamela/Documentos/spatial-data-analysis-R/Dados/cmi_sp_19_21.csv",
                          locale = locale(encoding = "ISO-8859-1"))


# Visualizando o objeto
cmi_sp_19_21

# Podemos perceber que o arquivo importado possui 5 colunas e 98 linhas. 
# Os nomes das colunas possuem espaços e números e uma coluna “Total” que não será necessária. 
# Além disso, as colunas que armazenam os coeficientes de mortalidade infantil estão como character.

# vamos utilizar funções dos pacotes janitor, stringr e stringi, instalados e carregados anteriormente.

# Criando um novo objeto com as correções feitas
cmi_sp <- cmi_sp_19_21 |> 
  
  # Padronizando o nome das colunas utilizando a função `clean_names` do
  # pacote `janitor`
  clean_names() |> 
  
  # Retirando a coluna `total`, pois não será necessária
  select(-total) |> 
  
  # Retirando as linhas que não corresponde a nenhum distrito administrativo,
  # utilizando a função `filter()` do pacote `dplyr`
  filter(
    dist_administrativo_resid != "Endereço não localizado" ,
    dist_administrativo_resid != "Ignorado"
  ) |>
  
  # Padronizando as colunas de ano para uma coluna só utilizando a função
  # `pivot_longer()` do pacote `dplyr`. Note que vamos retirar a letra "x",
  # adicionada pela função `clean_names()`
  pivot_longer(
    cols = c(x2019, x2020, x2021),
    names_to = "ano",
    values_to = "cmi",
    names_prefix = "x"
  ) |> 
  
  # Criando as novas colunas corrigidas
  mutate(
    
    # Primeiro criando a coluna que receberá os nomes dos distritos 
    # administrativos corrigidos (passaremos para maiúsculo utilizando a 
    # função `str_to_upper()` do pacote `stringr` e retiraremos os acentos
    # utilizando a função `stri_trans_general()` do pacote `stringi`)
    ds_nome = str_to_upper(dist_administrativo_resid) |>
      stri_trans_general("latin-ascii"),
    
    # Depois, a coluna que receberá os coeficientes corrigidos, utilizando a 
    # função `str_replace_all()` do pacote `stringr`, e transformados para 
    # valores numéricos utilizando a função `as.numeric()`
    cmi_num = str_replace_all(cmi, "\\,", "\\.") |>
      str_replace_all("\\-", NA_character_) |>
      as.numeric()
  )

# Visualizando as primeiras linhas do objeto `cmi_sp`
head(cmi_sp)

# Com as colunas devidamente corrigidas, vamos importar o arquivo vetorial dos distritos administrativos de São Paulo. 
# O arquivo {sp_da.gpkg} encontra-se disponível para download no menu lateral “Arquivos” do curso. 
# Vamos utilizar a função read_sf() para a importação e vamos salvá-lo no objeto chamado {distrito_adm_sp}.

# Importando o arquivo{`sp_da.gpkg`} para o `R`
distrito_adm_sp <- read_sf("/home/pamela/Documentos/spatial-data-analysis-R/Dados/sp_da.gpkg")

# Visualizando o objeto salvo
distrito_adm_sp


# Vamos unir o arquivo vetorial à tabela de coeficiente de mortalidade infantil. 
# A variável ds_nome, que agora está presente nos dois arquivos, será a ligação entre os dois. 

#Acompanhe o script abaixo:
# Unindo a tabela `distrito_adm_sp` com `cmi_sp` 
# com a função left_join() e salvando no objeto `cmi_sp_map`
cmi_sp_map <- left_join(
  
  x = distrito_adm_sp,
  y = cmi_sp,
  
  # A ligação é feita pela variável `ds_nome`
  by = "ds_nome"
)

# Vamos utilizar a função hist(), nativa da linguagem R, para visualizar os valores que vamos inserir no mapa.
#Essa função possui como argumento principal x, que é onde vamos explicitar a variável. 
#Note que vamos usar o cifrão para indicar a variável “cmi_num” da base {cmi_sp_map}. 
#Acompanhe o código abaixo e digite no seu computador:

hist(x = cmi_sp_map$cmi_num)


# Para isso, vamos utilizar as funções tm_shape() e tm_polygons() do pacote tmap. 
# A primeira insere uma camada referente ao mapa base e a segunda insere o mapa com a classificação dos valores coloridos conforme a paleta especificada. 
# Os argumentos são muito parecidos com a função mf_choro(), utilizada anteriormente.


# Também utilizaremos uma função bem interessante chamada tm_facets(), que cria um mapa para cada ano. 
# Isso possibilitará compararmos o coeficiente de mortalidade infantil de forma única.

# Para inserir o título, a fonte dos dados, a escala e a seta de norte, 
# vamos utilizar as funções tm_layout(), tm_credits(), tm_scale_bar() e tm_compass(), respectivamente. 
# Note que o pacote tmap utiliza o símbolo de mais (+) para sobrepor as camadas e elementos definidos pelas funções.

# Acompanhe o código:

# Plotando o objeto `cmi_sp_map` com uso da função tm_shape().
# Esse será o nosso mapa base.
tm_shape(cmi_sp_map) +
  
  # Adicionando camada de mapa coroplético com a função tm_polygons()
  tm_polygons(
    
    # Definindo a variável que será utilizada para a cor de preenchimento
    col = "cmi_num",
    
    # Definindo os intervalos de valores e a classificação via "jenks"
    n = 5, style = "jenks",
    
    # Definindo a paleta de cores para "viridis". Para inverter a direção
    # das cores (do mais claro para o mais escuro), precisamos inserir
    # o símbolo de menos antes do nome da paleta.
    palette = "-viridis",
    
    # Definindo o título da legenda. Usamos o marcador "\n" para pular linha
    title = "Coeficiente \nde Mortalidade \nInfantil por mil \nnascidos vivos",
    
    # Definindo o separador dos coeficientes na legenda
    legend = list(text.separator = "a"),
    
    # Inserindo caixa adicional para a legenda onde não há dados
    colorNA = "white",  textNA = "Sem dados"
  ) +
  
  # Utilizando a função `tm_facets()` para criar um mapa para cada ano com o
  # argumento `by` e definindo uma linha para a disposição dos mapas com o
  # argumento `nrow`
  tm_facets(by = "ano", nrow = 1) +
  
  # Definindo a posição da seta de norte para a região
  # "superior e à direita" com a função tm_compass(), com
  # argumento `position`
  tm_compass(position = c("right", "top")) +
  
  # Inserindo a escala com a função tm_scale_bar()
  tm_scalebar() +
  
  # Definindo o título do mapa e definindo o tamanho do texto
  # para encaixar melhor no título
  
  tm_title("Coeficiente de Mortalidade Infantil por distritos\nadministrativos de São Paulo-SP, 2019 a 2021.") +
  
  # Definindo informações complementares. Como teremos três mapas, um para
  # cada ano, inserimos um vetor contendo a fonte dos dados aparecendo
  # somente no primeiro mapa. 
  
  tm_credits(text = c("Fonte:\nSMS-SP;\nSMPGP-SP","",""), position = c("bottom"))




# 5.4 Mapa de fluxos 

# Primeiramente, vamos importar a base que se encontra no formato “*.dbf”. 
# Para isso, vamos utilizar o pacote foreing. Execute o comando a seguir no seu computador:

# Carregando a base de dados para o objeto ac_internacao utilizando 
# a função read.dbf()
ac_internacao <- read.dbf("/home/pamela/Documentos/spatial-data-analysis-R/Dados/ac_sih.dbf", as.is = TRUE)


# Visualizando as primeiras linhas da tabela importada
head(ac_internacao)


# Agora, para criar o mapa de fluxo, vamos considerar as variáveis que representam o município de residência (MUNIC_RES) da mulher como a origem do deslocamento 
# e município de internação (MUNIC_MOV) como o destino do deslocamento que realizou a internação relacionada ao parto, gravidez e puerpério.

# Em seguida, vamos contabilizar quantos deslocamentos ocorreram no ano de 2021 entre o par de município origem e destino. 
# Para isso, vamos utilizar a função count() do pacote dplyr.
# Além disso, vamos excluir as internações onde a origem e o destino são iguais, ou seja, é o mesmo município e o paciente foi internado no município onde reside. 
# Também vamos desconsiderar os deslocamentos com volume menor que 10. 
# Essas operações serão salvas em um novo objeto chamado {ac_capitulo_15}.

# Acompanhe o código abaixo: 
# Criando uma nova tabela com o nome ac_capitulo_15
ac_capitulo_15 <- ac_internacao |> 
  
  # Contando a frequência de registros por município de residência
  # (coluna MUNIC_RES) e município de internação (coluna MUNIC_MOV)
  count(MUNIC_RES, MUNIC_MOV) |> 
  
  # Filtrando os registros em que o município de residência difere
  #  do município de internação e com uma frequência maior ou igual a 10
  filter(MUNIC_RES != MUNIC_MOV, n >= 10)

# Agora, com a frequência do deslocamento município de origem e município de destino calculada, vamos unir esses dados ao mapa. 
# Dessa forma, criaremos as referências geográficas dos municípios de origem e de destino para a criação das linhas de ligação entre os municípios devidamente espacializadas. 
# Para isso, vamos utilizar a função mf_get_links() do pacote mapsf e informar os seguintes argumentos:
  
# x: um arquivo vetorial de municípios (vamos utilizar a {ac_municipios_5880});
# x_id: a variável do arquivo vetorial a ser utilizada como o geocódigo (“cod_mun”);
# df: uma base de frequência de deslocamentos {ac_capitulo_15};
# df_id: um vetor contendo as variáveis de origem e de destino, respectivamente (no caso “MUNIC_RES” e “MUNIC_MOV”).


# Criando as linhas de ligação com a frequência de deslocamento
ac_deslocamentos <- mf_get_links(
  x = ac_municipios_5880,             # um arquivo vetorial de municípios
  x_id = "cod_mun",                   # variável de ligação
  df = ac_capitulo_15,                # arquivo de frequência de deslocamentos
  df_id = c("MUNIC_RES", "MUNIC_MOV") # variáveis de origem e destino
)


# Ao visualizar as primeiras linhas do objeto ac_deslocamentos, você perceberá que, 
# para cada par de município de residência e município de internação, 
# foi calculada a frequência de deslocamentos entre estes municípios e sua devida ligação geográfica.

head(ac_deslocamentos)









# Observe o código abaixo com atenção e reproduza-o no seu RStudio.

# Plotando o objeto `ac_municipios_5880` com uso da função mf_map()
# O argumento "col" define a cor de preenchimento utilizando o código de
# cor hexadecimal
mf_map(ac_municipios_5880, col = "#FAFAFA")

# Inserindo camada indicando os descolamentos com uso da função mf_grad()
mf_grad(
  
  # Definindo o objeto com a frequência sobre os deslocamentos
  x = ac_deslocamentos,
  
  # Definindo a variável que indicará a espessura da linha conforme a frequência
  var = "n",
  
  # Definindo o número mínimo de intervalos para os valores de espessura
  nbreaks = 3,
  
  # Definindo o método de classificação dos intervalos para quantis
  breaks = "quantile",
  
  # Definindo a espessura da linha relativa a cada intervalo
  lwd = c(.7, 3, 7),
  
  # Definindo a posição da legenda para "inferior e à esquerda"
  leg_pos = "bottomleft",
  
  # Definindo o título do gráfico
  leg_title = "Número de fluxos",
  
  # Definindo a cor da linha com o código de cor hexadecimal.
  # Para definir a opacidade, inserimos dois dígitos no final do
  # código. Dessa forma, nossas linhas ficarão mais transparentes,
  # melhorando a visualização
  col = "#5DC86395"
)

# Definindo a posição da seta de norte para a
# "superior e à direita" com a função mf_arrows()
mf_arrow(pos = "topright")

# Inserindo a escala com a função mf_scale()
mf_scale()

# Definindo o título do mapa e definindo o tamanho do texto
# para encaixar melhor no título

mf_title(txt = "Fluxo de deslocamento das internações de mulheres por gravidez, parto e puerpério, Acre, 2021.",
         cex = 0.8)

# Inserindo informações complementares
mf_credits(txt = "Fonte: IBGE/2021 e SINAN/MS 2021.", pos = "rightbottom")
