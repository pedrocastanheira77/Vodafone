require 'time'

class ListaSites
  def self.lista_sites
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
  end
end

class PeriodosAnalise
  def self.meses
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

  def self.trimestre
    trimestre = ["1 Trimestre","2 Trimestre","3 Trimestre","4 Trimestre"]
  end
end

class FilesWM
  def initialize(texto_procura)
    @texto_procura = texto_procura
  end
  
  def lista_ficheiros
    Dir.glob("ficheiros wisemetering/*.csv")
  end

  def corresponde
    lista = lista_ficheiros
    ficheiros_usar = []
    for j in 0...@texto_procura.size
      for i in 0...lista.size
        break if lista[i].include? @texto_procura[j]
      end
    ficheiros_usar.push(lista[i])
    end
  ficheiros_usar
  end
end

def corre_vfiles
  chaves = [["ficheiros wisemetering/ea+_dtcs_K_15_minutes", "ficheiros wisemetering/ea+_omcs_K_15_minutes"],
            ["ficheiros wisemetering/ea+_avac_dtcs_K_15_minutes", "ficheiros wisemetering/ea+_avac_omcs_K_15_minutes"],
            ["ficheiros wisemetering/ea+_it_dtcs_K_15_minutes", "ficheiros wisemetering/ea+_it_omcs_K_15_minutes"]
           ]
  globais = FilesWM.new(chaves[0])
  avac = FilesWM.new(chaves[1])
  it = FilesWM.new(chaves[2])
  files = [globais.corresponde, avac.corresponde, it.corresponde]
end

class LeFicheiro
  def initialize(ficheiro,cabecalho)
    @ficheiro = ficheiro
    @cabecalho = cabecalho # linhas a apagar no inicio do ficheiro que não interessam
  end

  def calcula_linhas
    fileObj = File.open(@ficheiro)
    count = fileObj.read.count("\n") - @cabecalho
    fileObj.close
    return count
  end

  def leitura
    num_leituras = calcula_linhas
    fileObj = File.open(@ficheiro)
    @cabecalho.times do
      fileObj.gets.split("\n")
    end
    tabela=[]
    for i in 0...num_leituras
      linha = fileObj.gets.split("\n")
      linha = linha[0].split(";")
      tabela.push(linha)
    end
    fileObj.close
    return tabela
  end
end

class EscreveFicheiro
  def self.cria_csv(tabela, ficheiro)
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

class ConcatenaTabelas
  def self.concat (tabela_um, tabela_dois)
    for i in 0...tabela_dois.size
      tabela_um[i].concat(tabela_dois[i])
    end
    tabela_um
  end
end

