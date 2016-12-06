class Tabelas

  def self.concatenacao_tabs(tabela_um, tabela_dois)
    for i in 0...tabela_dois.size
      tabela_um[i].concat(tabela_dois[i])
    end
    tabela_um
  end

  def self.calcula_soma_colunas(tabela, num_colunas_ref)
    num_linhas = tabela.size
    acumulado = Array.new(tabela[0].size,0)
    for j in 0...num_colunas_ref
      acumulado[j] = ""
    end
    for i in 1...num_linhas
      for j in num_colunas_ref...tabela[0].size
        acumulado[j] += tabela[i][j]
        acumulado[j] = acumulado[j].round(2)
      end
    end
    tabela.push(acumulado)
  end

  def self.calcula_soma_linhas(tabela, num_colunas_ref)
    acumulado = [["Total"]]
    for i in 1...tabela.size
      soma = 0
      for j in num_colunas_ref...tabela[0].size
        soma += tabela[i][j]
      end
      acumulado[i] = [soma.round(2)]
    end
    tabela = Tabelas.concatenacao_tabs(tabela, acumulado)
  end

  def self.meses
    [["Meses"],
     ["Jan"],
     ["Fev"],
     ["Mar"],
     ["Abr"],
     ["Mai"],
     ["Jun"],
     ["Jul"],
     ["Ago"],
     ["Set"],
     ["Out"],
     ["Nov"],
     ["Dez"]]
  end

  def self.trimestres
    [["Trimestres"],
     ["1 Trimestre"],
     ["2 Trimestre"],
     ["3 Trimestre"],
     ["4 Trimestre"],
     ["Total"]]
  end

  def self.dias_mes
    [["dias"],
     [31],
     [29],
     [31],
     [30],
     [31],
     [30],
     [31],
     [31],
     [30],
     [31],
     [30],
     [31]]
  end

  def self.get_index_colunas(texto, tabela)
    for index in 0...tabela[0].size
      break if tabela[0][index].include?(texto)
    end
    index
  end

end
