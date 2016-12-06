require_relative "vhelperTarifarios.rb"

class Sites
  def self.lista_sites
    ["alf1p0",
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

  def self.dtcs
    ["alf1p0",
     "alf2a7a8",
     "alf2a1",
     "bvtp1"]
  end

  def self.omcs
    ["alf1p-1",
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

  def self.sites_por_tipo_tensao
    sites = Sites.lista_sites
    sitesBTE = []
    sitesMT = []
    for i in 0...sites.size
      site = Tarifarios.new(sites[i])
      tarifa = site.cria_tarifa_site
      sitesBTE.push(sites[i]) if tarifa[2][1].include? "BTE"
      sitesMT.push(sites[i]) if tarifa[2][1].include? "MT"
    end
    return sitesBTE, sitesMT
  end

  def self.categorias_medicao
    ["global", "avac", "it"]
  end

end