class PeriodosHorarios

  def initialize(site)
      @site = site
  end

  def le_periodos_tarifarios
    fileObj = File.open("templates/tarifa_#{@site}.txt")
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

  def self.ciclo_diario
    # [inverno = [[pontas],[cheias],[vazionormal], [supervazio]],[verao = [pontas],[cheias],[vazionormal], [supervazio]]]
    periodos = [
                 [["09:00","09:15","09:30","09:45", # pontas - inverno
                 "10:00","10:15",
                 "18:00","18:15","18:30","18:45",
                 "19:00","19:15","19:30","19:45",
                 "20:00","20:15"],
               ["08:00","08:15","08:30","08:45",  # cheias - inverno
                "10:30","10:45",
                "11:00","11:15","11:30","11:45",
                "12:00","12:15","12:30","12:45",
                "13:00","13:15","13:30","13:45",
                "14:00","14:15","14:30","14:45",
                "15:00","15:15","15:30","15:45",
                "16:00","16:15","16:30","16:45",
                "17:00","17:15","17:30","17:45",
                "20:30","20:45",
                "21:00","21:15","21:30","21:45"],
               ["06:00","06:15","06:30","06:45",  # vazio - inverno
                "07:00","07:15","07:30","07:45",
                "22:00","22:15","22:30","22:45",
                "23:00","23:15","23:30","23:45",
                "00:00","00:15","00:30","00:45",
                "01:00","01:15","01:30","01:45"],
               ["02:00","02:15","02:30","02:45",  # super-vazio - inverno
                "03:00","03:15","03:30","03:45",
                "04:00","04:15","04:30","04:45",
                "05:00","05:15","05:30","05:45"]],
               [["10:30","10:45",                 # pontas - verão
                "11:00","11:15","11:30","11:45",
                "12:00","12:15","12:30","12:45",
                 "19:30","19:45",
                 "20:00","20:15","20:30","20:45"],                
               ["08:00","08:15","08:30","08:45",  # cheias - verão
                "09:00","09:15","09:30","09:45",
                "10:00","10:15",
                "13:00","13:15","13:30","13:45",
                "14:00","14:15","14:30","14:45",
                "15:00","15:15","15:30","15:45",
                "16:00","16:15","16:30","16:45",
                "17:00","17:15","17:30","17:45",
                "18:00","18:15","18:30","18:45",
                "19:00","19:15",
                "21:00","21:15","21:30","21:45"],
               ["06:00","06:15","06:30","06:45",  # vazio - verão
                "07:00","07:15","07:30","07:45",
                "22:00","22:15","22:30","22:45",
                "23:00","23:15","23:30","23:45",
                "00:00","00:15","00:30","00:45",
                "01:00","01:15","01:30","01:45"],
               ["02:00","02:15","02:30","02:45",  # super-vazio - verão
                "03:00","03:15","03:30","03:45",
                "04:00","04:15","04:30","04:45",
                "05:00","05:15","05:30","05:45"]]                
               ]
  end

  def self.ciclo_semanal
    # inverno úteis = [[pontas],[cheias],[vazionormal], [supervazio]],
    # inverno sab =    [[pontas],[cheias],[vazionormal], [supervazio]],
    # inverno dom =    [[pontas],[cheias],[vazionormal], [supervazio]]]
 
    # verao úteis = [pontas],[cheias],[vazionormal], [supervazio]]],
    # verao sab = [pontas],[cheias],[vazionormal], [supervazio]]],
    # verao dom = [pontas],[cheias],[vazionormal], [supervazio]]]

    periodos_inverno = [
               [["09:30","09:45",                   # pontas uteis - inverno
                 "10:00","10:15","10:30","10:45",
                 "11:00","11:15","11:30","11:45",
                 "18:30","18:45",
                 "19:00","19:15","19:30","19:45",
                 "20:00","20:15","20:30","20:45"],
                ["07:00","07:15","07:30","07:45",   # cheias uteis - inverno
                 "08:00","08:15","08:30","08:45",  
                 "09:00","09:15",
                 "12:00","12:15","12:30","12:45",
                 "13:00","13:15","13:30","13:45",
                 "14:00","14:15","14:30","14:45",
                 "15:00","15:15","15:30","15:45",
                 "16:00","16:15","16:30","16:45",
                 "17:00","17:15","17:30","17:45",
                 "18:00","18:15",
                 "21:00","21:15","21:30","21:45",
                 "22:00","22:15","22:30","22:45",
                 "23:00","23:15","23:30","23:45"],
                ["06:00","06:15","06:30","06:45",     # vazio uteis - inverno
                 "00:00","00:15","00:30","00:45",
                 "01:00","01:15","01:30","01:45"],
                ["02:00","02:15","02:30","02:45",     # super-vazio uteis- inverno
                 "03:00","03:15","03:30","03:45",
                 "04:00","04:15","04:30","04:45",
                 "05:00","05:15","05:30","05:45"]],
               [[0],                                 # pontas uteis - inverno
                ["09:30","09:45",                     # cheias Sab - inverno
                 "10:00","10:15","10:30","10:45",
                 "11:00","11:15","11:30","11:45",
                 "12:00","12:15","12:30","12:45",
                 "18:30","18:45",
                 "19:00","19:15","19:30","19:45",
                 "20:00","20:15","20:30","20:45",
                 "21:00","21:15","21:30","21:45"],
                ["06:00","06:15","06:30","06:45",     # vazio Sab - inverno
                 "07:00","07:15","07:30","07:45",
                 "08:00","08:15","08:30","08:45",  
                 "09:00","09:15",
                 "13:00","13:15","13:30","13:45",
                 "14:00","14:15","14:30","14:45",
                 "15:00","15:15","15:30","15:45",
                 "16:00","16:15","16:30","16:45",
                 "17:00","17:15","17:30","17:45",
                 "18:00","18:15",
                 "22:00","22:15","22:30","22:45",
                 "23:00","23:15","23:30","23:45",
                 "00:00","00:15","00:30","00:45",
                 "01:00","01:15","01:30","01:45"],
                ["02:00","02:15","02:30","02:45",     # super-vazio Sab - inverno
                 "03:00","03:15","03:30","03:45",
                 "04:00","04:15","04:30","04:45",
                 "05:00","05:15","05:30","05:45"]],
               [[0],                                  # pontas uteis - inverno
                [0],                                  # cheias Sab - inverno
                ["06:00","06:15","06:30","06:45",     # vazio dom - inverno
                 "07:00","07:15","07:30","07:45",
                 "08:00","08:15","08:30","08:45",  
                 "09:00","09:15","09:30","09:45",
                 "10:00","10:15","10:30","10:45",
                 "11:00","11:15","11:30","11:45",
                 "12:00","12:15","12:30","12:45",
                 "13:00","13:15","13:30","13:45",
                 "14:00","14:15","14:30","14:45",
                 "15:00","15:15","15:30","15:45",
                 "16:00","16:15","16:30","16:45",
                 "17:00","17:15","17:30","17:45",
                 "18:00","18:15","18:30","18:45",
                 "19:00","19:15","19:30","19:45",
                 "20:00","20:15","20:30","20:45",
                 "21:00","21:15","21:30","21:45",                 
                 "22:00","22:15","22:30","22:45",
                 "23:00","23:15","23:30","23:45",
                 "00:00","00:15","00:30","00:45",
                 "01:00","01:15","01:30","01:45"],
                ["02:00","02:15","02:30","02:45",     # super-vazio dom - inverno
                 "03:00","03:15","03:30","03:45",
                 "04:00","04:15","04:30","04:45",
                 "05:00","05:15","05:30","05:45"]]
                ]
  
