require 'time'

class Tarifarios

  def initialize(site)
      @site = site
  end

  def le_periodos_tarifarios
    fileObj = File.open("tarifarios/tarifa_#{@site}.txt")
    cabecalho = fileObj.gets.split("\n")
    cabecalho = cabecalho[0].split(";")
    num_linhas = cabecalho[1].to_f
    tabela=[]
    for i in 1...num_linhas-1
      linha = fileObj.gets.split("\n")
      linha = linha[0].split(";")
      linha.map! {|x| x.strip}
      tabela.push(linha)
    end
    for i in 3...tabela.size
      tabela[i][1] = tabela[i][1].to_f
    end
    fileObj.close
    return tabela
  end

  def cria_tarifa_site
    tarifario = le_periodos_tarifarios
  end

end
