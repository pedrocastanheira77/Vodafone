class SiteMes

  def initialize(site)
      @site = site
  end

  def calcula_linhas
    fileObj = File.open("ficheiros gerados/1.2_site_#{@site}.csv")
    count = fileObj.read.count("\n")
    fileObj.close
    return count
  end

  def prepara_colunas_ref
    meses = [
             "Mes",
             "Jan",
             "Fev",
             "Mar",
             "Abr",
             "Mai",
             "Jun",
             "Jul",
             "Ago",
             "Set",
             "Out",
             "Nov",
             "Dez"
            ]
  end
  
  def calcula_colunas
    cabecalho = leituras[0]
    cabecalho.size
  end

  def leituras
    num_leituras = calcula_linhas
    fileObj = File.open("ficheiros gerados/1.2_site_#{@site}.csv")
    linhas=[]
    for i in 0...num_leituras
      entrada = fileObj.gets.split("\n")
      entrada = entrada[0].split(";")
      linhas.push(entrada)
    end 
    
    for i in 1...num_leituras
      linhas[i].map! {|x| x.to_f}
    end
    
    fileObj.close
    return linhas
  end

  def valores_mensais
    num_leituras = calcula_linhas
    num_colunas = calcula_colunas
    array = leituras
    tab = Array.new(array)  
    
    indicadores = []
    for i in 5...num_colunas
      indicadores.push(tab[0][i])
    end

    valores_mes = []
    for mes in 1..12
      a = []
      for j in 5...num_colunas
        sum = 0
        for i in 1...calcula_linhas
          sum += tab[i][j] if tab[i][2] == mes
        end
        a.push(sum)
      end
      valores_mes.push(a)
    end

    ### Modo de visualização
    tab_arranjada = []
    for i in 5...num_colunas
      #indicadores[i-5]
      linha = [indicadores[i-5]]
      for j in 1..12
        linha.push(valores_mes[j-1][i-5].round(2))
      end
      tab_arranjada.push(linha)
    end
    tab_arranjada
  end

  def cria_novo_csv(tab)
    num_leituras = 13
    File.delete("ficheiros gerados/1.3_site_mensal_#{@site}.csv") if File.exist?("ficheiros gerados/1.3_site_mensal_#{@site}.csv")
    fileObj = File.new("ficheiros gerados/1.3_site_mensal_#{@site}.csv", 'a+')
    File.open("ficheiros gerados/1.3_site_mensal_#{@site}.csv",'a') do |linha|
      for i in 0...num_leituras
        for j in 0...tab[0].size-1
          linha.write("#{tab[i][j]};")
        end
        linha.write("#{tab[i][tab[0].size-1]}\n")
      end
    end
    fileObj.close
  end

  def core
    colunas_ref = prepara_colunas_ref
    colunas_medicoes = valores_mensais
    tab =[]
    for i in 0..12
      linha = []
      linha.push(colunas_ref[i])
      for j in 0...colunas_medicoes.size
        linha.push(colunas_medicoes[j][i])
      end
    tab.push(linha)
    end
    tab
    cria_novo_csv(tab)
  end

end

def corre_vsitesmes
  sites = ["alf1p0",
           "alf1p-1",
           "alf2a1",
           "alf2a7a8",
           "bvtp1",
           "bvtp0",
           "avr",
           "cmb",
           "far",
           "fmc",
           "fnc",
           "mat",
           "pdg",
           "ptm",
           "snt",
           "ran"]

  for i in 0...sites.size
    nome = "mensal_#{sites[i]}"
    nome = SiteMes.new(sites[i])
    nome.core
    count = (((i.to_f+1)/16)*100).round(0)
    puts "status..#{count}%"
  end
end

#corre_vsitesmes