require_relative "vglobais.rb"
require_relative "vsites.rb"
require_relative "vsitesmes.rb"
require_relative "vtarifas.rb"
require_relative "vtarifasmes.rb"
require_relative "vfuncoes.rb"

system "cls"
lineWidth = 15

#### Procura na diretoria os ficheiros que vai utilizar ################################################
puts "Preparacao de ficheiros".ljust(lineWidth)
ficheiroswm = corre_vfiles
puts "Terminado!".ljust(lineWidth)
puts

#### Gera ficheiros com os consumos globais ################################################
puts "Geracao de ficheiros de consumos globais".ljust(lineWidth)
corre_vglobais(ficheiroswm[0], ficheiroswm[1], ficheiroswm[2])
puts "Terminado!".ljust(lineWidth)
puts

#### Gera ficheiros com os consumos por site ################################################
puts "Preparacao de ficheiros de consumo por site".ljust(lineWidth)
corre_vsites
puts "Terminado!".ljust(lineWidth)
puts

#### Gera ficheiros com os consumos mensais por site ################################################
puts "Preparacao de ficheiros de consumo mensais por site".ljust(lineWidth)
corre_vsitesmes
puts "Terminado!".ljust(lineWidth)
puts

#### Gera ficheiros com os custos por site ################################################
puts "Preparacao de ficheiros de custos por site".ljust(lineWidth)
corre_vtarifas
puts "Terminado!".ljust(lineWidth)
puts

#### Gera ficheiros com os custos mensais por site ################################################
puts "Preparacao de ficheiros de custos mensais por site".ljust(lineWidth)
corre_vtarifasmes
puts "Terminado!".ljust(lineWidth)
puts