periodos_verao = [
               [["09:15","09:30","09:45",           # pontas uteis - verao
                 "10:00","10:15","10:30","10:45",
                 "11:00","11:15","11:30","11:45",
                 "12:00"],
                ["07:00","07:15","07:30","07:45",   # cheias uteis - verao
                 "08:00","08:15","08:30","08:45",  
                 "09:00",
                 "12:15","12:30","12:45",
                 "13:00","13:15","13:30","13:45",
                 "14:00","14:15","14:30","14:45",
                 "15:00","15:15","15:30","15:45",
                 "16:00","16:15","16:30","16:45",
                 "17:00","17:15","17:30","17:45",
                 "18:00","18:15","18:30","18:45",
                 "19:00","19:15","19:30","19:45",
                 "20:00","20:15","20:30","20:45",
                 "21:00","21:15","21:30","21:45",                 
                 "22:00","22:15","22:30","22:45",
                 "23:00","23:15","23:30","23:45"],
                ["06:00","06:15","06:30","06:45",     # vazio uteis - verao
                 "00:00","00:15","00:30","00:45",
                 "01:00","01:15","01:30","01:45"],
                ["02:00","02:15","02:30","02:45",     # super-vazio uteis- verao
                 "03:00","03:15","03:30","03:45",
                 "04:00","04:15","04:30","04:45",
                 "05:00","05:15","05:30","05:45"]],
               [[0],                                 # pontas uteis - verao
                ["09:00","09:15","09:30","09:45",    # cheias Sab - verao
                 "10:00","10:15","10:30","10:45",
                 "11:00","11:15","11:30","11:45",
                 "12:00","12:15","12:30","12:45",
                 "13:00","13:15","13:30","13:45",
                 "20:00","20:15","20:30","20:45",
                 "21:00","21:15","21:30","21:45"],                
                ["06:00","06:15","06:30","06:45",     # vazio Sab - verao
                 "07:00","07:15","07:30","07:45",
                 "08:00","08:15","08:30","08:45",  
                 "14:00","14:15","14:30","14:45",
                 "15:00","15:15","15:30","15:45",
                 "16:00","16:15","16:30","16:45",
                 "17:00","17:15","17:30","17:45",
                 "18:00","18:15","18:30","18:45",
                 "19:00","19:15","19:30","19:45",                 
                 "22:00","22:15","22:30","22:45",
                 "23:00","23:15","23:30","23:45",
                 "00:00","00:15","00:30","00:45",
                 "01:00","01:15","01:30","01:45"],
                ["02:00","02:15","02:30","02:45",     # super-vazio Sab - verao
                 "03:00","03:15","03:30","03:45",
                 "04:00","04:15","04:30","04:45",
                 "05:00","05:15","05:30","05:45"]],
               [[0],                                  # pontas uteis - verao
                [0],                                  # cheias Sab - verao
                ["06:00","06:15","06:30","06:45",     # vazio dom - verao
                 "07:00","07:15","07:30","07:45",
                 "08:00","08:15","08:30","08:45",  
                 "09:00","09:15","09:30","09:45",
                 "10:00","10:15","10:30","10:45",
                 "11:00","11:15","11:30","11:45",
                 "12:00","12:15","12:30","12:45",
                 "13:00","13:15","13:30","13:45",
                 "14:00","14:15","14:30","14:45",
                 "15:00","15:15","15:30","15:45",
                 "16:00","16:15","16:30","16:45",
                 "17:00","17:15","17:30","17:45",
                 "18:00","18:15","18:30","18:45",
                 "19:00","19:15","19:30","19:45",
                 "20:00","20:15","20:30","20:45",
                 "21:00","21:15","21:30","21:45",                 
                 "22:00","22:15","22:30","22:45",
                 "23:00","23:15","23:30","23:45",
                 "00:00","00:15","00:30","00:45",
                 "01:00","01:15","01:30","01:45"],
                ["02:00","02:15","02:30","02:45",     # super-vazio dom - verao
                 "03:00","03:15","03:30","03:45",
                 "04:00","04:15","04:30","04:45",
                 "05:00","05:15","05:30","05:45"]]
                ]

    return periodos_inverno, periodos_verao
  end
end