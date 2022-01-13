#Rotina para coletar e apresentar em gráficos algumas séries do banco central
#Feito por: Marcelo Vilas Boas de Castro
#última atualização: 10/11/2020

#Definindo diretórios a serem utilizados

getwd()
setwd("C:/Users/User/Documents")

#Possíveis pacotes que podem ser utilizados
#library(rio) #Para exportar em formato xlsx

#Criando função para coleta de séries
coleta_dados_sgs = function(series,datainicial="01/03/2011", datafinal = format(Sys.time(), "%d/%m/%Y")){
  #Argumentos: vetor de séries, datainicial que pode ser manualmente alterada e datafinal que automaticamente usa a data de hoje
  #Cria estrutura de repetição para percorrer vetor com códigos de séries e depois juntar todas em um único dataframe
  for (i in 1:length(series)){
    dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",series[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
    dados[,-1] = as.numeric(gsub(",",".",dados[,-1])) #As colunas do dataframe em objetos numéricos exceto a da data
    nome_coluna = series[i] #Nomeia cada coluna do dataframe com o código da série
    colnames(dados) = c('data', nome_coluna)
    nome_arquivo = paste("dados", i, sep = "") #Nomeia os vários arquivos intermediários que são criados com cada série
    assign(nome_arquivo, dados)
    
    if(i==1)
      base = dados1 #Primeira repetição cria o dataframe
    else
      base = merge(base, dados, by = "data", all = T) #Demais repetições agregam colunas ao dataframe criado
    print(paste(i, length(series), sep = '/')) #Printa o progresso da repetição
  }
  
  base$data = as.Date(base$data, "%d/%m/%Y") #Transforma coluna de data no formato de data
  base = base[order(base$data),] #Ordena o dataframe de acordo com a data
  return(base)
}

#Definida a função, podemos criar objetos para guardar os resultados
serie = c(1,7) #Vetor com código para o dólar e o Ibovespa, respectivamente
ex = coleta_dados_sgs(serie) #Criando objeto em que ficam guardados as séries

write.csv2(ex, "Exemplo.csv", row.names = F) #Salvando arquivo csv em padrão brasileiro
#export(ex, "Exemplo.xlsx") #Salvando em formato xlsx