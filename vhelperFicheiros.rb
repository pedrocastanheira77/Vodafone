class Ficheiro

  def initialize(ficheiro,cabecalho)
    @ficheiro = ficheiro
    @cabecalho = cabecalho # linhas a apagar no inicio do ficheiro que não interessam
  end

  def self.calcula_linhas(ficheiro, cabecalho)
    fileObj = File.open(ficheiro)
    count = fileObj.read.count("\n") - cabecalho
    fileObj.close
    count
  end

  def self.leitura(ficheiro, cabecalho)
    num_leituras = Ficheiro.calcula_linhas(ficheiro, cabecalho)
    fileObj = File.open(ficheiro)
    cabecalho.times do
      fileObj.gets.split("\n")
    end
    tabela=[]
    for i in 0...num_leituras
      linha = fileObj.gets.split("\n")
      linha = linha[0].split(";")
      tabela.push(linha)
    end
    fileObj.close
    tabela
  end

  def self.cria_csv(tabela, ficheiro, num_colunas_ref)
    ## passagem de "." a ",". Para facilitar a utilização do ficheiro em excel
    for i in 1...tabela.size
      for j in num_colunas_ref...tabela[0].size
        tabela[i][j] = tabela[i][j].to_s.sub(".",",")
      end
    ## fim
    end
    num_linhas = tabela.size
    num_colunas = tabela[0].size
    File.delete(ficheiro) if File.exist?(ficheiro)
    fileObj = File.new(ficheiro, 'a+')
    File.open(ficheiro,'a') do |linha|
      for i in 0...num_linhas
        for j in 0...num_colunas-1
          linha.write("#{tabela[i][j]};")
        end
        linha.write("#{tabela[i][num_colunas-1]}\n")
      end
    end
    fileObj.close
  end

end
